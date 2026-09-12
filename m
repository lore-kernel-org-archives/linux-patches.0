Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B1C3644BE;
	Sat, 12 Sep 2026 07:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199766; cv=none; b=ZLdVTazW7FJxtBKpqzcFAGsHMd6mAFAaSMOosXwajPsmDqgytli0PfbTj7dXipfC46o0cD6ABvX097XwXp6dZTnTgxywtEFQw8kJRPs3Anhwkz6jiMq6NgxTchOgQhJAACMmy+TZNBw8ppbxcpZnIy2BI/7xe9MvY7RiYbtjUmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199766; c=relaxed/simple;
	bh=zu/v0kicPXCXZcAJ7+E/xZSZv5jYG3Rx7qQrk6WLr7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5n1CHOsbhjS6z3YRYP8GWbLb0U3x/GgPGcUgJjDOHpen4Z9FAdRELvzU3aY41d+92/40nMIFBcuYXdHnQHzeuzwIS976nBbw547Ul85yiTGl+bLn3p12btskpme1MM8FAqz40gHj7erBIQ+JOAf56G/hRruoDgGWDBZzqBCwlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnRunRxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnRunRxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B9B1F000FF;
	Sat, 12 Sep 2026 07:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199765;
	bh=Ag0kTkzVMEXh9fe6s36xPthLAIk+V10akye/7NRR944=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnRunRxDokVRcgYx2xL8z8x7YzGhaywTCF6/9tudPMRYVx18gNFCqWXGjvso0LIh6
	 ExRqlIoGs+GklXhzIwgZFwCcKQSHMeQ472i7Bmb4Jjlj6AU7c3/0Si69avl+w/WXjm
	 hDpjrqJpe1Gm+IckOJ9iIgvQL+SXettMTAp+pwX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0653/1815] cxl/region: Fix use-after-free in find_pos_and_ways() error path
Date: Sat, 12 Sep 2026 08:40:03 +0200
Message-ID: <20260912065704.208121181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 578622240401d..8b0005a57d03c 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1939,14 +1939,13 @@ static int find_pos_and_ways(struct cxl_port *port, struct range *range,
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



