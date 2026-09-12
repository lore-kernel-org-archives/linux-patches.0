Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A8547A0B6;
	Sat, 12 Sep 2026 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216196; cv=none; b=fR9nxU7Yhbla+oZYKeA9jJ3hn5NvY4LJ3/icVJiD8CJ/8YA9kIc751e+TgtrkGZP93kMp6eppfYULqCrettO4OuSl2c0UdWHXmuUnwAx6AJ7kLlCds9rfPTD/nRSi4RT0iuLuxPF/2IvhEcwdIBzV7pEr6UIbfvPujgCdx2dMu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216196; c=relaxed/simple;
	bh=BD0xDG9sdikbw7kMTq2C+hG2MDK0B2QUZ7UzucPEYOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP4FAsS53BThy3R21OpZBDIZu25MHSlEYZDihPaGJN0KLTtv1mW6kGrGiobdrR/4DCxXFEDb58uBuDv3rNHYx0SRUv0hsHWHCS0otqy4gK2vPyR5fECG1KZr43T/WLDD/18xS0BmeZETTV4Doe26KUTglaXV85DlB0a2FAs3/8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qz1MXhg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qz1MXhg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C357D1F000FF;
	Sat, 12 Sep 2026 12:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216193;
	bh=pLBBnuDgcxGIiDKKjkH2qT38618iZqRJjQlL5ovNhE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qz1MXhg7m0u51NaeRmtOjXRGmHYDrZnAxV+wg+ebGAZ7j5J88DS9dZ8mm+U9B2UCE
	 x9VcehHhmAqsXjtUMmV27nLaR75Hlgfdt/aW8xsdhCJpRA4NA61SUhA/HRdqjKzhEB
	 WgAECqr4EEcgzsR64tBNxGidCfScTvBU5vkgF5n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0686/1376] cxl/region: Fix use-after-free in find_pos_and_ways() error path
Date: Sat, 12 Sep 2026 08:51:52 +0200
Message-ID: <20260912065622.835892842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f5429666822f0..009c0a262ee8d 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1779,14 +1779,13 @@ static int find_pos_and_ways(struct cxl_port *port, struct range *range,
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



