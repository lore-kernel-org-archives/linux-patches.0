Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41487429CCA;
	Thu, 16 Jul 2026 14:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211875; cv=none; b=arySjG1NG7joxcEeKP0b42FosWXO+7KeAXVXdUeVpO6fsShnoTKsc7hanAcYd37TM4MbeCr2bF+Pv2xmLbtFLDo39/HNyOaWPHsd844rWahWbp204adEyqnBpXvhgCor9FLOBvqcnsMrbgwoazHiYXoL22lCtby+szO2bzgIpEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211875; c=relaxed/simple;
	bh=xOKoiYY95OcF3fjZ87c+XGM4oKzL5LwjPZToC57XtYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvBuQ99qREl1ecMNooVsPi47w4dyXS37rcTkhi3gU9xLg/hbfyUk2dly9BkUDU1SYHnNBuv1uRUX/qV9lFUgTjgMiUDH1LGgrGbeXx4kz7xQroc4gZqpQqvdJiwjiABegRBazJzVTzK1c9OM3AYwkPdtwDUvjpHfS4HHo5zHeOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzJVCbPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzJVCbPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63B61F00A3A;
	Thu, 16 Jul 2026 14:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211874;
	bh=c02Zn9OqKDP9yWqkuKJ9hkzTz51sNO6WAV0HbDT1Qck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzJVCbPc9Wd57ESz9ksTHqNraluwJLzDpFNRVXy0AMHzGj0294xocoXxOOQchcJeR
	 wqAHfWeluKESJzrA90dIbCN8+Ov/WXfAC8+gcNUqU5fqMF6/oQCS+hmU6pGI7RzSfp
	 we2l3ZcgGxsL8V4SO92KzzuzMIKIwHtuFiq5r9mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Tautschnig <tautschn@amazon.com>
Subject: [PATCH 6.12 114/349] staging: vme_user: bound slave read/write to the kern_buf size
Date: Thu, 16 Jul 2026 15:30:48 +0200
Message-ID: <20260716133035.864371689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Michael Tautschnig <tautschn@amazon.com>

commit 9f32f38265014fac7f5dc9490fb01a638ce6e121 upstream.

The SLAVE-path helpers buffer_to_user() and buffer_from_user() copy
'count' bytes into/out of the fixed-size kern_buf (size_buf ==
PCI_BUF_SIZE == 0x20000, 128 KiB) using *ppos as the offset, without
bounding *ppos + count against size_buf.

vme_user_write()/vme_user_read() only clamp count to the VME window size
(image_size = vme_get_size(resource)), which VME_SET_SLAVE sets from the
user-supplied slave.size -- validated against the VME address space (up
to VME_A32_MAX = 4 GiB), not against PCI_BUF_SIZE.  When the window
exceeds 128 KiB, a write()/read() copies past the kern_buf allocation.

Clamp count against size_buf in both helpers, with an early return when
*ppos is already at/after the buffer end.  *ppos is >= 0 here (the caller
rejects negative offsets), so size_buf - *ppos cannot wrap.  This mirrors
the existing clamp in the MASTER-path helpers resource_to_user() /
resource_from_user(), and matches the read()/write() convention of a
short transfer at end-of-buffer.

Found by static analysis (CodeQL taint tracking + CBMC bounded model
checking) and confirmed dynamically under KASAN with the vme_fake bridge:

  BUG: KASAN: slab-out-of-bounds in _copy_from_user+0x2d/0x80
  Write of size 262144 at addr ffff888004100000 by task trigger/68
    _copy_from_user+0x2d/0x80
    vme_user_write+0x13e/0x240 [vme_user]
    vfs_write+0x1b8/0x7a0
    ksys_write+0xb8/0x150

Fixes: f00a86d98a1e ("Staging: vme: add VME userspace driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Tautschnig <tautschn@amazon.com>
Link: https://patch.msgid.link/20260618114709.72499-1-tautschn@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vme_user/vme_user.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/staging/vme_user/vme_user.c
+++ b/drivers/staging/vme_user/vme_user.c
@@ -156,6 +156,17 @@ static ssize_t buffer_to_user(unsigned i
 {
 	void *image_ptr;
 
+	/*
+	 * The slave window (image_size) can exceed the fixed kern_buf
+	 * (size_buf == PCI_BUF_SIZE), so bound the copy to kern_buf.
+	 * *ppos is >= 0 here (checked by the caller), so the
+	 * subtraction below cannot wrap.
+	 */
+	if (*ppos >= image[minor].size_buf)
+		return 0;
+	if (count > image[minor].size_buf - *ppos)
+		count = image[minor].size_buf - *ppos;
+
 	image_ptr = image[minor].kern_buf + *ppos;
 	if (copy_to_user(buf, image_ptr, (unsigned long)count))
 		return -EFAULT;
@@ -168,6 +179,17 @@ static ssize_t buffer_from_user(unsigned
 {
 	void *image_ptr;
 
+	/*
+	 * The slave window (image_size) can exceed the fixed kern_buf
+	 * (size_buf == PCI_BUF_SIZE), so bound the copy to kern_buf.
+	 * *ppos is >= 0 here (checked by the caller), so the
+	 * subtraction below cannot wrap.
+	 */
+	if (*ppos >= image[minor].size_buf)
+		return 0;
+	if (count > image[minor].size_buf - *ppos)
+		count = image[minor].size_buf - *ppos;
+
 	image_ptr = image[minor].kern_buf + *ppos;
 	if (copy_from_user(image_ptr, buf, (unsigned long)count))
 		return -EFAULT;


