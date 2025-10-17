Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F17A33509C;
	Fri, 17 Oct 2025 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715464; cv=none; b=GtRdVjVpY+uRRPhNhowWS/ua7TpoP2ShVUHZ0LYBKnKfO/HDr05vi3QSspLB19+QyDqUPsfAhRzwn6WDlEUF42WX+l5Ujb0BVlGnY+N7h8NxUl9V4Tj5WQ5pJHCdxxXlpje6W49n7fR61IW3pWPMWFruZ1SU1LrhzW3p18yeNKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715464; c=relaxed/simple;
	bh=ZeOO+ihgIsWAmTFeia4T/KFxeM/23VIwhvCcvRdYzek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ7QLdS7Y+vXJvoZAeozKwwDmteMnDT4q4mErmWYLtH0c/ZkkS5V7wwKlzn60hiVfQrGff0fdNRaHYJtAz0Ez9CVN8H8upyA5gX56e4koInGc1/kRjRP2stslyfabqyYHGO/25CuJOqNjY5hm5jM/jh3bR00w+6QNx/j7ZKb50I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrcJnktp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrcJnktp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAD1C113D0;
	Fri, 17 Oct 2025 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715464;
	bh=ZeOO+ihgIsWAmTFeia4T/KFxeM/23VIwhvCcvRdYzek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrcJnktp6DO2yZ8HCt7G+6/hXd1r316MhlQO1Q9R3WlcKI9Jnb5n5NWpkIGFM9i0d
	 +nYgqVq3bgN0yvVQg/yWx5z07EOWkNYT5RvQ4H2qhvZ6AJIVHJDJmDCqF0lLM89o26
	 tn9GY5bQ4W9je0pO45lUsTy1w612TOWlNOO1HNtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 225/371] init: handle bootloader identifier in kernel parameters
Date: Fri, 17 Oct 2025 16:53:20 +0200
Message-ID: <20251017145210.226728114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -544,6 +544,12 @@ static int __init unknown_bootoption(cha
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
@@ -551,6 +557,12 @@ static int __init unknown_bootoption(cha
 
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


