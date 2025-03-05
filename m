Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE761D63C3;
	Wed,  5 Mar 2025 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197826; cv=none; b=fa/nTWWVIdR4Z2IT9855wC4DqESled04+KNhOufnTPrfyTf7K/W9iXL+I18MmH0uTKgOry4b2AGn0mGkiZnYO4xcpgCSYMrarQ6EmPD0v/X3/5kDfLjpimEsfc5Z6ZoYaEwUzl1b3XU+iJg/ewz8ZQptuhtoWCdCOTlLtpGFv2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197826; c=relaxed/simple;
	bh=mvnqP51UHIcWWw6oBmVihXzp0JQIyC+wwAkJ+SZXKoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMLVloBTg7RYzrkNLWtDltDYhHVwJ6UJNd1luWCrpkDF3jRb7orTl3UdEdkGFab+pONMNPs6mz7vkEB+CxJjIOaKeM7mY3hCy9UTxuR9YOvdFL4EVSqAAKkQSLJ4W1/JxLBKZUxUsOq3mIHLY7F30QMbtV3q/CaGhQ6Pr8qAAE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptHMZvZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptHMZvZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD88C4CEE2;
	Wed,  5 Mar 2025 18:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197826;
	bh=mvnqP51UHIcWWw6oBmVihXzp0JQIyC+wwAkJ+SZXKoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptHMZvZGjqHeMqFh+VhyXRVyEcZ/MW0cqN2Rg+83B9pZkS9GevZTvOCZikejTfarG
	 HsPgtXfVfTOXzdkZXWf8Q86F1etqa1ZlANcydpbjx8RuV+w1MbbYQwseA82FoQC7r8
	 SQJwz8+eyP+y3N86TH1TtoI36E1RQ4Ijj1vrxOQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 114/142] x86/microcode: Mop up early loading leftovers
Date: Wed,  5 Mar 2025 18:48:53 +0100
Message-ID: <20250305174504.909708124@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 8529e8ab6c6fab8ebf06ead98e77d7646b42fc48 upstream

Get rid of the initrd_gone hack which was required to keep
find_microcode_in_initrd() functional after init.

As find_microcode_in_initrd() is now only used during init, mark it
accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20231017211723.298854846@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/core.c     |   17 +----------------
 arch/x86/kernel/cpu/microcode/internal.h |    1 -
 2 files changed, 1 insertion(+), 17 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -44,8 +44,6 @@
 static struct microcode_ops	*microcode_ops;
 bool dis_ucode_ldr = true;
 
-bool initrd_gone;
-
 /*
  * Synchronization.
  *
@@ -180,15 +178,7 @@ void load_ucode_ap(void)
 	}
 }
 
-/* Temporary workaround until find_microcode_in_initrd() is __init */
-static int __init mark_initrd_gone(void)
-{
-	initrd_gone = true;
-	return 0;
-}
-fs_initcall(mark_initrd_gone);
-
-struct cpio_data find_microcode_in_initrd(const char *path)
+struct cpio_data __init find_microcode_in_initrd(const char *path)
 {
 #ifdef CONFIG_BLK_DEV_INITRD
 	unsigned long start = 0;
@@ -216,12 +206,7 @@ struct cpio_data find_microcode_in_initr
 	 * has the virtual address of the beginning of the initrd. It also
 	 * possibly relocates the ramdisk. In either case, initrd_start contains
 	 * the updated address so use that instead.
-	 *
-	 * initrd_gone is for the hotplug case where we've thrown out initrd
-	 * already.
 	 */
-	if (initrd_gone)
-		return (struct cpio_data){ NULL, 0, "" };
 	if (initrd_start)
 		start = initrd_start;
 
--- a/arch/x86/kernel/cpu/microcode/internal.h
+++ b/arch/x86/kernel/cpu/microcode/internal.h
@@ -86,7 +86,6 @@ static inline unsigned int x86_cpuid_fam
 }
 
 extern bool dis_ucode_ldr;
-extern bool initrd_gone;
 
 #ifdef CONFIG_CPU_SUP_AMD
 void load_ucode_amd_bsp(unsigned int family);


