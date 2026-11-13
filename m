Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591581;
	b=PRKMxOsKzboIlEFeIuSQ00lHQXLgXd2EORWp1lwOXWQaZby24CfmKVn+tfPP7eJbFLiv
	 Ip+aT2dNPAJfFSurJIKsQqLsZ1VjDVBlXOT7jlUDk0mo3QVhN0EWpr5q0m5ihRr5gdb/P
	 tHvckh4siiY/BbHp5C3FL/ZAArzxNALmeOdZC8FfTkUuPB/N18V87kmp1PGi6CoyqsR/E
	 M1tz6iuCEKJCyhX7TqapU/jW289w+Z/iSn3DZLODY7kY/NzGYHaOoOrNXpONo8UJpAUjy
	 0bDH9jsOg7v5rp6dSzrvUer40bKRAM42WUNmY9OkKiTGMePXGk91IY2l6UvAF9Yp+bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QSAOwRXfVzB8GdgLiXzrXKEBWLI5ILVDKeLdXLoJKJQ=;
	b=gJpxprRqxqpNTQKGD9k0EMm/JsziMTCCd9SBpZtDyD+r6E+wOEsPwp/Ux2BOXqDXN1rC
	 9IdvYF9FY5YaBlg8Vdxl9RmHQFE96AVYo2xV77liPbvi7+OzR5R2/YFmQc5DV3rm770CM
	 UiOA7mGgER123bmVLAgEmn+SXjrQ/FxiDkkYlQt76LnBjlEoEwAuKLxZceJoXRKsXUHN+
	 A8L+X2RLtAOgZsbl0KvikkT8tngiVbqccunRhLRUk35sSxwH5LOWvZmXvUR1r2Ls5vSa3
	 kIeVlXPyrbnnps/VDWG5sef6fh5QIgxSiybgaGmVfcmy5zyEjMVfv9CLza7Em4neEiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1aodMC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4B2606E65A;
	Fri, 13 Nov 2026 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1aodMC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13E11F000C4;
	Fri, 13 Nov 2026 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591581;
	bh=QSAOwRXfVzB8GdgLiXzrXKEBWLI5ILVDKeLdXLoJKJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1aodMC4hpQexPy0sBRijSsHUQVjV2b2H6efXjCxBbkpemUEg4/ZiYmTTLP61y4jE
	 tQMF/Klv0P1VwRORNMo2SD6LoOmfi0WPmB47bIYxr/0Il3kyY8wcjUz7PKUouNs7IE
	 0TKyN10PMqjtB5JUaPx3COrmaRYaDfaPTLQyMDCU=
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
Subject: [PATCH 6.12 628/670] panic: flatten nmi_panic control flow
Date: Fri, 13 Nov 2026 10:53:12 -0500
Message-ID: <20261113153833.073307951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b4db7f62b8ed5..16c21189c8da9 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -250,7 +250,8 @@ void nmi_panic(struct pt_regs *regs, const char *msg)
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



