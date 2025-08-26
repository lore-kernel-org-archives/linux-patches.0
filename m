Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E00239573;
	Tue, 26 Aug 2025 11:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208397; cv=none; b=eKyMBcQSIhSZD5l+es7gIU2CjUESnfKT+eReI8X0FwN5frET+HHsUE7k3t6CX9+Ewx+EnYvU/Mc1k9A3Mv5YUQ8LyZxBpk8KCoRIwWqAtuNhBkKh96aQ4TUhIH/kDURLvoEl9+UGExcnTABCCkC2beMasXMnJkaXdZ5VXFk1t3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208397; c=relaxed/simple;
	bh=FZAxQKf/A/UBSFxZCgmp7vgsm3Mg8w8G51nDX0QZZg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0KcHtJsVPqRI+SPEssWmoG2BK29Ex3b1ko/1x9HiDSFYkRWx3d/t2qaq6IxxEvkCcrhIqSpcm4Ebw/s3uQ9sX+gcwnJrymBgIRL9Qzr+ShJZg3U8v4uQRhnnJwz1W3u/Prp/4wKpXwT6/t3M2zGizssUqGRAaR9peITVAZcJM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcB8iGjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcB8iGjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A66C4CEF1;
	Tue, 26 Aug 2025 11:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208397;
	bh=FZAxQKf/A/UBSFxZCgmp7vgsm3Mg8w8G51nDX0QZZg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcB8iGjs8qrEg0atfQZeV+0hOEWgDZkMPSxM8J5+Gk7B9sZ0xXBU8XU6iXYpHvV7F
	 28PbVOzsa4wfjAfCunfGmfNSeb9UHdQwBw1RDtx6YK401VKnLImw+PBUP1YVVhVMIV
	 mFMV3q8fnrgFdZ3+Ilhb/R+oEQELP3iQ3gO03pBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 095/322] parisc: Revise gateway LWS calls to probe user read access
Date: Tue, 26 Aug 2025 13:08:30 +0200
Message-ID: <20250826110918.025248932@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit f6334f4ae9a4e962ba74b026e1d965dfdf8cbef8 upstream.

We use load and stbys,e instructions to trigger memory reference
interruptions without writing to memory. Because of the way read
access support is implemented, read access interruptions are only
triggered at privilege levels 2 and 3. The kernel and gateway
page execute at privilege level 0, so this code never triggers
a read access interruption. Thus, it is currently possible for
user code to execute a LWS compare and swap operation at an
address that is read protected at privilege level 3 (PRIV_USER).

Fix this by probing read access rights at privilege level 3 and
branching to lws_fault if access isn't allowed.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/syscall.S |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -613,6 +613,9 @@ lws_compare_and_swap32:
 lws_compare_and_swap:
 	/* Trigger memory reference interruptions without writing to memory */
 1:	ldw	0(%r26), %r28
+	proberi	(%r26), PRIV_USER, %r28
+	comb,=,n	%r28, %r0, lws_fault /* backwards, likely not taken */
+	nop
 2:	stbys,e	%r0, 0(%r26)
 
 	/* Calculate 8-bit hash index from virtual address */
@@ -767,6 +770,9 @@ cas2_lock_start:
 	copy	%r26, %r28
 	depi_safe	0, 31, 2, %r28
 10:	ldw	0(%r28), %r1
+	proberi	(%r28), PRIV_USER, %r1
+	comb,=,n	%r1, %r0, lws_fault /* backwards, likely not taken */
+	nop
 11:	stbys,e	%r0, 0(%r28)
 
 	/* Calculate 8-bit hash index from virtual address */
@@ -951,41 +957,47 @@ atomic_xchg_begin:
 
 	/* 8-bit exchange */
 1:	ldb	0(%r24), %r20
+	proberi	(%r24), PRIV_USER, %r20
+	comb,=,n	%r20, %r0, lws_fault /* backwards, likely not taken */
+	nop
 	copy	%r23, %r20
 	depi_safe	0, 31, 2, %r20
 	b	atomic_xchg_start
 2:	stbys,e	%r0, 0(%r20)
-	nop
-	nop
-	nop
 
 	/* 16-bit exchange */
 3:	ldh	0(%r24), %r20
+	proberi	(%r24), PRIV_USER, %r20
+	comb,=,n	%r20, %r0, lws_fault /* backwards, likely not taken */
+	nop
 	copy	%r23, %r20
 	depi_safe	0, 31, 2, %r20
 	b	atomic_xchg_start
 4:	stbys,e	%r0, 0(%r20)
-	nop
-	nop
-	nop
 
 	/* 32-bit exchange */
 5:	ldw	0(%r24), %r20
+	proberi	(%r24), PRIV_USER, %r20
+	comb,=,n	%r20, %r0, lws_fault /* backwards, likely not taken */
+	nop
 	b	atomic_xchg_start
 6:	stbys,e	%r0, 0(%r23)
 	nop
 	nop
-	nop
-	nop
-	nop
 
 	/* 64-bit exchange */
 #ifdef CONFIG_64BIT
 7:	ldd	0(%r24), %r20
+	proberi	(%r24), PRIV_USER, %r20
+	comb,=,n	%r20, %r0, lws_fault /* backwards, likely not taken */
+	nop
 8:	stdby,e	%r0, 0(%r23)
 #else
 7:	ldw	0(%r24), %r20
 8:	ldw	4(%r24), %r20
+	proberi	(%r24), PRIV_USER, %r20
+	comb,=,n	%r20, %r0, lws_fault /* backwards, likely not taken */
+	nop
 	copy	%r23, %r20
 	depi_safe	0, 31, 2, %r20
 9:	stbys,e	%r0, 0(%r20)


