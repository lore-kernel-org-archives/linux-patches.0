Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B9C1D416E;
	Wed,  6 Nov 2024 12:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895341; cv=none; b=WhqpGU2/+UfDhRmbwkE7C3mghtn7fMWr6/7+S45LBgUys5yqbrqK6dY+jsaz/Aoj69dKWm++dcNFRu7hFqP82KiCxAVoPXKVWLqR/cHDs1nWREAXa14hGhCp1ka2J1uuL77KF/YhVJFsj2Yj6ufZfPdIU0xINUrT5UT0h2FDDmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895341; c=relaxed/simple;
	bh=86iMv183xq/DwXp50goXH1E4e2tFmGq1e6NkFihgN5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6RScDGgIOHjUrJRbB66pzClggTZWinOmpx3pRBVLQW0kzaixGrtI6LhJu26wTjgpj3w7ExF0+nBBq4l5Cg1QQ0IbPS1q53qW5Gu+mhbNvKn+C5Tsd3z16DBbToJO4wrN+h6tMAZweoknQAw/ClNi06bEJDWpyIaDi8OgEyhq7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAxN6Uze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAxN6Uze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D5EC4CECD;
	Wed,  6 Nov 2024 12:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895341;
	bh=86iMv183xq/DwXp50goXH1E4e2tFmGq1e6NkFihgN5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SAxN6UzeRDX1TYPBm1eAf4s+7dkVwNA3zT2cej3cLtMVvTEFScjplSjZxBNA76L0O
	 T3Wujh+/5icdo/Kj/gmlSTIiBmycDAVBVoX/xBj8P8Q/iVrD+H92Wyt4qaDikTwHAJ
	 UhkhkR6+nOJgoTZ6tEMecGSrNUami266l9gWUdSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 186/350] parisc: Fix itlb miss handler for 64-bit programs
Date: Wed,  6 Nov 2024 13:01:54 +0100
Message-ID: <20241106120325.542991848@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1089,8 +1089,7 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r16, PT_ISR(%r29)
 	STREG           %r17, PT_IOR(%r29)
 
-#if 0 && defined(CONFIG_64BIT)
-	/* Revisit when we have 64-bit code above 4Gb */
+#if defined(CONFIG_64BIT)
 	b,n		intr_save2
 
 skip_save_ior:
@@ -1098,8 +1097,7 @@ skip_save_ior:
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
 	 * above.
 	 */
-	extrd,u,*	%r8,PSW_W_BIT,1,%r1
-	cmpib,COND(=),n	1,%r1,intr_save2
+	bb,COND(>=),n	%r8,PSW_W_BIT,intr_save2
 	LDREG		PT_IASQ0(%r29), %r16
 	LDREG		PT_IAOQ0(%r29), %r17
 	/* adjust iasq/iaoq */


