Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062434;
	b=ovOsgKGf/4RQHO3Azve/sWpU6XWgMA+KuKjm8UreIREpib5Q8wxXo1M5/b1RPx3CeSty
	 vLlL/JOPg5SWROpxvEC9HGajOVkdeouLiLI6SHwA/cX7PPsehDsCWP9roALWm+WapP4kB
	 t0wgAYdqw95t1r5pN2U2icUQ2d6+d0fyg+k6rPtkDIw5qyM819r8bJyRIobW3+8kdymMZ
	 4I+v9y+MYaR1pjgf6JYE7Sb89zf98qLe2jrhSIoe7yqA6E7i2JC/spkQu/34XNJJVhof+
	 8uAvJuMQ0pHpkP1TTQWz12rl50C86Zt3l8CmImojjleriBjfC4AlPNYvtUa/tRGT++g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbUukfznEdwhfr4bNHk1IC9/fwwGRhweapRtw+VSUJk=;
	b=IuXjDEdokrow9pKTJn60dkPz/SrocNjaePwI0wUIkMoR0pbakiTWHXUBnabCDkb0EGvO
	 u5EsaoLjyPwZLHsT9apAveQc8BLlZxUfuyfB1NTGq9dlUxlKcbh3L47he3TAcetxOm4j7
	 YPyVGaVfZMq8x/uPwnrBrC1sToYZssHx2jHymw4brbsoXeUmLt9Ibk3ovU9TFu5gpFoIs
	 +SdlLaU4teHrgetSOOQJ7u9LC38V8nBnLnEpwQipgg1NQl/SByUdJ8In7fKnYV1QysZI1
	 7uU0nLFTl1Z/89YvSDIIsP5S+Dg1jkx2cLtdU9SsZOvQLjk2/xXkNSK4rzZckuKiKyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFJ3w3sf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF975606EE8D;
	Sat,  7 Nov 2026 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFJ3w3sf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5591F008A1;
	Sat,  7 Nov 2026 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062433;
	bh=hbUukfznEdwhfr4bNHk1IC9/fwwGRhweapRtw+VSUJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFJ3w3sfT2ii4Ivd5a0mklGosxbll/FPgRIFpL5DUMVc86eprqQiMYrK4t9+ZdsJe
	 ACEBRZJL+yxhzJHrgNvwtQGu6y+w+ZNBgoiglXctN0iAlZPF7zoFkfLpVtyUC/q78A
	 5glntln0PcFxsHBORXywwSZU9GCXFwlnCZb98AGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1345/1536] alpha: only use a targeted tbi() when the target mm is really current
Date: Sat,  7 Nov 2026 08:56:01 -0500
Message-ID: <20261107135035.600683100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 0d92845ac5dbc79e4ac4810b33c673f4c1c227e3 ]

ipi_flush_tlb_page() gates a targeted tbi() on current->active_mm.
tbi() acts on the address space context currently loaded on the CPU, so
it is only guaranteed to reach an mm's translations when a thread of
that mm is running there. current->active_mm is not sufficient: under
lazy TLB an idle or kernel task keeps an mm as its active_mm while a
different ASN is loaded, so the invalidate is issued against the wrong
context and the stale entry can survive. Nothing retires the old ASN
afterwards either, mm->context[cpu] still being valid, so the resuming
thread can reuse it.

Test current->mm instead and otherwise fall back to flush_tlb_other(),
which clears mm->context[cpu] and forces a fresh ASN at the next switch
whatever is loaded now.

For an mm borrowed through kthread_use_mm(), patch 1 of this series
installs the context before the task can take a shootdown IPI. The
current->mm test therefore covers that case as well.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-4-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index ed06367ece574..1ad448105201f 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -669,7 +669,8 @@ ipi_flush_tlb_page(void *x)
 	struct flush_tlb_page_struct *data = x;
 	struct mm_struct * mm = data->mm;
 
-	if (mm == current->active_mm && !asn_locked())
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm && !asn_locked())
 		flush_tlb_current_page(mm, data->vma, data->addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



