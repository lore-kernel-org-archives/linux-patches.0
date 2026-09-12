Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04ED29D288;
	Sat, 12 Sep 2026 19:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242923; cv=none; b=Wo/9vxuPTrPCV7k7z2LqSY2OGlR8ieow/ufhT7/Qk+h6DB14ga4jWN0oS60tga2v6FyXOc+/A5IikehrA773e6u+e7j8y/bd5ggzl+db3yQ7zS6QD3z4zmu8M3Mi0JS+IaKi56S5MiGEwpmpvDp8AoHz+qNier4ydSPaaGdyu2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242923; c=relaxed/simple;
	bh=EskX67MhdGCG5JiyCf4FJgyAOHXSManItonbaiGzxeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHfvJVQTs/c/zlFi2PsHfLP5xWGvdit0N9jru8UNPKcUrDKpAX03FO+y7taRFa7y4/6eTLZG1MF25Y8aUu/6Dsb4YmGTq0Uw9ZQCJkUx2SEBkB6/4PLcfN+wd4GmxPUurRS+Lph4Lqz22j/lvpM8MMF7sFoSxZBK/laAHYFG9kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h18VEmaV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h18VEmaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BA91F000FF;
	Sat, 12 Sep 2026 19:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242921;
	bh=ztUL2rkPmZrCzGizvUT8T6rwnB4Jk1rq7IV3gdoeQJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h18VEmaVsFUBYyAtpiAlcsWInqBOiAt7Hiuo8cFjJI8l68I6mLjEZNzbYcUkf8sAm
	 HmVUriK0JUNyV2cRR4PmQkpAfYWOOsdCoaX3yr8uULeSPExTYC8NJz+2y9Zzn1HaGn
	 sBN7Ii0Hl4gacUEtOW4/HYH0k3WLfUH+LJUmRdwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 575/798] firmware: coreboot: Validate table bounds
Date: Sat, 12 Sep 2026 09:03:23 +0200
Message-ID: <20260912065530.310535030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 32657b6bb316b..a554359ad57d4 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -133,6 +133,7 @@ static int coreboot_table_populate(struct device *dev, void *ptr, resource_size_
 static int coreboot_table_probe(struct platform_device *pdev)
 {
 	resource_size_t len;
+	resource_size_t table_span;
 	struct coreboot_table_header *header;
 	struct resource *res;
 	struct device *dev = &pdev->dev;
@@ -144,7 +145,7 @@ static int coreboot_table_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	len = resource_size(res);
-	if (!res->start || !len)
+	if (!res->start || len < sizeof(*header))
 		return -EINVAL;
 
 	/* Check just the header first to make sure things are sane */
@@ -152,19 +153,27 @@ static int coreboot_table_probe(struct platform_device *pdev)
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



