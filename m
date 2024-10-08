Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA631DF272;
	Tue,  8 Oct 2024 13:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393676; cv=none; b=Q1Hwn3JBQpqSGs+6VZBs6dXoH2IeY4EITeSembehqOcwBDf5NcuVjM8UE7K/vvFnPkScHXSouS5ekgRQ2IvYbXhXloD+31B4cKwM6MaPHSA7PGaaI1rgqnjOWmg9roUU0S9MgzH8vHpvIgY0Mzbj8JKW4QFqFwFVeDlBY6u1jRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393676; c=relaxed/simple;
	bh=zyvds578ZykJNaFcvdZppRweUxQe9Pcji+qYDBWKXtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGada/T0fLcvJUiMh5dBMdsWtuxKfKkkzct3PZVRNHfNlSTGL8S3Zl5hg/YtZWfNhwGqcFWGfDz0jZsCplXB3kIaka94ki+NDNzZdXIjLdYSa0NVo9Di8SXTWxmS4J+4IoR/NfhRJPJnKb1QhQ9MjtGynd5d7jO+6TDEemBRMb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNai+soI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNai+soI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B24DC4CEC7;
	Tue,  8 Oct 2024 13:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393676;
	bh=zyvds578ZykJNaFcvdZppRweUxQe9Pcji+qYDBWKXtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNai+soIOrnL179Gu3vfGsf9v8/3gP+CApra1DRFGqFRtXM6fsosyZs06eCnkrKER
	 hSXUwvXWOsC40fHonrKz8Ai/PcqravOWcVh0aQZU22JF6FkoVMLXkSbjPTHV5i99Wp
	 mcrd+8NS09pcz4m9pFUEa4ZlGPyZcRNTjw1qN/H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 221/386] parisc: Fix itlb miss handler for 64-bit programs
Date: Tue,  8 Oct 2024 14:07:46 +0200
Message-ID: <20241008115638.102988235@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1051,8 +1051,7 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r16, PT_ISR(%r29)
 	STREG           %r17, PT_IOR(%r29)
 
-#if 0 && defined(CONFIG_64BIT)
-	/* Revisit when we have 64-bit code above 4Gb */
+#if defined(CONFIG_64BIT)
 	b,n		intr_save2
 
 skip_save_ior:
@@ -1060,8 +1059,7 @@ skip_save_ior:
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
 	 * above.
 	 */
-	extrd,u,*	%r8,PSW_W_BIT,1,%r1
-	cmpib,COND(=),n	1,%r1,intr_save2
+	bb,COND(>=),n	%r8,PSW_W_BIT,intr_save2
 	LDREG		PT_IASQ0(%r29), %r16
 	LDREG		PT_IAOQ0(%r29), %r17
 	/* adjust iasq/iaoq */


