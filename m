Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F0646D57C;
	Tue, 21 Jul 2026 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648678; cv=none; b=V5DYwdzx8Lj2j99JXV7trqzLS06hYK/kyIfYjmRiO95VH7EXLUnC5xxkydfCwuueuY/R29qddm6pVrwklm5Z2pZ2++Pdhgd11guzfEmCBqUt3TmtjgWNenPJfSWMNpaJylMPpMXDQ1yEeA40xutkPi6c17u2uE7X9r6aFGnFvTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648678; c=relaxed/simple;
	bh=F6klinQTeEfCaDq1El5Cw1VijRITeyieTI1jVS6XY+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eyiux5hYv8OPxG+9O4Wk/Cvzg8ucnIuj6oI5o2OzTboobmnG9hNQx6BPAGLZqMZfY/cr0ENrd/FwBXth3GLqsfO6Qkzs1hO+AmDocvwMJn1VgLN7q5yajQLFt9iskwVTi5JWenYQNDDl76ofN5fIJsSf1lyJn1JX/+ow1uHdu+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/jUA9sl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/jUA9sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0656A1F000E9;
	Tue, 21 Jul 2026 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648677;
	bh=QChAH4yf2ePmt7FR5WNs6HLSV5NVd0rofzP995eZmo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/jUA9slsf8kRiHrRj+Xssk9H91uYVj2z4wwRgKs2DhtjOe5olD7XyvqHsMv+9j35
	 i+8kvgy8sDGIkQWbBSe4zui8xaSCX3Y4tprmCTJiNcq1TQY3/wFCZQRELl5HjXa/EW
	 2aSz6FnA4AJSSS6APo7F19zx215HIF1g2F6Tc/6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@thingy.jp>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0290/2077] tools/nolibc: stackprotector: Avoid stalling program startup if crng is not init yet
Date: Tue, 21 Jul 2026 16:59:23 +0200
Message-ID: <20260721152559.517789956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@thingy.jp>

[ Upstream commit b882d807fa443b529ae8bf917d7b640a8d555437 ]

We are using the getrandom syscall to get a random seed for the
stack protector canary but we are calling it with no flags which means
it'll block until there is some real randomness to return.

This means that if the crng is not ready yet program startup will
block and if you are unlucky that could be for a long time and
look like the program has crashed.

Even if the call to getrandom does not yield any random data,
we will still initialize the canary.

Fixes: 7188d4637e95 ("tools/nolibc: add support for stack protector")
Signed-off-by: Daniel Palmer <daniel@thingy.jp>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://patch.msgid.link/20260522090726.726985-1-daniel@thingy.jp
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stackprotector.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/stackprotector.h b/tools/include/nolibc/stackprotector.h
index ae8b1d3a374dcd..4d1aa5371c77c2 100644
--- a/tools/include/nolibc/stackprotector.h
+++ b/tools/include/nolibc/stackprotector.h
@@ -42,7 +42,8 @@ uintptr_t __stack_chk_guard;
 
 static __no_stack_protector void __stack_chk_init(void)
 {
-	__nolibc_syscall3(__NR_getrandom, &__stack_chk_guard, sizeof(__stack_chk_guard), 0);
+	__nolibc_syscall3(__NR_getrandom, &__stack_chk_guard, sizeof(__stack_chk_guard),
+			  GRND_INSECURE | GRND_NONBLOCK);
 	/* a bit more randomness in case getrandom() fails, ensure the guard is never 0 */
 	if (__stack_chk_guard != (uintptr_t) &__stack_chk_guard)
 		__stack_chk_guard ^= (uintptr_t) &__stack_chk_guard;
-- 
2.53.0



