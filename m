Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB7C255F2C;
	Tue, 17 Mar 2026 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768144; cv=none; b=VpYQFxEvBkft7QhBPf8xYlbnfBn1l2WFjY/SIjuelWgLI+cv3oLbTMgfEt5sZxiFOpA3OH7aCrYFJX0YAnPqDBk6LxxcE4cOBqkJSyTz2ppi36XaW8Dlw2v29chn+ouCKcs69vj2LROnUSVMCgyfoTPbGsr+Z7jiBmsNGUloW0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768144; c=relaxed/simple;
	bh=e5q9W155di7LjAWA5bgkmYy4FZcen3QjpxajVAyKEkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpmDj+VY8bGcYTCpAhBr/9IheWXQqx0vQB9TmEgcQCUdn2mfauCxwdNy30mPM33GpQ9+ZFCZn2QnM5Im/hIAnDiNYM03q698j9mSmGKUmFyBKRZvwxRwM6XgFTvtqucqo3EpPh9j7D8nhaFdXz5+zvvgMiWjSjfiXqNJscVZUg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXkuyy6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXkuyy6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D743EC19424;
	Tue, 17 Mar 2026 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768144;
	bh=e5q9W155di7LjAWA5bgkmYy4FZcen3QjpxajVAyKEkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXkuyy6xEOJwuOKOqnGP/VEK6dFlMdZaE+51NkOYRNC/r04rCDNZasFUMy5yLM7Qa
	 pkQebuE95bWjtl5+Yz906v+OS6gcjAOZ0Rn+2cHipgwiMt2hWKgn4gJhJ6QnozlqVu
	 mWskvvPNAWECwBMHMxXvMyKkNB2Q0KsWnpJW1+xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 239/333] s390/xor: Fix xor_xc_5() inline assembly
Date: Tue, 17 Mar 2026 17:34:28 +0100
Message-ID: <20260317163008.227144978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Gorbik <gor@linux.ibm.com>

commit 5f25805303e201f3afaff0a90f7c7ce257468704 upstream.

xor_xc_5() contains a larl 1,2f that is not used by the asm and is not
declared as a clobber. This can corrupt a compiler-allocated value in %r1
and lead to miscompilation. Remove the instruction.

Fixes: 745600ed6965 ("s390/lib: Use exrl instead of ex in xor functions")
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/lib/xor.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/lib/xor.c
+++ b/arch/s390/lib/xor.c
@@ -96,7 +96,6 @@ static void xor_xc_5(unsigned long bytes
 		     const unsigned long * __restrict p5)
 {
 	asm volatile(
-		"	larl	1,2f\n"
 		"	aghi	%0,-1\n"
 		"	jm	6f\n"
 		"	srlg	0,%0,8\n"


