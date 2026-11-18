Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056652;
	b=DnTXKg+jWeV7uDYOr2hz8QEOocXtOin/70AGBDX4JFW3aOqikXwKiQdZBu1vtKgsNx+M
	 SX/RFfYJK2cc7dc3OtpCovfqZXQ7TJ835MRmJvCbbcil3N/IEvfWh/9PiaR6Aq1MYjJk7
	 tAo6ih8yBRUcNyB94/ZBawJVLEZeGma4Ub/rfiLCa/dRCYepSV2vMxr2ZnFH5E4cZxIfY
	 BPhCF85qBmM8+ctQdkE+Dj+NnX1tX6vDcwdQ4zD7gY3SkVqR4Nt7Ryob9by4wcfMv41kX
	 O/VP7KGTUJZnjvKDC3k8BOb+16uOMkKya5WNLpe5wrHdztyI4Qd6hqgs2EsxXKyzY4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MH8C+/jFTaMPNHSZpXudaEoOdwdiCwIEXGk0w8HKq5s=;
	b=EiiWH5zPdmDeNwzHy+WeTv0NQvNDmBIYh2zNzmf4edSnwZ88VtdKBDMcp9PuOl3k9nab
	 zTTJVPbn8TEqDemUgv6Ft/ZAy89NQrib8BPmeuFE/iCp+qiEkdKHtN6qAVvcWtvtn32dK
	 DKjbMq7K33EIb7xIruGfdhcxdT9FbvN2btk/nvwN2cn5WLg+Cv7hf724ISKUpEgxxsH7X
	 q9NLP8z4//KMRdn2/mMNQHCsbVuCP98QQfbJdPhNrgpa1uOILXVTlUfKEaK723HxMJTmq
	 Xy3lHCphYpOZjInl62osZnkRWDgJyVdgPWrB+4eWLDGSocrzrE0VBB3iaRlSe9Nibcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aM6qYDW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82127606A32F;
	Thu, 19 Nov 2026 02:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aM6qYDW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D878D1F000C5;
	Thu, 19 Nov 2026 02:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056652;
	bh=MH8C+/jFTaMPNHSZpXudaEoOdwdiCwIEXGk0w8HKq5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aM6qYDW9PDXWternx/KVDgNzzJp9nxipubPmLCSv+lQjFn6lrH3L7TmLGo5ENSNkt
	 bZgRdMHXxISQo3+/UsznQfcQFeLGiPGmAFkpiDPnxjOdal9encamdx8VJqYKdif+GG
	 mrIuu/KOwdqEE1RJRn9+bDi88RWFhi4LxMY1fGl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2063/2214] timers: Clear pending_map on CPU hotplug
Date: Wed, 18 Nov 2026 16:02:19 +0100
Message-ID: <20261118150133.185424544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c943f0c123aa7..5adb8539085db 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -45,6 +45,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/bitmap.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -2244,6 +2245,7 @@ int timers_dead_cpu(unsigned int cpu)
 		for (i = 0; i < WHEEL_SIZE; i++)
 			migrate_timer_list(new_base, old_base->vectors + i);
 
+		bitmap_zero(old_base->pending_map, WHEEL_SIZE);
 		raw_spin_unlock(&old_base->lock);
 		raw_spin_unlock_irq(&new_base->lock);
 		put_cpu_ptr(&timer_bases);
-- 
2.53.0



