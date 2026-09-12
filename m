Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41521DE4EF;
	Sat, 12 Sep 2026 14:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223866; cv=none; b=OCPG3MCcdPMSWjeF3Mh98/BYXqDBp6KaavwFtKBF7rOgxgCOG4S96llfG07XdjRyzt15Qtg7/DFzrgNMCi1zkOPV5O+xc1zRAkutJexRG3ZsMkfRPEb/beEajSbZNOTEZkC8iP7AtiCOydMoL+hIQLpwQpMkk5VmvN5W4NLlT1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223866; c=relaxed/simple;
	bh=2+XDDi4VQbxfFFUc5gcXmuYbxaPGmh5RZliXH8sXuhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUM5KLmxEfgrxMWDDd39eIUnYS+e01wh7cnv4iHZNKCEBVf3LGZvrTdXOEx9cfaacZDYa1J9EzxflnlrVcVmciLQjXSNX5r8WCmlN0aXkR9VJFACJgU+Mx9ErTg7g7C4b836hCLXy9QSbIf1YwG+yDr05yC/kPvuvVTGHJ7JE5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vWT7WGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vWT7WGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979D81F000FF;
	Sat, 12 Sep 2026 14:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223864;
	bh=4KiQYSd1u4JQZkkKZHEg7t0uB694cU9Lp8/mpt/aYFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vWT7WGQKf8Re5rk3FA8Iw8lCFCq+V/WV80Dsk3MQ5xOpSopzmtAuN/uFtsXybyJd
	 AUCSZ4uNmybnYNGJwIfmUvPxPcMN+R3T3EjcTmohPHvV/GrN6vH0aWYqYiZhkhmCCL
	 G3dB3TYWOV9XNP0kCe+LG+aNoL8MWsHQ4byl73yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0877/1424] cxl/region: Fix use-after-free in find_pos_and_ways() error path
Date: Sat, 12 Sep 2026 08:55:09 +0200
Message-ID: <20260912065626.962993171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 15da704b732332cc1e8f121f624e5e6c05124c5d ]

The error path releases its reference to a switch decoder before
logging an error that includes the decoder name. If the released
reference is the last one, the decoder can be freed before the error
message accesses its name.

Drop the reference after the error is reported.

Fixes: d90acdf49e18 ("cxl/region: Add a dev_err() on missing target list entries")
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/10deb519b543ef693ce23148b509a03fe1c07d0c.1784931354.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 1728cae1e8409..af4f8bbe63c44 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1651,14 +1651,13 @@ static int find_pos_and_ways(struct cxl_port *port, struct range *range,
 			break;
 		}
 	}
-	put_device(dev);
-
 	if (rc)
 		dev_err(port->uport_dev,
 			"failed to find %s:%s in target list of %s\n",
 			dev_name(&port->dev),
-			dev_name(port->parent_dport->dport_dev),
-			dev_name(&cxlsd->cxld.dev));
+			dev_name(port->parent_dport->dport_dev), dev_name(dev));
+
+	put_device(dev);
 
 	return rc;
 }
-- 
2.53.0



