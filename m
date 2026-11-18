Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027479;
	b=DN+Q/B1osqoDZ64GEOPbLmL48HEwKl8ipLr2/Wt19G2W4bvA3pPccDMDAzsmBG/cNpky
	 Pr4m3o1Bk/xk2pNkEBLmDiz12z+Rm2jdacT4kydm5s/i2fOFoAwtQKS8ySjwt8F0y7Fa9
	 8CwtAIk0qVqL9Id9GBt6cR5noAnXOTbMr65DQ0rqmR2gqn3jFPMmeyI7362JZXF/+Rmbv
	 pOS5xepTc064/I7zI6WdhnvkzCwPqkUG/ws1Q7W6TMt7ryy4rvF0cx47ELJosDP8r2rKh
	 eEgSs6pbqVPZlOAUGFhDyfoYsqvvhRYnlvmxN+uWS8EW70G4oO8Jxya9c7rA1uP/ZHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RbZ/7+5k1ighefoTL5JZW1OyrDuJm/whkuV22afiEOg=;
	b=0yKcbNTxzIt56xQeEIWw5uQPPSWxR5YTPlk+6Fqp8hkMBqk7XhUcpwNIrPGZhwZDP1vi
	 pDuLL4zhViX5/HlLgJKCvDewN5s6J0XPKZdOUQzQ3DLaBwlvT3FopKVMtiaoqwO8aqx+h
	 UUGc/qC2egrBTmgaeUGeQcRkmb79PPm0yZRv53EetcCN+1JQaNXUILmW1Hy0kXkPbREeF
	 5vZmwsxIyWd3rf2X6LkkVAVp63EQnIeXpVJihxPXYzTt45NnQYdDiow526yeixiRxDsue
	 KIuLbMa8byHWpN3gXqx4PMJfJggp9nBpCH7KpDAublC+LNOeUl8Cv6LtWp4Pn2JHG2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGFXZhdu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0218606A335;
	Wed, 18 Nov 2026 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGFXZhdu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492FC1F000C4;
	Wed, 18 Nov 2026 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027478;
	bh=RbZ/7+5k1ighefoTL5JZW1OyrDuJm/whkuV22afiEOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGFXZhduBxcq290SYoJDInG0uW5XUjoa0yX89E+f798xrldQJNRqzgT9I/Ncq43lp
	 t8AOiWYyJADwuyp8wJdJwyWLmgGIHW1ejqvlT1p3e50VGBi/fQ8FMqZZOZenBK3UaK
	 PrvgQyTSRUQnmbsb+Q4KfmULCyJiO9W7C+GPgeMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1804/2151] timers: Clear pending_map on CPU hotplug
Date: Wed, 18 Nov 2026 15:58:59 +0100
Message-ID: <20261118150227.521440403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 97a7bd5a8e3b1..57deeb617c059 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/bitmap.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -2540,6 +2541,7 @@ int timers_dead_cpu(unsigned int cpu)
 		for (i = 0; i < WHEEL_SIZE; i++)
 			migrate_timer_list(new_base, old_base->vectors + i);
 
+		bitmap_zero(old_base->pending_map, WHEEL_SIZE);
 		raw_spin_unlock(&old_base->lock);
 		raw_spin_unlock_irq(&new_base->lock);
 		put_cpu_ptr(&timer_bases);
-- 
2.53.0



