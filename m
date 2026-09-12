Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290DC37E2E7;
	Sat, 12 Sep 2026 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217012; cv=none; b=qaoUqsrVjFQ8rAlj3qdRty1FDu6tgsQ6vqIMAFFddWMX7wTYR1zrpwlHtqZQ3XLcDF6CafEryY34MtACOgMed6uDcqVRqHBH1nNxMOEiK7oAen562FyBqM0P5v2FcSdO26StfFuK2Sw+0WzD0nEULXY481J3FowbgWgU4ilfeF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217012; c=relaxed/simple;
	bh=aTGnWiWdM/vrQgwbQIqAP7w/v5otmH7SxUOgbYYzFSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQ2kkg0iMAiZ45/KqRQHZ4IYFuD0XQFxpIpcl4QrnT35DcYtv90N96OHq4xJ+BE4f1V3mJ9LGrdlVsNYpRFoa8GG2IxSiNXbBcrfdPfKLnPyq9pfjylHIFj5oFHQfF0uD0DUr4frWvNr4kouFQk+nIhSfaFGl6+3dPSJnibXRCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTSLgGux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTSLgGux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC081F000FF;
	Sat, 12 Sep 2026 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217011;
	bh=Ri/dMTNpqa7Z8UhuPHyfq4JYK4Bz3r3gZasiGfKBvb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTSLgGuxrlXisJkGus/P3HWnNCeBUKmfZtH5WyVjivB2uGD1CPo7/9kCHQIdFEQus
	 7fV5OowKPAuf+xKoWvr+2xCirPtHOMnGeStYLcDyNV/jWKnoH0VIntsX0Rgb+9epxd
	 H1y3Msd5tDRzSu9DGpCH2iNSHvVYhFfaIUrPVGF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Titouan Ameline de Cadeville <titouan.ameline@gmail.com>,
	Julius Werner <jwerner@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0854/1376] firmware: google: Add bounds checks in coreboot_table_populate()
Date: Sat, 12 Sep 2026 08:54:40 +0200
Message-ID: <20260912065626.595751899@linuxfoundation.org>
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
index 208652a8087cd..0cf613944951e 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -101,16 +101,20 @@ void coreboot_driver_unregister(struct coreboot_driver *driver)
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
@@ -118,6 +122,9 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 			return -EINVAL;
 		}
 
+		if (ptr_entry + entry->size > ptr_end)
+			return -EINVAL;
+
 		device = kzalloc(sizeof(device->dev) + entry->size, GFP_KERNEL);
 		if (!device)
 			return -ENOMEM;
@@ -183,7 +190,7 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = coreboot_table_populate(dev, ptr);
+	ret = coreboot_table_populate(dev, ptr, len);
 
 	memunmap(ptr);
 
-- 
2.53.0



