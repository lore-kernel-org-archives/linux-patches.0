Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042146;
	b=c4/Qm8proGdVTJzQTjuz8m9Hhyd0DLNms6x8aG5fewOQFdieafPUP+HHoHAAc1lKDVjU
	 zP540FT5il3sK2YNcC3gL7qzk+jddQwUTZSHxK1oB/H6LTFvGW47DUX2FT7d5IC9SkgA6
	 pp70Doa4W6E+h7Ak9TBzydqDgZjl9hLoO5loMTsA/S7txaOWqxbx86IXqTXw/Wv5oKBUQ
	 SqWoRfwKNWG3V5cqWRVXUDvNiEbufHHSzlhFQFaRp4N3kQnbJAak945vkf6zohutrAZaM
	 c1pC+57ERzle97mTkXjKIjGotClnO/F1MnT9SupkSGD1Q7QLrzPKD2HIUSCnKQZfBXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5buvAprvdrHdaLi8oOICQhFjmknbtbrXh/IGQ3CCKOM=;
	b=1k+VWd5DPNCoNZfCm9RflGH5lBFn4AwGm8rGRiwnoXvkw2fmA0J9H7VOwWUG8TNKerc6
	 t9HNMQPiD1LB/AtpXcv/GblLE4AlTnKmer5iggs0lB0nt6drFLQ9MmAyS3ojMJVR/EQG7
	 4oq9JIFLk1Wz4xWEZoh7Joydf2a8fw8rATPBQJXQU3wJhIn1v0ImBv1wE/43W8xSSOHL1
	 hhfNODB0jVEXdtzpYgk0Jrvx2vpcyRK1N4FEAhLGbykcgrFZooDJZYkQQp7smO4qTA5rV
	 w4qho5TqpKDHJZwnh4etK8BZUPNzo1njKL5+neQsRBzSijB/l9JgvEVT5BFGE2RDBFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1AraspO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9211E606A325;
	Wed, 18 Nov 2026 22:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1AraspO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B311F000C4;
	Wed, 18 Nov 2026 22:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042146;
	bh=5buvAprvdrHdaLi8oOICQhFjmknbtbrXh/IGQ3CCKOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1AraspOguA3yBlEK8Zg2eZYzbk1D/knV/cXCpl8D5cHXTkfAvXaywHHWI3dJ5HMN
	 bO36pD2Y/0JrsAq2fZzpqpOtT5QBT0gZ8haKAe8HT7HvCur4MH+I17jXlE5wVNw7RR
	 RxCdBsizIF+FWfUMWwWIKMh22w/NU03cCg2s/KA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3064/3318] timers: Clear pending_map on CPU hotplug
Date: Wed, 18 Nov 2026 16:01:26 +0100
Message-ID: <20261118150452.042164127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



