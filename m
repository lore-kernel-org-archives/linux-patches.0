Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827073;
	b=NQ0TXMbossrO2yHGnkS2S/uEUy4kMVM05+u0p+ORM5k2JvFUXMDtBgGZqWyv8GFJiERW
	 Y2KZMJXdrbvtkaNKu6B2T1XDedGL5TOxToOAPsgMFsQNtbMACaJX6HWLgxEwI16QrLkut
	 G+Xon6KCrkbiXO1IEMahbyJKMzGdAdU4qYRjjinKf5Wrs+nna4JwHMxDXnZDDy3q2OgFS
	 xboXu9eB+udXFy4ADMb9eaUjQvbLyW4BO4Lu2i247SjRtZzTqAGt5ej7P7r81mIhiwiJf
	 9IuYw5rVBXgXphpv6pzZcnKtqWId/OTh5VPDUKDYbRP3G3CTC3qQi4McfLjSon5lU6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LF+P32v9rzt2UERuI+ObLeQNYEEyUHQi2uaZGWvHksw=;
	b=EhtxF/4dlAXc9jGXl9nEfAa7ifdhGZG0SUJOrBf7/6I7N69ES32Kb6b7bhug7/r6QMqO
	 hv+YR5mRs8NAsTaPx4rhuYdwFr6pNcaD/dmWqveSs6tx/2dWIHmLfOHFPvSHTAs1evoDP
	 jXwxnZjxDEI3dRUWUXr0jU5sdy+BWqQ7wS+ROvkFG6hbGj7f5Zl8COfG9Y3JkhjP+fCRd
	 Rgj099rMR+cYdswSLiKAlbjFLJxwOcKswptMiMzOk52TiuJJrnrMxi2rL/NEzlANzuSuT
	 N31pO67WL6A8+uyxoyfCAIP7OkXowvuSyxTPTa0W7KrJD22z69YI2Ha/P40Rs2RMXXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L8Iy763/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6A4606AE05;
	Wed,  4 Nov 2026 21:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L8Iy763/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694771F000C1;
	Wed,  4 Nov 2026 21:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827072;
	bh=LF+P32v9rzt2UERuI+ObLeQNYEEyUHQi2uaZGWvHksw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8Iy763/uYd91Sn+6RHGS5+Rd/N+Ix687aobRO0FOVkzVS+Rpl3JK8TaPnNc+TLtc
	 jFbA3p4zXNWIVKvK2wOKP702dSLrbM7JLjsq1Ux7/O19R53nlLybGNR22A0k3XBsyY
	 kOTodyiMXvt1hTfKHv1em2X/jIpoZuHYNY0Rnjv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 176/547] s390/kprobes: Prevent kprobes on instructions with exception table entry
Date: Wed,  4 Nov 2026 16:06:00 -0500
Message-ID: <20261104211043.147068374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit fc9bb0ecd310b53af5116415952a1fb89d4660b9 upstream.

The mvcos exception handler ex_handler_ua_mvcos() decodes the faulting
instruction, assuming it is an mvcos instruction. In case the instruction
is kprobed the decoded instruction is a breakpoint instruction instead,
which leads to incorrect instruction decoding and potential register
corruption.

Fix this by simply preventing to set a kprobe on such instructions,
similar like arm64 is doing it.

Fixes: c488f5187a24 ("s390/uaccess: Shorten raw_copy_from_user() / raw_copy_to_user() inline assemblies")
Cc: stable@vger.kernel.org
Reviewed-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -85,6 +85,9 @@ static bool can_probe(unsigned long padd
 	if (!kallsyms_lookup_size_offset(paddr, NULL, &offset))
 		return false;
 
+	if (s390_search_extables(paddr))
+		return false;
+
 	/* Decode instructions */
 	addr = paddr - offset;
 	while (addr < paddr) {


