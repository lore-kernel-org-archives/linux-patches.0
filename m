Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062044;
	b=h3jv97//+r+pqqOA/PmQMzZja9TtutAoK1eLY9BzzDgMw8az9wNo3NflYeIaJJyFqcYr
	 7r9qFqQSmu2G4/AQuDECd1GYESeDpzobw+Hn6Ddb/5awPHDfW96ZnnjHJBK8q3RwSvEgA
	 hTU6q73zsK4gNLAHw5X4y9h6hDbqbLc4GEfPA/mTDk7VnEad5j7da7VvWh5oTdMW5uvgm
	 rohMTNcQIRsO8rBJLmvWFPFdI+b1hZ5K38zuUvaD4LlJtY8P+lct9QpCgU1t86gVdQmkR
	 nzhpj3nIdSByhvGufzGTMWxilcnshU1Qgotw7X8Zm/wO98dbkf8ASy1+KTbmjndA+Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t75kyClrVbZ2EGn+9hocnf+RoRnkp5h4wPwwDB3q/dM=;
	b=ZgpwudEjVHambbVpNFvG+gq0rX2PWApNjaY9Dqal7nHNoss6DadJYxhSJu5SoYiX4OGa
	 AmzvpgH5ccwULPlABeW6Qm6eu7scXP+0DVH9JVU3Wb+Qysxsc9GyqmYusKXxKqfBXnT7N
	 GBew0Po0AULUs+3qOaOEh6Jod9vyhr2xv1fzIUJ1z6ASUhmXtL+WPn+qQKJotsg+ncBn5
	 jX0ATc46a+F9sJAMAsOabwhL/bTJ2XgxfdBsi+TnV8DKgDMqTuyOHE+G8E05MgL9fU3k5
	 Z18NHbIJNPrzvnvfxXzahkqYHiEvFj0+5gIlPdnmy6dOuvkpInA9etNoyPd8+4g6tHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RtNx7g3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1217E606A325;
	Thu, 19 Nov 2026 04:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RtNx7g3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694521F000C4;
	Thu, 19 Nov 2026 04:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062043;
	bh=t75kyClrVbZ2EGn+9hocnf+RoRnkp5h4wPwwDB3q/dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RtNx7g359dldwRBpq5g4wXG8l2In8m2jMtKPXKjrnz7EL8nWEfCX/thcADoqSSJ+
	 g9Q0TU70DJ10t2umwfCZ7AhQS+4oAJZ462fcdgES0N1Nmi5qgGidurIxkMWnxER9IC
	 CKELhsgzS+oSgN9UlUJLG8YMKZKXD9FDaAC/sQ9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1732/1848] timers: Clear pending_map on CPU hotplug
Date: Wed, 18 Nov 2026 16:02:50 +0100
Message-ID: <20261118150032.086450445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2b1afc00e3184..50a512c2403cf 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -45,6 +45,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/bitmap.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -2035,6 +2036,7 @@ int timers_dead_cpu(unsigned int cpu)
 		for (i = 0; i < WHEEL_SIZE; i++)
 			migrate_timer_list(new_base, old_base->vectors + i);
 
+		bitmap_zero(old_base->pending_map, WHEEL_SIZE);
 		raw_spin_unlock(&old_base->lock);
 		raw_spin_unlock_irq(&new_base->lock);
 		put_cpu_ptr(&timer_bases);
-- 
2.53.0



