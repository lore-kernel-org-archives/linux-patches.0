Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050252;
	b=QdUESkKyoS0NqVhoEd17EFiRctfI6IaHGEs0LsrlcNRBTnRyHQuKVrKy2f6qEuBV2zvX
	 RRSAM4ZtdzWbx0VQo4gLhjYjMBpDM/U8CvVQasu73566M2RcsS1TP1L97rCROntRTisFw
	 YFXQXj3V/+VHeIIQcPsBt9zRiBvA2ebsVI3E7yy+LdbUa1mmL57KBef41tl8XuJwAS5NY
	 FMi4aLdE43E4KOpE30eagd6gK03sdl+Rs1jqA9dB4y633/2u23eCQPRWYjxAnbML/LtSE
	 AqaJTQjRXhU008O9qkaVurxcD4Ai8YyToLXHucy3dK6wQC+ZNj3WbHeDk/H7VM0Enrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+O4N83MCTexJmhgjaIsZy5Znuhr05rQ6mhGyOsCtVMI=;
	b=zVda52YkM9Y7X2nCisOBG91mpaqrBEP2d5EZcAIq01M76l5Ao6dCOvGS9l46HJWz/r2p
	 LTy6SWmWSUZyaXKLkNZIpfkcb0dwMhHGML6g6yOo2Y0XzzxAhRPu6ioaScoUnz0ktCctv
	 VtShbi2RFML3ndVhP6juqAgSrr4Eaq6EVvy4c90jptrd5krQEe68yNxeEeDzbguxL+Lij
	 KI4AsmPD3T9mhYDtCE6+Oqu7Mz8fhtMZnlR7hLj7Nhl8nwtLb6B4LPLH2OLwatzyL6/Lf
	 lo5Q5fMBxGVZa8tmT/xARwY6nGchUioF2xeKXai1aGMCbPxpRH0SikMNn0r+b5WEqCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="btRG/LiI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE31606A331;
	Thu, 19 Nov 2026 01:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=btRG/LiI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBC81F000C4;
	Thu, 19 Nov 2026 01:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050252;
	bh=+O4N83MCTexJmhgjaIsZy5Znuhr05rQ6mhGyOsCtVMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btRG/LiI490Nz0q9Un5acA54V9a5lxa9TAqxLpHF3bVgYCyQaqXB4Z0L8C0pJTEXk
	 bZLo0pFjU7z5Q/ie41vEid+RD66CkM1Cvq8VS6l6vRNfilA9Ah5dGojO64q1ATIfoN
	 3Mw8kKCAoBpr9F2CD7IAn3R3GqghpoSuWwFQmgTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2642/2857] timers: Clear pending_map on CPU hotplug
Date: Wed, 18 Nov 2026 16:01:16 +0100
Message-ID: <20261118150336.717692447@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cf86c1d9d68ee..0988a8cbfac41 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -45,6 +45,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/bitmap.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -2273,6 +2274,7 @@ int timers_dead_cpu(unsigned int cpu)
 		for (i = 0; i < WHEEL_SIZE; i++)
 			migrate_timer_list(new_base, old_base->vectors + i);
 
+		bitmap_zero(old_base->pending_map, WHEEL_SIZE);
 		raw_spin_unlock(&old_base->lock);
 		raw_spin_unlock_irq(&new_base->lock);
 		put_cpu_ptr(&timer_bases);
-- 
2.53.0



