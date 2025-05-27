Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607DB27B51A;
	Tue, 27 May 2025 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366065; cv=none; b=AvJbh/E7V6cTu/CeGImRN0+mcHRCgpt9qz+8JOcIaHiGnLLlrwhMHld0IOb2l61QFRnCbgh9CexXFaYyX+l0+qUa9hqrLaJ2iQyLWGZZhGNCW6FGRC1rpWWozffoBYO+3dsMnxVh5iMQ1n4t3WUbKZyoNOlR4M94XW3OETVE7yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366065; c=relaxed/simple;
	bh=t6vGKDCrVWE4zlZ0mEikhCmztRAW+TEFKynXmt17ipM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u648JR6lT7CJoW3tiUkF6Yq0S4z3BjohQy1Xq9Djbl6q9STe7nU+4kO00Hco+H71AKnrclNyCdLri6LJiiBZRC2kDZ/15365DX/MxjsApRtkPtllPYLevjgIsuG8XBTItZbjiv1r7YjLvFFv6vses3JlKJ0V6EhiT6LSRsj5P4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIH7hg4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIH7hg4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C73C4CEEB;
	Tue, 27 May 2025 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366065;
	bh=t6vGKDCrVWE4zlZ0mEikhCmztRAW+TEFKynXmt17ipM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIH7hg4pKeWmhthGIka45Q12hhikSY2SW7Sz3UQc8bOVNc0jq7fLjxRMTsMGaP1s3
	 QDg+U4BlTe7kAyit7bz2QlO+NoZI1fuXOYQ4Oe9s7V+0EmEE5sAhzkwVD6rCZBfQor
	 5VdLByccVq4WQoXe2ilxcRq6NYcjXVIfhsTZFDys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Bresticker <abrestic@rivosinc.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 549/626] irqchip/riscv-imsic: Start local sync timer on correct CPU
Date: Tue, 27 May 2025 18:27:22 +0200
Message-ID: <20250527162507.288182803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Bresticker <abrestic@rivosinc.com>

[ Upstream commit 08fb624802d8786253994d8ebdbbcdaa186f04f5 ]

When starting the local sync timer to synchronize the state of a remote
CPU it should be added on the CPU to be synchronized, not the initiating
CPU. This results in interrupt delivery being delayed until the timer
eventually runs (due to another mask/unmask/migrate operation) on the
target CPU.

Fixes: 0f67911e821c ("irqchip/riscv-imsic: Separate next and previous pointers in IMSIC vector")
Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/all/20250514171320.3494917-1-abrestic@rivosinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-imsic-state.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/irq-riscv-imsic-state.c
index 1aeba76d72795..06ff0e17c0c33 100644
--- a/drivers/irqchip/irq-riscv-imsic-state.c
+++ b/drivers/irqchip/irq-riscv-imsic-state.c
@@ -186,17 +186,17 @@ static bool __imsic_local_sync(struct imsic_local_priv *lpriv)
 }
 
 #ifdef CONFIG_SMP
-static void __imsic_local_timer_start(struct imsic_local_priv *lpriv)
+static void __imsic_local_timer_start(struct imsic_local_priv *lpriv, unsigned int cpu)
 {
 	lockdep_assert_held(&lpriv->lock);
 
 	if (!timer_pending(&lpriv->timer)) {
 		lpriv->timer.expires = jiffies + 1;
-		add_timer_on(&lpriv->timer, smp_processor_id());
+		add_timer_on(&lpriv->timer, cpu);
 	}
 }
 #else
-static inline void __imsic_local_timer_start(struct imsic_local_priv *lpriv)
+static inline void __imsic_local_timer_start(struct imsic_local_priv *lpriv, unsigned int cpu)
 {
 }
 #endif
@@ -211,7 +211,7 @@ void imsic_local_sync_all(bool force_all)
 	if (force_all)
 		bitmap_fill(lpriv->dirty_bitmap, imsic->global.nr_ids + 1);
 	if (!__imsic_local_sync(lpriv))
-		__imsic_local_timer_start(lpriv);
+		__imsic_local_timer_start(lpriv, smp_processor_id());
 
 	raw_spin_unlock_irqrestore(&lpriv->lock, flags);
 }
@@ -256,7 +256,7 @@ static void __imsic_remote_sync(struct imsic_local_priv *lpriv, unsigned int cpu
 				return;
 		}
 
-		__imsic_local_timer_start(lpriv);
+		__imsic_local_timer_start(lpriv, cpu);
 	}
 }
 #else
-- 
2.39.5



