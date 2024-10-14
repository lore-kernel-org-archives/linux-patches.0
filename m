Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E15E1C6F5F;
	Mon, 14 Oct 2024 15:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919282; cv=none; b=Kac6bVc/moBcyzirXq4Z/+CI0ZMRCIwChoR4G119FiQMKBPu+xx4rim08DhffDRIgAZwCb6CJgtFSbItVSWszoRgwdQk5/Eq2VK0fsBdJd9WtqsICWEqBrzcNigwPdcE0oymPekw0ujlK+Ox9Bqr2BcmS7ikML2bZz8VimsxqUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919282; c=relaxed/simple;
	bh=cFsm81LymCq8DS/8GzwJGuZEomRV1W2SrH6ZlCXgRhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXduud3I7IyXOmzVdIQz2Ud9Ha7mzGzxaT8KZOOP1Pi1Taj/gLTYQpEP9wOOKuITLIuE9UwdFQHydkHUhCY+VQdIdevaca4mujCtdaPRyu7doF1OHpziJP5Gt9J+4QieKnY745aB4mspTu4q9i/GAciD8uFm9hY/gfvqauEP6fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQ/7oEKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQ/7oEKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF40C4CEC3;
	Mon, 14 Oct 2024 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919282;
	bh=cFsm81LymCq8DS/8GzwJGuZEomRV1W2SrH6ZlCXgRhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ/7oEKAzX1EfPcbdFH2Kz0rYG3seTFmZ04avVoUqy8G6d0wokQr+flf+vwdIlXwu
	 NgLtCoGXCLZXy0sBJzq8MZ94B+NkOxIWZEoUfU7Q7oK19MQaUnrF46uU1E7EwFZKMK
	 cJFpl/RkefLo3oE6vuP1jU187kwuddFmksvwUXmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 533/798] parisc: Fix itlb miss handler for 64-bit programs
Date: Mon, 14 Oct 2024 16:18:07 +0200
Message-ID: <20241014141238.929637435@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1038,8 +1038,7 @@ ENTRY_CFI(intr_save)		/* for os_hpmc */
 	STREG           %r16, PT_ISR(%r29)
 	STREG           %r17, PT_IOR(%r29)
 
-#if 0 && defined(CONFIG_64BIT)
-	/* Revisit when we have 64-bit code above 4Gb */
+#if defined(CONFIG_64BIT)
 	b,n		intr_save2
 
 skip_save_ior:
@@ -1047,8 +1046,7 @@ skip_save_ior:
 	 * need to adjust iasq/iaoq here in the same way we adjusted isr/ior
 	 * above.
 	 */
-	extrd,u,*	%r8,PSW_W_BIT,1,%r1
-	cmpib,COND(=),n	1,%r1,intr_save2
+	bb,COND(>=),n	%r8,PSW_W_BIT,intr_save2
 	LDREG		PT_IASQ0(%r29), %r16
 	LDREG		PT_IAOQ0(%r29), %r17
 	/* adjust iasq/iaoq */


