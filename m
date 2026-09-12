Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E341C5799;
	Sat, 12 Sep 2026 18:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239452; cv=none; b=YyqEI3t1B11REV64eM5U/mMARN066XT86Pmj/Kj06PGNLNFW4yanmwlgIlFscvDk4XwvTdZZ0MTVf4mYeKG/VhZ0+csJUwmzEEtzXx7FSlGnoCNN8Vv5yTy4bM4MRID7kwkrbEUmOZCWNWxttNLm4g2qhpiaVQtbBkTPSIWyjko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239452; c=relaxed/simple;
	bh=Brp1MIGQktlu8+Nt9T3r17T00g+PYEoHc4rbhxpOBQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPrXpp0l3dtEZ5AEdhJ8SirEGpQRoFqWCHWFZnGjBGVGIg5YGxBMBSI1IX07f2U7NTjKesohc4cP25BT0cSVbYYnB6ySXajm2TWuQWblRtvmlIVnvFJfJqc0amO9VwusVtw4sbtS09Ppm4zsZNzeLag9qNHj/zgfa+xHwkTjykc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+hIDcs+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+hIDcs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD9C1F000FF;
	Sat, 12 Sep 2026 18:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239451;
	bh=MStWk7T/U1/zPpPWwegVUFnduP4DLI7yvoZE9PfQDH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+hIDcs+NjsBbg++llx0WlN1oWngSuUSdThMzgsZsGU75YlPo0s1EkrJuAj2R752L
	 yQ395n/JBGArI0JDe+s+jj8I8a5PrN6qrmZ1xxRp6TKoLA+PmiF4CrA30w798T3diy
	 JMJKOQjY6ydextMXUD5va3FFd3hgJB+jCBPg1G0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titouan Ameline de Cadeville <titouan.ameline@gmail.com>,
	Julius Werner <jwerner@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 666/935] firmware: google: Add bounds checks in coreboot_table_populate()
Date: Sat, 12 Sep 2026 09:01:36 +0200
Message-ID: <20260912065542.116506702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>

[ Upstream commit 7b1a1af4556a4f95ef273e91435fe804cbfcd223 ]

coreboot_table_populate() iterates over firmware-provided table entries
with no validation that the entries stay within the mapped memory
region.  A corrupt table with a large `entry->size` advances `ptr_entry`
past the mapped region, causing an out-of-bounds read on the next
iteration.

Add a check before dereferencing `ptr_entry` to ensure the entry header
is readable, and a second check after reading `entry->size` to ensure
the full entry stays within the mapped region.

Pass `len` from coreboot_table_probe() into coreboot_table_populate() to
make the mapped region size available for validation.

Signed-off-by: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Link: https://lore.kernel.org/r/20260426214739.117131-1-titouan.ameline@gmail.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Stable-dep-of: a58a57a1076f ("firmware: coreboot: Validate table bounds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/coreboot_table.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index f3694d3478019..95fc2e4d0cccf 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -81,16 +81,20 @@ void coreboot_driver_unregister(struct coreboot_driver *driver)
 }
 EXPORT_SYMBOL(coreboot_driver_unregister);
 
-static int coreboot_table_populate(struct device *dev, void *ptr)
+static int coreboot_table_populate(struct device *dev, void *ptr, resource_size_t len)
 {
 	int i, ret;
 	void *ptr_entry;
 	struct coreboot_device *device;
 	struct coreboot_table_entry *entry;
 	struct coreboot_table_header *header = ptr;
+	void *ptr_end;
 
+	ptr_end = ptr + len;
 	ptr_entry = ptr + header->header_bytes;
 	for (i = 0; i < header->table_entries; i++) {
+		if (ptr_entry + sizeof(*entry) > ptr_end)
+			return -EINVAL;
 		entry = ptr_entry;
 
 		if (entry->size < sizeof(*entry)) {
@@ -98,6 +102,9 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 			return -EINVAL;
 		}
 
+		if (ptr_entry + entry->size > ptr_end)
+			return -EINVAL;
+
 		device = kzalloc(sizeof(device->dev) + entry->size, GFP_KERNEL);
 		if (!device)
 			return -ENOMEM;
@@ -154,7 +161,7 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = coreboot_table_populate(dev, ptr);
+	ret = coreboot_table_populate(dev, ptr, len);
 
 	memunmap(ptr);
 
-- 
2.53.0



