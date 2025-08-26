Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A63A343D7B;
	Tue, 26 Aug 2025 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215022; cv=none; b=HBmr7aImCbM9EdYqJUiRR2ivvyUxEo2G3bTYhXndIbm+XwK46qPyOGxtrom/ql0gh3pK/xo4gIFLjZXZEaBrD7tfF/dZrqo/kOCDGXHc8HZreFD4OVIkqQby7PJcrABt4iNfUgj4EmKkt0IeEw2GqxYcY1jPB3tLqFzTA8Ksdbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215022; c=relaxed/simple;
	bh=JdCM9S27U+4VEgj0xcN6V1j21RmsNpfJcMrun57/LZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrg3NJV6zxfoSN6rx8t7GY3lMiIO3w8NkLBeq5Q44Rt4fzqRxvVlLvsYyD0yugd3u+N/vcCqmcf19kt5lx8KgZYNxjsxELREaGWBg1bLHTO6mgCa6zrJVr1l+CU4Rdy77qIn4wJq02C+naTfa8As4S/YxbpBCO0T3yHQDUYgXiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fmryk2ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fmryk2ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5860C113CF;
	Tue, 26 Aug 2025 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215022;
	bh=JdCM9S27U+4VEgj0xcN6V1j21RmsNpfJcMrun57/LZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fmryk2ua5odwfK1E3X6tBCmkpl/gid3ov2F6mU0wQPQ5nH82eSKvhR83V8e41pGke
	 Co9ZuAx7xOf58fF0i5/AA7Vw81StAtKK2+G5cV3brOB9GP4HzgkhEqr1ZoX8DFFzrw
	 DPhYLiHOw5GRR6gprzc2iZ8OIW9knXBvY9umVsx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 316/482] parisc: Revise gateway LWS calls to probe user read access
Date: Tue, 26 Aug 2025 13:09:29 +0200
Message-ID: <20250826110938.611579352@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -600,6 +600,9 @@ lws_compare_and_swap32:
 lws_compare_and_swap:
 	/* Trigger memory reference interruptions without writing to memory */
 1:	ldw	0(%r26), %r28
+	proberi	(%r26), PRIV_USER, %r28
+	comb,=,n	%r28, %r0, lws_fault /* backwards, likely not taken */
+	nop
 2:	stbys,e	%r0, 0(%r26)
 
 	/* Calculate 8-bit hash index from virtual address */
@@ -753,6 +756,9 @@ cas2_lock_start:
 	copy	%r26, %r28
 	depi_safe	0, 31, 2, %r28
 10:	ldw	0(%r28), %r1
+	proberi	(%r28), PRIV_USER, %r1
+	comb,=,n	%r1, %r0, lws_fault /* backwards, likely not taken */
+	nop
 11:	stbys,e	%r0, 0(%r28)
 
 	/* Calculate 8-bit hash index from virtual address */
@@ -936,41 +942,47 @@ atomic_xchg_begin:
 
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


