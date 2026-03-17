Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630DA179A3;
	Tue, 17 Mar 2026 16:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766607; cv=none; b=hSimilA+DUZMk+EvZd9yPD02p2JMY4LBvlwb8MUz2c42Bl4C6GrRXzUQP9x+WWuHf/nfp3T/6zKxKJh/NRedR//ThotIzY3Xl/sQqFjR8HQ/+LP9hrmPw9MqHCalDVT9wAJKjaLEc3xdpclrtTgu7NvmpW/TqV684v4kk7ra2sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766607; c=relaxed/simple;
	bh=qlOvRG0/9vAVARPEXmUSlqPumdszi8vTsoSU7mdoi7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ev3AEntftCA2+AV2Su7s8xeOChJCxZ+Lp4buo8kQ1P7LguFwphjPVENyaXFQAc+CuIV7s1UvOEkylJ0SqbwcpxgSed9hdl2EZsw++Q/MFMT4B8ETlftSf+sg9+689AIMbbWQHk3fXIcz4QQxfjbgbgFD9ai4Tn7F3xXGkyv5VvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2vyZhVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2vyZhVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0B6C4CEF7;
	Tue, 17 Mar 2026 16:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766607;
	bh=qlOvRG0/9vAVARPEXmUSlqPumdszi8vTsoSU7mdoi7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2vyZhVehsjKY9y6Sax+phqGBWDayy1fnP9cFKR/RxtFtvvdtf9U8sXv7yFUJs6YH
	 K8VTE/lykOJpfD5lWQpecLa2y1n2lDHqenNuO9mWajQlX4nCc45YMXpf3K7vKA+jvY
	 k4RqibWG0pg0LO+vRf6qBxQWdR+KkPpoJrikHopQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.19 283/378] s390/stackleak: Fix __stackleak_poison() inline assembly constraint
Date: Tue, 17 Mar 2026 17:34:00 +0100
Message-ID: <20260317163017.415351048@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit 674c5ff0f440a051ebf299d29a4c013133d81a65 upstream.

The __stackleak_poison() inline assembly comes with a "count" operand where
the "d" constraint is used. "count" is used with the exrl instruction and
"d" means that the compiler may allocate any register from 0 to 15.

If the compiler would allocate register 0 then the exrl instruction would
not or the value of "count" into the executed instruction - resulting in a
stackframe which is only partially poisoned.

Use the correct "a" constraint, which excludes register 0 from register
allocation.

Fixes: 2a405f6bb3a5 ("s390/stackleak: provide fast __stackleak_poison() implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20260302133500.1560531-4-hca@linux.ibm.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -158,7 +158,7 @@ static __always_inline void __stackleak_
 		"	j	4f\n"
 		"3:	mvc	8(1,%[addr]),0(%[addr])\n"
 		"4:"
-		: [addr] "+&a" (erase_low), [count] "+&d" (count), [tmp] "=&a" (tmp)
+		: [addr] "+&a" (erase_low), [count] "+&a" (count), [tmp] "=&a" (tmp)
 		: [poison] "d" (poison)
 		: "memory", "cc"
 		);


