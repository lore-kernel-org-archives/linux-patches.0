Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E4F1E0B61;
	Wed,  6 Nov 2024 13:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898450; cv=none; b=FjLOOnfcl0ia2/p/rgqjGIOaQzxzDiovrvducHslS/fcaVQwwNvSp3ZLD2gD4xqn11EI1e2xIGkegsG7WcVh+KgpUUnz0Ocf3Zc/+bGAr26o/dCY888GBCBdimoE1La6phiVU3tlH+aNhwmKwLfLFjhhPCpHrqk7ld6X7e7nFp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898450; c=relaxed/simple;
	bh=jH1O7qidWfvw2Df/QLLqNUWsnKYw/YeJU+tbxUVf2fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoH2pR7H91nGljEWtbLF8yQn9bMSGX5J7/GTPJMVPOGTqUhQ+YIKe7ulPWJM+toj+hAEPraQyIAlbGHfVCvSoFQ2iZSpG82o65ocRsoJAKh0Os/jBrRUngHsu5cfV8SC+DnfhklMjEsnM0JLiQO5ILAaz69Mzu3hqJYtBonZV8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVKBXRdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVKBXRdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE44C4CECD;
	Wed,  6 Nov 2024 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898450;
	bh=jH1O7qidWfvw2Df/QLLqNUWsnKYw/YeJU+tbxUVf2fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVKBXRdVYWzpE5QECxTSrkDVgKWREnhOCoH93GSQotc2Bopc5VuMYkHdHnBnUxEup
	 hIt0+5sxOgnTEX2rqiW1skCuGTbywJ1NJC/cvQ/NkNDz/aocJ17t+x/K7UPXJN2Chl
	 jBxNOgvYdJ1UgsvNxh+c9wNJIT8Xa4VpHMdSmNcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 243/462] parisc: Fix itlb miss handler for 64-bit programs
Date: Wed,  6 Nov 2024 13:02:16 +0100
Message-ID: <20241106120337.525947442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1078,8 +1078,7 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r16, PT_ISR(%r29)
 	STREG           %r17, PT_IOR(%r29)
 
-#if 0 && defined(CONFIG_64BIT)
-	/* Revisit when we have 64-bit code above 4Gb */
+#if defined(CONFIG_64BIT)
 	b,n		intr_save2
 
 skip_save_ior:
@@ -1087,8 +1086,7 @@ skip_save_ior:
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
 	 * above.
 	 */
-	extrd,u,*	%r8,PSW_W_BIT,1,%r1
-	cmpib,COND(=),n	1,%r1,intr_save2
+	bb,COND(>=),n	%r8,PSW_W_BIT,intr_save2
 	LDREG		PT_IASQ0(%r29), %r16
 	LDREG		PT_IAOQ0(%r29), %r17
 	/* adjust iasq/iaoq */


