Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6661E7640;
	Tue, 15 Oct 2024 12:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993721; cv=none; b=LMwMH+8qmGpGWCfvuY5OIf/5sPPx/58wmgraLeEkbB3xJ4G/LWu/U5cCOLFOH7g7ZuWTt0HxaahdUeuBqf+gR8yNGL3oVGNsZdXBmVo7WkMA0BNbboC25u0N69oDp+rhpBXsRZY1R7j/5yuyD4giiOlMw373NcaU8QIjSayW10Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993721; c=relaxed/simple;
	bh=FQb8Hejen4CMrVQEc5OPURH9/nnyusVo37EWIxEKN3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9yJmw7sd3elG590gPwLbzQMruv935tm7EzHvSihQ9pqeMpncMchOdibsPUhokw6CMYfXDON9KiuhallpFfXC6PP4qlemzzvxzocznTbNby3gHN7VObN441k3+yzqjFTg7WWUnkKfrn3oYG5KPF8UJ8oRqNfpAGVDc5rZpXIlh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0S1dOjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0S1dOjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020A9C4CEC6;
	Tue, 15 Oct 2024 12:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993721;
	bh=FQb8Hejen4CMrVQEc5OPURH9/nnyusVo37EWIxEKN3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0S1dOjvx6gfTzaquMSpJhEuT8jxTrbvReXYcRSFbHrjB1b8sLJ5ztZg6PsyDm2wv
	 3Mt4KvzDYSMOWhrnDcXCv20yxtTvz72hSKhuEakYkeo902A29qLDPANAg2ejEmM5EI
	 czRW+CIYFpMjayci2lF2yTZHU/AEqm3y2KieWCus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 496/691] parisc: Fix itlb miss handler for 64-bit programs
Date: Tue, 15 Oct 2024 13:27:24 +0200
Message-ID: <20241015112500.029254056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Helge Deller <deller@gmx.de>

commit 9542130937e9dc707dd7c6b7af73326437da2d50 upstream.

For an itlb miss when executing code above 4 Gb on ILP64 adjust the
iasq/iaoq in the same way isr/ior was adjusted.  This fixes signal
delivery for the 64-bit static test program from
http://ftp.parisc-linux.org/src/64bit.tar.gz.  Note that signals are
handled by the signal trampoline code in the 64-bit VDSO which is mapped
into high userspace memory region above 4GB for 64-bit processes.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org	# v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/entry.S |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1071,8 +1071,7 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r16, PT_ISR(%r29)
 	STREG           %r17, PT_IOR(%r29)
 
-#if 0 && defined(CONFIG_64BIT)
-	/* Revisit when we have 64-bit code above 4Gb */
+#if defined(CONFIG_64BIT)
 	b,n		intr_save2
 
 skip_save_ior:
@@ -1080,8 +1079,7 @@ skip_save_ior:
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
 	 * above.
 	 */
-	extrd,u,*	%r8,PSW_W_BIT,1,%r1
-	cmpib,COND(=),n	1,%r1,intr_save2
+	bb,COND(>=),n	%r8,PSW_W_BIT,intr_save2
 	LDREG		PT_IASQ0(%r29), %r16
 	LDREG		PT_IAOQ0(%r29), %r17
 	/* adjust iasq/iaoq */


