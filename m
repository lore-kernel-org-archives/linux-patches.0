Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039167;
	b=hIUgeSA5UcW9grHE5fNG3+aBASgb4max+k6dDiUlUBmMnexgYjmdZc7yUsSM9vmfRl0d
	 ajmEwBMsoaCfJoCOVturE+YRaDFpEh0D5+knUy+j2g3XyJVetdjsJokAS3kS0Nu0e29Mq
	 xb3QxU4TXjN9npApIf1H21CYL1Z9qEM8xH2WrCoRzAIfpE4/lNF2mI4IhGBM3oZ7jADGt
	 FAXHJcpkiYYxS3XN8LJv+PJ3lpE/RBuZ0r1Gc1oLFxCg+K4/leszoXaGvxF/7wFdJbxaQ
	 O8jjObVzTySVB1GcphkpDfdzOsc4UE3A/cj6TQMALVliJ5XCqM1Ha7CHXLDEbI6fD7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fsiCWjrI8nYyW8gcOy/vfKMy7fNkKapACl8MH50mSac=;
	b=eIViYTK0w0RBQtJgghLLy2kftkWSa2sJAIW58Ttqr8p1wzLif3WxG9P4wOL/7KZEJWNY
	 fazbrSq7NCW+KDfPILGUg4+PDKZ8S08dixgiFZAD1xa7iEUVHCl/lGCoT6n9TXInLRDr5
	 rJzwKTdZaQFEZRVLyhwYBU3dzuHilqmh4JJ+BfOZkPgli/R6OpMHgO6m5O/jorkCejkOo
	 Ret+sgKNowDsigJu4yzw8fqYduAnivNafVznXDswMgqjr1BXZVKQS6hcoebyzX0syj2CY
	 +hzV4cm/uM9snYiRW1jR0B5txE2nKZ7znbqhfz3ZKmdAEL6xf8ZAFjxohE8L32FJbUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrU9ZXoL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C1C606A33B;
	Wed, 18 Nov 2026 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrU9ZXoL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E601F000C4;
	Wed, 18 Nov 2026 21:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039166;
	bh=fsiCWjrI8nYyW8gcOy/vfKMy7fNkKapACl8MH50mSac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrU9ZXoLQLlgZu/sHvzH8/Hg4X1ODWA/z9aQLUSbdtDR5dsLPkIWe2GAp/nmoTNJm
	 Qek1ZgFw41du34dOV1+2ndBD7BIhuekmmrQZt+s5YD6i7U3AqShrZmuW6bvyV+XvKS
	 sGjua5u7uBdedBkUhQb30wnfis1j0kcc8F4ENMGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Bradley Morgan <include@grrlz.net>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2001/3318] kexec_file: stop the top-down search before it underflows
Date: Wed, 18 Nov 2026 15:43:43 +0100
Message-ID: <20261118150422.078809290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c711461303af9f796b293b5ac06f49a885e46e71 ]

locate_mem_hole_top_down() walks candidates downwards by subtracting
PAGE_SIZE whenever the window conflicts with an existing segment or with
an architecture exclude range.

Nothing stops that subtraction at zero, so a search that reaches the
bottom of the address space wraps temp_start around and continues.

The walk starts inside the range being scanned and only moves down, so
bail out once a candidate ends up above end. That covers every step in
the loop rather than the subtractions alone, and it matches
locate_mem_hole_bottom_up(), which already bounds its candidate on both
sides.

This is a better check than subtracting with check_sub_overflow(), given
that we would have 3 subtractions in this block, and this single fix
would take care of them all (instead of three check_sub_overflow()).

Fixes: cb1052581e2b ("kexec: implementation of new syscall kexec_file_load")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Link: https://patch.msgid.link/20260812-kexec_posioned-v6-1-e477887086f0@debian.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 92a169f0b2b57..deacf6c23f798 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -432,7 +432,9 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 		/* align down start */
 		temp_start = temp_start & (~(kbuf->buf_align - 1));
 
-		if (temp_start < start || temp_start < kbuf->buf_min)
+		/* A candidate above the range means the walk wrapped around */
+		if (temp_start < start || temp_start < kbuf->buf_min ||
+		    temp_start > end)
 			return 0;
 
 		temp_end = temp_start + kbuf->memsz - 1;
-- 
2.53.0



