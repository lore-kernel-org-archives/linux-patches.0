Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D0B415F0E;
	Sat, 12 Sep 2026 10:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209371; cv=none; b=gFUxmMk+ug+5LMrIiuiOnlztan2uA7T+UsIt8n9HmcuqBdSd5faejquNecos8aR1f+LFOzxBFC9w7XvwQvTOLlOAYl/OY+Eatv9rKogxJEGiuD6eRCaCgd67CCsJUxyNa4+XbrqpFNAetSeV0Da2R0eXKIZiEkW3bxi1sU3/9sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209371; c=relaxed/simple;
	bh=F4Q3sv5eWJSFG5XbYCnBl5LfENb1oMSiKO/dYOx23Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nC8i8tnCqpEtj2e1wP+pFkHrMqhfSEnyd3F0O+Z7pKqfK6PeDM6+vrHEaJJIy0YG3KWdrWdYfgg+4pxpEaDuuPz7f2uAkNHZjv+nl7pQyxUnd855Vb9461gzubrFMr95HFLIBaI8D2cNlseCacz5RsnkRUwnpLcvZkeSJhewNaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSYa3jlM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSYa3jlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DB01F0089A;
	Sat, 12 Sep 2026 10:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209370;
	bh=2rpmgzh8ekb5rd1maJJ//6y0ALoaXYgUBhoED+b2AK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSYa3jlMqjWbr2m1voeJGMXuh4o/RCNizQdtkBxQmrdtmmNKplo23ZUr4LXglViTQ
	 V6Z3tD6bT09ZeiVkgIltwLWMm1rADE9+7ZvyZttjVH2SebDO38Cba65adK6WprKTSU
	 2oWwlp0sBKeq/YKmx9Ufyghb0CRGaKcXhSvyW6Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0807/1518] arm64: smp: Fix IPI teardown for GICv5 flow
Date: Sat, 12 Sep 2026 08:49:36 +0200
Message-ID: <20260912065641.690457203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit 4c9c81a0860415284e9d260f998fbd755d3a7469 ]

Sashiko reported that during CPU offlining, __cpu_disable() is
executed by the stopper thread via take_cpu_down() with local
interrupts disabled. __cpu_disable() calls ipi_teardown(), which
invokes ipi_lpi_disable(). For the GICv5 flow, this eventually calls
the sleepable disable_irq().

This can be reproduced easily with CONFIG_DEBUG_ATOMIC_SLEEP=y by
offlining a CPU:

  BUG: sleeping function called from invalid context at kernel/irq/manage.c:702
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 20, name: migration/1
  preempt_count: 1, expected: 0
  no locks held by migration/1/20.
  irq event stamp: 186
  hardirqs last  enabled at (185): [<ffff800080b084c8>] _raw_spin_unlock_irq+0x38/0x68
  hardirqs last disabled at (186): [<ffff8000801f8e08>] multi_cpu_stop+0xc8/0x190
  softirqs last  enabled at (80): [<ffff8000800c48b8>] handle_softirqs+0x410/0x468
  softirqs last disabled at (75): [<ffff8000800102f4>] __do_softirq+0x1c/0x28

Fix this by using disable_irq_nosync() instead, which is safe in this
atomic context.

Fixes: ba1004f861d1 ("arm64: smp: Support non-SGIs for IPIs")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 92b57fc87ee96..6af97292e3692 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -1081,7 +1081,7 @@ static void ipi_teardown(int cpu)
 				disable_percpu_irq(ipi_irq_base + i);
 			}
 		} else {
-			disable_irq(irq_desc_get_irq(get_ipi_desc(cpu, i)));
+			disable_irq_nosync(irq_desc_get_irq(get_ipi_desc(cpu, i)));
 		}
 	}
 }
-- 
2.53.0



