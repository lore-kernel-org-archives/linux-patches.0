Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB82B3370FE;
	Fri, 17 Oct 2025 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713719; cv=none; b=qYgafQZ13L13KLHEd4yz/EackCT9CpcErJmNnMwc41QPIvdASQHMeyZVkVBmFrxHZztoTYyLxKGn8IOf3ZuCNIWR2g6gvYjivogFv9P5nQHngyaRj8vTR4FeS/kiXoST7SFeeVEN8ZX8rSuqwqjb4GDh8cMfenEUEvyagmspafw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713719; c=relaxed/simple;
	bh=NkF0+LP8ilYtCpIW0H25BUmHNlbhn6wAH+EgLfNw7dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6YwAftgNGQgJhNI5ffKfU+NfQoTqnfgb2mjf7CPTsZZfc3MnKJZyv9oZE5aKptMKjTvZGtVFO0Xotob0663Gg/Ls8zIIJ16du0MDnuS0vGitHVVjfYOCQHJrPZq5l1w7gHH5OJA/32wGNUIhy+Guj1TfUwjRsdAWwazTVtZywo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfQYzajf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfQYzajf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7214C19425;
	Fri, 17 Oct 2025 15:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713718;
	bh=NkF0+LP8ilYtCpIW0H25BUmHNlbhn6wAH+EgLfNw7dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfQYzajf2+WIrVc7knpLzp5bnwixA2BajC5JUojUNOokVjDnIaG0hUWLZGw3Ql7VM
	 GoN9KWFD+Gjjhr7bSGO4Bbd/QwVRm94q6Pp0T+Ego9M986bgTDuUAw2GDaXk9LcoWv
	 6qLpRy1Krwr8kFdJ+r3j1P8c3DkawCGd7ZeZeeXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 096/201] init: handle bootloader identifier in kernel parameters
Date: Fri, 17 Oct 2025 16:52:37 +0200
Message-ID: <20251017145138.277116928@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -530,6 +530,12 @@ static int __init unknown_bootoption(cha
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
@@ -537,6 +543,12 @@ static int __init unknown_bootoption(cha
 
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


