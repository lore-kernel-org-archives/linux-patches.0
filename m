Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063173;
	b=3QhtAynOnKk2WUvqUSdwrlg3uDLZShB0kttGhRm6UlIf2pJoRIMxfe8B96z1KpIoLNG6
	 iFadn8l0xtT1ukyMBjQihAXTr8oiivVHglwxrpUuLlWU3W2rqxzGWShtPv3QyrFlLkYHx
	 33Qafg3OIOJSnjYQZuSpzlOMTE/9k6m/hLrSt3WHENWCiDCZtnKSZObC031kLSzWHo/lO
	 nYhze0AXNvMHBIA0VgpH0VoWHWr1JmOMFiVGR0yt01oLPeTPkPxUXkwyrQs/1HggPvgsg
	 aLpE6PrARCnORCZ5Z5GonIW9nELFQDxkEW4LTriscTnEiPHtk9sQMIujCtInfX0oSLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lpBB73T332H1q44qIZWwCM24m+9+spH0ha3iEmqHWwk=;
	b=0cRTqXm5gIBjj+QVm7NOnH2m+ayvHF97R6rNDsLdAXW1Gg9V0IxLhpPMw6JaPT0lWG6z
	 qfk6nTO6gbbUbIALT477moKkEfo+siuKn3SqxCRQQ+5YLSbcGTSrh1vHEuvd4s5rZgYjF
	 jDL6BybHtmZRco9dNNZ0Yr3L/FyiDUphUinlJd9Fm3X6Rsi0ab5C6DxTv1eNqnc82EOL/
	 1iq0N/nXs8ABN//SYsAWoX50+yb1a9bE5D1/Ejh1dDbBB6DmmsA0l1VFCTdDsCuXqgAWx
	 PVYxKVLLjkAOkehcH51m0dWjyB2FlKasbfJsUwYzloJozcB4doR60PhNQf7hiez0Aew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEg2Xxel;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4FD606D802;
	Sat,  7 Nov 2026 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEg2Xxel
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0121F0089F;
	Sat,  7 Nov 2026 14:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063172;
	bh=lpBB73T332H1q44qIZWwCM24m+9+spH0ha3iEmqHWwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEg2XxelUfV/TCjiMVUPDlxxgCnXA4RdRe1YGf7QmBx9u4mKE15qUysk2/7wT3YtR
	 VGmM4rK/3lNC6EIoxM71mtJnAroCMd+gQdxI2STtn2mpyYvfh+jwwsZOpGIyrAgChE
	 Lf+zKkizDoMKg8i40sZZ4Vxtp7iRaHaUGHxF/7nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Moulding <dmoulding@me.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/869] init: fix early boot crash with bare hostname parameter
Date: Sat,  7 Nov 2026 08:51:12 -0500
Message-ID: <20261107134906.657095154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit b6bec5b63a5b812145e53aaad1e63661c7214f93 ]

When a bare hostname parameter is specified on the kernel command line
without the '=' separator, early parameter parsing passes NULL to
early_hostname(), which dereferences it in strscpy() and can crash the
system during early boot.

Reject NULL values in early_hostname() and return -EINVAL instead.

Link: https://lore.kernel.org/20260826100904.296151-2-blum@kernel.org
Fixes: 5a704629f2c1 ("init: add "hostname" kernel parameter")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Moulding <dmoulding@me.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/version.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/version.c b/init/version.c
index 94c96f6fbfe6a..0bd5c45aabc46 100644
--- a/init/version.c
+++ b/init/version.c
@@ -23,6 +23,9 @@ static int __init early_hostname(char *arg)
 	size_t maxlen  = bufsize - 1;
 	ssize_t arglen;
 
+	if (!arg)
+		return -EINVAL;
+
 	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
 	if (arglen < 0) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
-- 
2.53.0



