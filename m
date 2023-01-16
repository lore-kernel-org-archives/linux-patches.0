Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00496FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29699C433F1;
	Mon, 16 Jan 2023 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888350;
	bh=9X0kihwH9v6KguSmRyZOP8GwxDqVtyzFzxdFFoL3/QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoO18dCuCMAhyj58e8VtuaNYaIPnhHAPSIb/z0kyJt4A2vSXhff2x28i1Z0rNcDEY
	 2sts6mxxNJWe5oB4zQrZMOjJYJcQenVIidtj0JWMw4w0irZaIOidjYdSkXAZ85seq7
	 1fkVL5R0etLJpkSjoEpTXlyp9mX6sg186Z0T27ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Libo Chen <libo.chen@oracle.com>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 488/521] ktest.pl: Fix incorrect reboot for grub2bls
Date: Mon, 16 Jan 2023 16:52:30 +0100
Message-Id: <20230116154909.003672466@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Libo Chen <libo.chen@oracle.com>

[ Upstream commit 271e0c9dce1b02a825b3cc1a7aa1fab7c381d44b ]

This issue was first noticed when I was testing different kernels on
Oracle Linux 8 which as Fedora 30+ adopts BLS as default. Even though a
kernel entry was added successfully and the index of that kernel entry was
retrieved correctly, ktest still wouldn't reboot the system into
user-specified kernel.

The bug was spotted in subroutine reboot_to where the if-statement never
checks for REBOOT_TYPE "grub2bls", therefore the desired entry will not be
set for the next boot.

Add a check for "grub2bls" so that $grub_reboot $grub_number can
be run before a reboot if REBOOT_TYPE is "grub2bls" then we can boot to
the correct kernel.

Link: https://lkml.kernel.org/r/20201121021243.1532477-1-libo.chen@oracle.com

Cc: stable@vger.kernel.org
Fixes: ac2466456eaa ("ktest: introduce grub2bls REBOOT_TYPE option")
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 26df05a8c142 ("kest.pl: Fix grub2 menu handling for rebooting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 76468e2d619f..689fa4fd3d76 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2023,7 +2023,7 @@ sub reboot_to {
 
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch)'";
-    } elsif ($reboot_type eq "grub2") {
+    } elsif (($reboot_type eq "grub2") or ($reboot_type eq "grub2bls")) {
 	run_ssh "$grub_reboot $grub_number";
     } elsif ($reboot_type eq "syslinux") {
 	run_ssh "$syslinux --once \\\"$syslinux_label\\\" $syslinux_path";
-- 
2.35.1



