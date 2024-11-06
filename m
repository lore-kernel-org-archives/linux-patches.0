Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDFE198E96;
	Wed,  6 Nov 2024 12:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896430; cv=none; b=mvNj91xCZWodZACH7h0tH7XPJECFJTTQDEcrLvYpjjZVeb+2u7lcd6IgQNIAkdLrLCN8WgzfzH8gsAF8oaEqIJZFpjjZ4qEEroQnXRdsr6P8oVOiQFMHdKAMAUlt5KGEoosobvtyWXTly0OJyhWTIF5dJxjv3FqMfM+jvIua7LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896430; c=relaxed/simple;
	bh=/9YKwSPT2PpRoHwCTdKnzdYO+0WLdUWuffRe91JCzjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gagkYoH16+YUhGijEW78y4tCpHAIUxpflL3kzsqpDrwlZmcp0+n4uLm5Hi6xHzSfcPlbDqnD1OyJ7KIlc5ICPz1covjhJVOFnF/UuKFGFEDluIrmUCgukV77oZgO97tzz5NP7ItjkM3Y3NHnZUCtX41evC+SonWgYN7mPA+GmNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMOynjwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMOynjwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4669C4CECD;
	Wed,  6 Nov 2024 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896430;
	bh=/9YKwSPT2PpRoHwCTdKnzdYO+0WLdUWuffRe91JCzjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMOynjwcQjAA5d+vMSvgFDIZefP2XkzPEnwKoM9bmoLxITrBImbmAo0/cDB24iJ1E
	 6FnRIJA1TSl90Cf/m2KO5B6VHsVx2Ba7+XEc4HT6JmElXQL+QsE6kwsCX6F1LFPlfY
	 rs752agZdMUH1S94NP5uzb/crzARRYYdVnNyG/Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 162/245] cxl/port: Fix cxl_bus_rescan() vs bus_rescan_devices()
Date: Wed,  6 Nov 2024 13:03:35 +0100
Message-ID: <20241106120323.223459944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 3d6ebf16438de5d712030fefbb4182b46373d677 ]

It turns out since its original introduction, pre-2.6.12,
bus_rescan_devices() has skipped devices that might be in the process of
attaching or detaching from their driver. For CXL this behavior is
unwanted and expects that cxl_bus_rescan() is a probe barrier.

That behavior is simple enough to achieve with bus_for_each_dev() paired
with call to device_attach(), and it is unclear why bus_rescan_devices()
took the position of lockless consumption of dev->driver which is racy.

The "Fixes:" but no "Cc: stable" on this patch reflects that the issue
is merely by inspection since the bug that triggered the discovery of
this potential problem [1] is fixed by other means.  However, a stable
backport should do no harm.

Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
Link: http://lore.kernel.org/20241004212504.1246-1-gourry@gourry.net [1]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/172964781104.81806.4277549800082443769.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 1d5007e3795a3..d3237346f6877 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2088,11 +2088,18 @@ static void cxl_bus_remove(struct device *dev)
 
 static struct workqueue_struct *cxl_bus_wq;
 
-static void cxl_bus_rescan_queue(struct work_struct *w)
+static int cxl_rescan_attach(struct device *dev, void *data)
 {
-	int rc = bus_rescan_devices(&cxl_bus_type);
+	int rc = device_attach(dev);
+
+	dev_vdbg(dev, "rescan: %s\n", rc ? "attach" : "detached");
 
-	pr_debug("CXL bus rescan result: %d\n", rc);
+	return 0;
+}
+
+static void cxl_bus_rescan_queue(struct work_struct *w)
+{
+	bus_for_each_dev(&cxl_bus_type, NULL, NULL, cxl_rescan_attach);
 }
 
 void cxl_bus_rescan(void)
-- 
2.43.0



