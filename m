Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827071;
	b=P23X9c2tl7T60fUPx2hXFmKank2WEt5BG7ZJI/Ztrw9zHbwFdtg2RmYA4oLxjr+3BXlY
	 19P+YCRS+dP6ssPFy+vXd94mV8fE4Do2o2dcl4n9wKCoLL/faY+VQ2AmviMtaSHQlfb2y
	 j8lnF1B+BgUU43r7yBZFbxr+bNwQTIsOh+T2BWQBEzlpmH9vqzwlOeMKT1nSqgXTQ0+nK
	 RvtaFbMdMANx5rI+uanAbUkeAaMXIQeuIpcNkcBdq59uujZmuFYpx04N5l3cbuI1al7YD
	 EKLY0ISkrDVvdTrk5GLqqEWdTtJdpyHSkHVBWaO08aj9weFuC0HGtmK6dSS8g+zncPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LoCW4l6ARz+pTpF2HUvIpxC7NVEEJ1z7yiHXf4Kxex4=;
	b=wYxRAY/XVLVjdorJyQhHtiAC0rdgxIKSRIopD2aUAVRMh2eTxFR4HhH57Q2q1WNeDA36
	 TdYk+7utsINfh+WZTJXSU8S0O12m85kdTbTEBzebc/HT/nn0RyfcWFtrjUq+gOYazFAFM
	 oV/b8coNoxH7ImAn1zwWgQkgOBFGsDkQdogmL1CpjFpX1yrSwITMy+eVhQoXX0oVqy0/9
	 62osIhqZ1CgRHUdEHs5UHEDFUpcQgf3JOHVtjJSVaRWvrqA3KunqZmjhV8imEwmVgvdkx
	 fCjOBRxlzSxkjdvLWozOGkBqFuhvO90/DyRydhD/4gJPZ46EmTrt5mQMpEG029TUDlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bYKm/lr7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252B2606AE05;
	Wed,  4 Nov 2026 21:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYKm/lr7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4D71F00A18;
	Wed,  4 Nov 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827071;
	bh=LoCW4l6ARz+pTpF2HUvIpxC7NVEEJ1z7yiHXf4Kxex4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYKm/lr7UYCDyczfJA8p0lu1uK3TvlHQ40O41luY7iirZscv31WjoofhAC5Sq2iG5
	 FVglilsyCc9UrrxKGM5D3a752VDUs+ImFkrWbkni6LgxQ7+KUjl51C1MlyZ4qtPeXJ
	 uoPQIXVrXiHgvO8QuQeaJ3B+Hq9HJv462wm+l87I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 175/547] s390/extable: Fix mvcos instruction decoding
Date: Wed,  4 Nov 2026 16:05:59 -0500
Message-ID: <20261104211043.118838256@linuxfoundation.org>
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

commit 4044466ff004c7ad5fd47be717cd933077e6e874 upstream.

If either the b1 or b2 field of the mvcos instruction is zero, register
zero is not used for address computation; zero is used instead, according
to the architecture. ex_handler_ua_mvcos() incorrectly uses the real
contents of register zero. Fix this.

This shouldn't be a problem for any generated code, since the compiler
would only generate such code if it is possible to prove at compile time
that either the source or destination address is within the first 4kb of
the designated address space. Such code should not exist (also confirmed
by an allyesconfig build and decoding all ~7000 mvcos instructions).

Fixes: c488f5187a24 ("s390/uaccess: Shorten raw_copy_from_user() / raw_copy_to_user() inline assemblies")
Cc: stable@vger.kernel.org
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/extable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/extable.c
+++ b/arch/s390/mm/extable.c
@@ -106,9 +106,9 @@ static bool ex_handler_ua_mvcos(const st
 	regs->psw.addr = extable_fixup(ex);
 	insn = (struct insn_ssf *)regs->psw.addr;
 	if (from)
-		uaddr = regs->gprs[insn->b2] + insn->d2;
+		uaddr = (insn->b2 ? regs->gprs[insn->b2] : 0) + insn->d2;
 	else
-		uaddr = regs->gprs[insn->b1] + insn->d1;
+		uaddr = (insn->b1 ? regs->gprs[insn->b1] : 0) + insn->d1;
 	remainder = PAGE_SIZE - (uaddr & (PAGE_SIZE - 1));
 	if (regs->gprs[insn->r3] <= remainder)
 		remainder = 0;


