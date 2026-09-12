Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89023446AD;
	Sat, 12 Sep 2026 12:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217017; cv=none; b=sB4zMo7G+Zfy7Bk1vprRNOzuN83bvnjzPLo+ggaB32mpR+2wjcSWNdJP3f2Jzv1FR9zi45hJrwe/5VQmUhw7UAS7/7CB2eQhnvQkCKB1bRvi68gi5wQnnTVqDgz67pRtxqkLPeLqIOQB7eKxsXhLCow3npbWP4XEngt1pOibkkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217017; c=relaxed/simple;
	bh=WWS66gy4oMZSl7bh5rqq+lw0/7F/7xETLTeD41ROz4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCh4CLG1uRz0wHjRatshDjMCzCxGZuYL3ESushYGqr4EIYc2E/awUdGt8d4iEY4xAoYTTaxfP34ftp090/GC17obC7O3POva1KJK5GHHXcTo7R6pDXbCIN/2PI/7EyEFYEjSMNr1BGyKindeeGHWzZpUB2bdSSAjY5M6/xq1hwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/r5ms44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/r5ms44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F7D1F000FF;
	Sat, 12 Sep 2026 12:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217015;
	bh=G/MVKE2VIfilY+xSAjdQfxjkFtBw4J7Bt6+MWNlT6mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r/r5ms44ceCkSRA0lfsa8WAUIXilYSLveJDVbgYFlG4NVuTC/PHTS8E+PErMTEt1s
	 ku4F1yGMyovBDZzODk4FoIDTinZAwyASsGmxDJ+yitPBrVCISKH6/h8RRF3bKscJoj
	 6dFT2VsnWfC3KhUzdn168wUfl38qsRLrRL0tmR3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0855/1376] firmware: coreboot: Validate table bounds
Date: Sat, 12 Sep 2026 08:54:41 +0200
Message-ID: <20260912065626.617072011@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit a58a57a1076f8c5dae0327e3710899478c3be901 ]

The existing coreboot_table_populate() bounds checks limit individual
entries to the mapped length.  However, coreboot_table_probe() replaces
the platform resource length with header and table sizes supplied by
firmware before mapping the full table.

A malformed table can overflow the 32-bit size addition or advertise an
extent beyond the resource, causing the driver to map and parse memory
outside the resource.  A resource shorter than the fixed header is also
mapped as though it contained a complete header.

Reject resources shorter than the fixed header.  After validating the
signature, require a complete header, calculate the advertised extent
with overflow checking, and reject extents beyond the resource before
remapping the table.

Fixes: d384d6f43d1e ("firmware: google memconsole: Add coreboot support")
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Link: https://lore.kernel.org/r/20260801165651.42172-1-acharyalaxman8848@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/coreboot_table.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 0cf613944951e..3a7b9b432b9a2 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -159,6 +159,7 @@ static int coreboot_table_populate(struct device *dev, void *ptr, resource_size_
 static int coreboot_table_probe(struct platform_device *pdev)
 {
 	resource_size_t len;
+	resource_size_t table_span;
 	struct coreboot_table_header *header;
 	struct resource *res;
 	struct device *dev = &pdev->dev;
@@ -170,7 +171,7 @@ static int coreboot_table_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	len = resource_size(res);
-	if (!res->start || !len)
+	if (!res->start || len < sizeof(*header))
 		return -EINVAL;
 
 	/* Check just the header first to make sure things are sane */
@@ -178,19 +179,27 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	if (!header)
 		return -ENOMEM;
 
-	len = header->header_bytes + header->table_bytes;
 	ret = strncmp(header->signature, "LBIO", sizeof(header->signature));
+
+	if (!ret &&
+	    (header->header_bytes < sizeof(*header) ||
+	     check_add_overflow((resource_size_t)header->header_bytes,
+				(resource_size_t)header->table_bytes,
+				&table_span) ||
+	     table_span > len))
+		ret = -EINVAL;
+
 	memunmap(header);
 	if (ret) {
 		dev_warn(dev, "coreboot table missing or corrupt!\n");
 		return -ENODEV;
 	}
 
-	ptr = memremap(res->start, len, MEMREMAP_WB);
+	ptr = memremap(res->start, table_span, MEMREMAP_WB);
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = coreboot_table_populate(dev, ptr, len);
+	ret = coreboot_table_populate(dev, ptr, table_span);
 
 	memunmap(ptr);
 
-- 
2.53.0



