Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021242;
	b=CLu197NNK9Pwpxp8KcX8zya1yWU+47QHwUxMB9CXuON57L66EtzyvCYE+mw+BvjFRu9m
	 Ju9yoSOHky+Gg9kyGw4HZoFEJV2qXujV7OTFDY7x8AHKeUrUOO1bVYef/mv5pkVd2WSms
	 rPGfW3aKx4JU/Ja/kC33xgzpZ/hFZoeh+Og1Atnus/jTdf6IKYHZJlibtk7DnHzLA6/HY
	 FXDuGeXo55ydX/HNv8jWm+bZN53sogUZJpP1vTGE4aLo0rbA5nuxJfW61zmbHMdBtUk3L
	 F9eqzo3gv0aNlhkrO9WXzKedk7uVd17cRH96GGwdz8LIDWthpGkZX8Gtvrmktct1FoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hdJ63rQtZgbUVJuF/+RtrZrRqQGyGIwc23rirbpjF1k=;
	b=X13qzSyWXMt3gVaIsEauBLt7nYfM6Ld0UzdoQVFbNf1KOv8EVzl69dl7yU4YyT4A3OYK
	 H00TtkK67LjizciOCAGxGAJS0nlAxM0DKvfFkDqPQNAYz9WaB2moF+NXe/rHpjLBSC2KK
	 HEwtHOH1KgobK8X5QyhrYvEsMDW4Q3kn4u4Tx4JurxHE0C7DlvfAEK6xTMG2ofGfx7DL2
	 6Je4RPN5nR4mgWsfWtFYlHolUlrNZTrSDvjkKxBZ5yhYTXZg4OGPvmYkatNIXy2XXw+7C
	 Z0yMdXN/iKV5n9DkY0ov5EUeVhYJG5Ubs0OhYPtI/hTqPWX0b3tX/80Q4QtJxYgMEFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkFbpPg7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E911B606A320;
	Wed, 18 Nov 2026 17:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkFbpPg7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EC11F000C4;
	Wed, 18 Nov 2026 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021241;
	bh=hdJ63rQtZgbUVJuF/+RtrZrRqQGyGIwc23rirbpjF1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkFbpPg70JtfShGzI3evxNPhU9WRAbov4jZoSFjAEKlxufAGdN47K2O/xK3q2sxZY
	 O5CT3S3OG8R6WOmfImCLJRGpXof2/0HjIkMcU/SxZnqoA2+w+rtcilG6aEXCQVdWaw
	 UL5Nanx3yATFAmG2uiyCDmGAr2r9jxS+MnI6ReM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2238/2651] timers: Clear pending_map on CPU hotplug
Date: Wed, 18 Nov 2026 15:57:58 +0100
Message-ID: <20261118150406.064074488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Hao <haohlliang@gmail.com>

[ Upstream commit e7cad586d73276cbd4466de81b2092287d7475c0 ]

CPU hotplug migration leaves pending_map bits set on the outgoing CPU
while its wheel vectors are empty. After re-online, a later next_expiry
recalc can treat those empty buckets as pending and temporarily pull
next_expiry forward until collect drains the bits.

Clear pending_map under the base lock after migration in timers_dead_cpu().

Fixes: 500462a9de65 ("timers: Switch to a non-cascading wheel")
Signed-off-by: Liang Hao <haohlliang@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260930063621.37740-1-haohlliang@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index ae9abf14688e0..fc374444acb63 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/bitmap.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -2541,6 +2542,7 @@ int timers_dead_cpu(unsigned int cpu)
 		for (i = 0; i < WHEEL_SIZE; i++)
 			migrate_timer_list(new_base, old_base->vectors + i);
 
+		bitmap_zero(old_base->pending_map, WHEEL_SIZE);
 		raw_spin_unlock(&old_base->lock);
 		raw_spin_unlock_irq(&new_base->lock);
 		put_cpu_ptr(&timer_bases);
-- 
2.53.0



