Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514483A961B;
	Mon, 23 Mar 2026 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277087; cv=none; b=FABxArm4RE0cMXLv3DUKadB1nMs+fN+Pjs+8luw/B1H4TFJUwP90OTTRnjqs92FVAzDooLETZsfMNJIW6b6jLPeJziMVyqqyckCSfSaFd3+dlBTKSAJmd6hFuQKdZ6rAhtuKGL15PzO3p/QcukoaPsbphIu/osEUNGHEXCFEveA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277087; c=relaxed/simple;
	bh=sNdAsPI5fgzRAhFVVkaa6COHWvWfJrN981OzNukrIIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cozkAA1flinJAIp4E/WNOkBbbKoLasd8R5IKkmm83xe5S7KAX9ZhX9LGTgX/8U+n+gwy8StUA9/qOn9uqnkkWGWLCYvcjNyrVsOh4TMrJXunQT+LmvOj5PTArp3DAq+EpzVj7NIrEp+Am6X/+Iuc0owTNg954n4jgBvM2CZ1i6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=re+JQBwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="re+JQBwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA217C4CEF7;
	Mon, 23 Mar 2026 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277087;
	bh=sNdAsPI5fgzRAhFVVkaa6COHWvWfJrN981OzNukrIIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=re+JQBwf0eskYmB721MmWxQsOOnb09l/DzhQNGYYJnEZQqBdrHMDhw7Jqrze1D/Gu
	 j3vXua1erNAA8dHKDGYNUCIQY4RxJ+FfLI6nAVGsgh6lD36a36qyfcIYkMzZ4C0Qsi
	 y4qxWkL0lLbURccfqc2X7fIMz/oo929xDIbMGCU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Lechner <felix.lechner@lease-up.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 315/460] parisc: Flush correct cache in cacheflush() syscall
Date: Mon, 23 Mar 2026 14:45:11 +0100
Message-ID: <20260323134534.241303317@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 2c98a8fbd6aa647414c6248dacf254ebe91c79ad upstream.

The assembly flush instructions were swapped for I- and D-cache flags:

SYSCALL_DEFINE3(cacheflush, ...)
{
	if (cache & DCACHE) {
			"fic ...\n"
	}
	if (cache & ICACHE && error == 0) {
			"fdc ...\n"
	}

Fix it by using fdc for DCACHE, and fic for ICACHE flushing.

Reported-by: Felix Lechner <felix.lechner@lease-up.com>
Fixes: c6d96328fecd ("parisc: Add cacheflush() syscall")
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -953,7 +953,7 @@ SYSCALL_DEFINE3(cacheflush, unsigned lon
 #else
 			"1: cmpb,<<,n	%0,%2,1b\n"
 #endif
-			"   fic,m	%3(%4,%0)\n"
+			"   fdc,m	%3(%4,%0)\n"
 			"2: sync\n"
 			ASM_EXCEPTIONTABLE_ENTRY_EFAULT(1b, 2b, "%1")
 			: "+r" (start), "+r" (error)
@@ -968,7 +968,7 @@ SYSCALL_DEFINE3(cacheflush, unsigned lon
 #else
 			"1: cmpb,<<,n	%0,%2,1b\n"
 #endif
-			"   fdc,m	%3(%4,%0)\n"
+			"   fic,m	%3(%4,%0)\n"
 			"2: sync\n"
 			ASM_EXCEPTIONTABLE_ENTRY_EFAULT(1b, 2b, "%1")
 			: "+r" (start), "+r" (error)


