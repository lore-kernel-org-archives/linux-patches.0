Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CC332C958;
	Fri, 17 Oct 2025 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714525; cv=none; b=MSTR0mEBwl4UGk/F1yh+cJu3IcVGkpOyfPn32EZIw2zcPwzDh8qeu/GKqXEOUVfYgdXbYS0nNz5IWpGL1g+rkXL8iYnNz9UytSNy1m8wLP9dBSeF/KiIvVaC9bdu/U2F89yom4nxB2J6lC7YIWtBvUDvWCSCQQa2rVRTsdfGPa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714525; c=relaxed/simple;
	bh=msmyFF4YU66q7SpW2ZDMPieycUAdP75xS9uAE5y70Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIhoiVR/u0HGhi23KnZ21AOpSIs+9m2GeW/910PYduFm7kAeSfyfwGBmz0figdCbVaKRCILbnMWUvklFfQ2tp8aF4XxIVe/8cHFQEe35xrqTICOGe6lgp1S2cnfa4jG/a5FCoSrYBUBLKyuUK6s3mn2t1rlGmE427bIsbc9c+CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkULcv55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkULcv55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2BDC4CEE7;
	Fri, 17 Oct 2025 15:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714524;
	bh=msmyFF4YU66q7SpW2ZDMPieycUAdP75xS9uAE5y70Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkULcv55bpJa2lRd2zptpnodpR/Zqzbu1Q2MLfSf1ksCx41/QFYDmIqHs2J7goZ+T
	 U/FNQaBEG7ZlnkTATg7p1DCRnbYiEisucw7xVM+Ionw6onY/7xP5XMBjT40cD82WbD
	 SXp4Sf7REH7g2KIm9OA0lc4/WZBJ8LK427tctGUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 142/277] init: handle bootloader identifier in kernel parameters
Date: Fri, 17 Oct 2025 16:52:29 +0200
Message-ID: <20251017145152.310145211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit e416f0ed3c500c05c55fb62ee62662717b1c7f71 upstream.

BootLoaders (Grub, LILO, etc) may pass an identifier such as "BOOT_IMAGE=
/boot/vmlinuz-x.y.z" to kernel parameters.  But these identifiers are not
recognized by the kernel itself so will be passed to userspace.  However
user space init program also don't recognize it.

KEXEC/KDUMP (kexec-tools) may also pass an identifier such as "kexec" on
some architectures.

We cannot change BootLoader's behavior, because this behavior exists for
many years, and there are already user space programs search BOOT_IMAGE=
in /proc/cmdline to obtain the kernel image locations:

https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/util.go
(search getBootOptions)
https://github.com/linuxdeepin/deepin-ab-recovery/blob/master/main.go
(search getKernelReleaseWithBootOption) So the the best way is handle
(ignore) it by the kernel itself, which can avoid such boot warnings (if
we use something like init=/bin/bash, bootloader identifier can even cause
a crash):

Kernel command line: BOOT_IMAGE=(hd0,1)/vmlinuz-6.x root=/dev/sda3 ro console=tty
Unknown kernel command line parameters "BOOT_IMAGE=(hd0,1)/vmlinuz-6.x", will be passed to user space.

[chenhuacai@loongson.cn: use strstarts()]
  Link: https://lkml.kernel.org/r/20250815090120.1569947-1-chenhuacai@loongson.cn
Link: https://lkml.kernel.org/r/20250721101343.3283480-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/init/main.c
+++ b/init/main.c
@@ -543,6 +543,12 @@ static int __init unknown_bootoption(cha
 				     const char *unused, void *arg)
 {
 	size_t len = strlen(param);
+	/*
+	 * Well-known bootloader identifiers:
+	 * 1. LILO/Grub pass "BOOT_IMAGE=...";
+	 * 2. kexec/kdump (kexec-tools) pass "kexec".
+	 */
+	const char *bootloader[] = { "BOOT_IMAGE=", "kexec", NULL };
 
 	/* Handle params aliased to sysctls */
 	if (sysctl_is_alias(param))
@@ -550,6 +556,12 @@ static int __init unknown_bootoption(cha
 
 	repair_env_string(param, val);
 
+	/* Handle bootloader identifier */
+	for (int i = 0; bootloader[i]; i++) {
+		if (strstarts(param, bootloader[i]))
+			return 0;
+	}
+
 	/* Handle obsolete-style parameters */
 	if (obsolete_checksetup(param))
 		return 0;


