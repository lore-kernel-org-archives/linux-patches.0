Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED40E37F8B1;
	Sat, 12 Sep 2026 08:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201251; cv=none; b=EwOXEEFt5KKCopKrfaUCgr2T2EBZuUsdALDjaElGhHWKUTuf3PA8pjLATuEmrKM3vi3OxzuRGDTSAkTZ/Q2d5paRsgg1qus9Jf/FrI0Zw8i1+79gXX/CO7oTixPTE9XlZ/xsybbKeL7nESVjgtvhp6XP944ICxfEB+g1TAZcOkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201251; c=relaxed/simple;
	bh=SkL8l43Uy4VBk2g1sX28zUti7qdl/4yeXyeSKEoAVJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8h+GtPcSsN84EAWd5mjGd2U2t7lu+4Fj9VLSGvzW3cdFOGiJhuLyLlq38PJCLa/Cc33pyxSF1pdVRmMiW0B5PQk4M8hLVp6xqNqEv7JMwDYuPgJKuXM0VPT86n4GV8OQIiKdSgAS9j09wwrCxu4JZidRMr2CiehzauTIblBaLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlB/sQhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlB/sQhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA2E1F000FF;
	Sat, 12 Sep 2026 08:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201249;
	bh=TMqjSScsB0dUMsFl94IMbU4HGBH6JjHtCyhor9gJKpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlB/sQhYsX1GuTE1ZuxTxKTgta8nyp+plUrwOMFO4DBypCsEI6uX95S1qVgaiuekB
	 59jcqqWAqCxP/Jr4NuyHlSqLXfyu2r+N5+qCsQwvBwQdp0KuXcCtmyxwpKrDvFz+sn
	 FbpBm8eZQXr4Pa32VsD+/GsqScvW386y1ZUaLdPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0956/1815] arm64: smp: Fix IPI teardown for GICv5 flow
Date: Sat, 12 Sep 2026 08:45:06 +0200
Message-ID: <20260912065711.413053936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cdcdd160e5b69..3ab90aa24efb9 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -1086,7 +1086,7 @@ static void ipi_teardown(int cpu)
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



