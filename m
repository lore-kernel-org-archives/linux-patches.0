Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063357;
	b=paBZ0Ndlv1IW/bDnjbe5DBcmSKI9nOsvjTWj1YIWjAe55aGW/5wk7lSOtXH8Cl32Ziww
	 xSkP5tKvYSYlAZRRWD9jbqUVIlQVgOCfjB6PNvQf6exDx2nzzJbL95fpnC/rT02Su5J0f
	 Mc+rX/glyTVeOXugSJ5FsHnwOZQnKngRr0QCO5/lh9zA4FwYmdCiMEKTNmodp66H8bSWB
	 lB+oHwv7qdqghy3+wtPZqEBLsKGCNqvmYeTdTT8w8rmXZw6svEB2jNwPJzMeeyrYXuJTm
	 +FalpDVu15LAL3qZEJRsfB/eN6D63J9FLc7ud2ohAeEF2GxblsaBEHHBCpNHiEEtHEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUwhMjgV4B2QE9ndvlkk2yHEjm3VmOOK3bUbe7t8W3E=;
	b=gqL1NLMUDcy7+oIP76Rpv1stUvgPNqvFAMOH3g8ZsVUaoPPc1w5GaBJ+d0PampPF8gbt
	 Z22PHwEcQXg+Y8C9UDmVXGw8v8QbvYvNHG3Owykmog2niF7Z9YCVYQhcUJ8nJa+JjCkn3
	 Fmr1fz8LxrTmC8vfTnCd1tqGXU3hUssWms22BPOXd22PJUZH3NGSioxwQ+FowgbYBLTdB
	 JwamoXaMdDX7heWzKQrMXuUQGy4ae31SYRghn+7iSoGh2wOdWRLZRTZ0lOJTc+T8GjgUk
	 hEkM/Et4pljzB4pcKeO4jTGhRbX9sc9FxnwSTW/ul9C7oDkmkHwsVyT98b/CaiDly3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xErSNM70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E8F606A336;
	Sat,  7 Nov 2026 14:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xErSNM70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB9F1F0089F;
	Sat,  7 Nov 2026 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063357;
	bh=HUwhMjgV4B2QE9ndvlkk2yHEjm3VmOOK3bUbe7t8W3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xErSNM70MDctUqfEo9TijsDa3FDwVVXrj4req+295X/Qptc3ZT5vzVpb6Z8K5nayc
	 dwm/6Muzq0R8JXo+zt7chXwJm+CCdCVAE/21Fa17n7TZhAufoeH4j5AuU30qxLNsKp
	 LF4GV3Uq95Th4IQiCYQdX8E598pZcQWGiFCnZ1Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>,
	Guenetr Roeck <linux@roeck-us.net>,
	Sashiko <sashiko-bot@kernel.org>,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 536/869] panic: flatten nmi_panic control flow
Date: Sat,  7 Nov 2026 08:53:38 -0500
Message-ID: <20261107134911.613874956@linuxfoundation.org>
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

From: Bradley Morgan <brads@mainlining.org>

[ Upstream commit 75eb687ff2bcec9fba31bbe266e5f91e5c283efe ]

panic() is __noreturn, so the else after panic_try_start() is dead.  Drop
it so the force_cpu path can be added cleanly on top.

Link: https://lore.kernel.org/20260916182957.7788-3-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b13f040680ac1..7f8725f2154b8 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -364,7 +364,8 @@ void nmi_panic(struct pt_regs *regs, const char *msg)
 {
 	if (panic_try_start())
 		panic("%s", msg);
-	else if (panic_on_other_cpu())
+
+	if (panic_on_other_cpu())
 		nmi_panic_self_stop(regs);
 }
 EXPORT_SYMBOL(nmi_panic);
-- 
2.53.0



