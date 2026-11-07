Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062010;
	b=Y4SeRdEXWdDk0ntLOY161VgnI+UAsYsuZiYAiqI8Cs2mrRkVh/s24qj7EKCcW5D2u/SE
	 jWXdHTsoeUNYfakkr27UWpWxB6EOrV1qQIbyjq3smU1CAE42TgBZf2mG044CsM4mnRs4N
	 bqDZ81eHuglwqjsJcdWo3k3hmsgf6cAhOli48V7GP6rsuo3lo4UdAPrHPrPh+GxmIi8cn
	 /TlIRydiAdOdDH6eHfkqNHmiVtDHsURX+6vUt1rK8MIVQpUy3/eVS/hgIzr9Z32fUQppx
	 q4VMvbMxjOBY7/mMhoeq2vTUmh41HkKH5AvZFpblwIyr1xfCstiO19xSvloMoc5NCWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zaiLpfS8rtL2vpAoaBw2ScYC9xHzaL2eGuT10CA/3mo=;
	b=26HxEhvwfRBI3Ot2ReTn3YZOOasDvZCExBZEkg1LsCvPlvFo3v7xZMusmBTxBHM09DDi
	 p/JDETJQanzsT2Z+boU5J9+KeMh1BFfbsDvlE+z6hd6+zX4KS8ja+MbcMcupLYsLMy1Wq
	 TbE+QcGxuJOBENlciQFc197Y/6JmjLspfWQHBGSMU3iI0P1XNhtQKABPzOnkI12kMH3HZ
	 869OSxklgAPmhm6PiLCtmLa5vGn2h7FW/BcGHnOA1bIj5ku/IUEir+lmd+Pf+jKx48RiX
	 9Ajap5qa0VRMqXx7PyiK8T2c4DY5ldTTUf3jjtiW+UtrghF6YVG52bg1nmnG6zcYhXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=otFl6PI6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4018606A332;
	Sat,  7 Nov 2026 14:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=otFl6PI6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF431F008A1;
	Sat,  7 Nov 2026 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062010;
	bh=zaiLpfS8rtL2vpAoaBw2ScYC9xHzaL2eGuT10CA/3mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otFl6PI6CBdZGBZ31b+ZrGKU/lUw7+ZqJCRS0Wvim0Qzqs2x5SEse652FOArZ8Q3n
	 TSbcwH0pzsEnCZdkjwq+abuSClbKniIPJSikbpoduzw0XfvfwxuTuUC67CJyKP7YxF
	 ffTjhj/8yj6g/EyorzYsdVlRsCUJ0VBoRJS0Jqes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1000/1536] md/raid5: fix NULL pointer dereference in raid5_free_percpu
Date: Sat,  7 Nov 2026 08:50:16 -0500
Message-ID: <20261107135025.754879958@linuxfoundation.org>
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

From: Cao Guanghui <caoguanghui@kylinos.cn>

[ Upstream commit 41742e35268d6a45161b187f51f42bc2ade14d0d ]

If cpuhp_state_add_instance() fails in raid5_alloc_percpu() (e.g., the
startup callback raid456_cpu_up_prepare fails due to an allocation
failure), conf->node is never added to the cpuhp instance list and
its pprev remains NULL (from kzalloc initialization).

When setup_conf() then jumps to abort, free_conf() calls
raid5_free_percpu(), which checks conf->percpu (non-NULL, since it was
allocated before the cpuhp failure) and proceeds to call
cpuhp_state_remove_instance().  This calls hlist_del() on the unhashed
node, which dereferences node->pprev (NULL), causing a kernel panic.

Guard the removal with hlist_unhashed_lockless() so that the cpuhp
instance is only removed if it was actually added.  The lockless variant
uses READ_ONCE() for the pprev read, which is safe here because the
actual removal is synchronized by cpuhp_state_mutex inside
cpuhp_state_remove_instance().

Fixes: 29c6d1bbd7a2 ("md/raid5: Convert to hotplug state machine")
Cc: stable@vger.kernel.org
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
Link: https://patch.msgid.link/20260827080341.112296-2-ghuicao@163.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a92d98a3c91b0..605e89f95c36c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7397,7 +7397,8 @@ static void raid5_free_percpu(struct r5conf *conf)
 	if (!conf->percpu)
 		return;
 
-	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
+	if (!hlist_unhashed_lockless(&conf->node))
+		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	free_percpu(conf->percpu);
 }
 
-- 
2.53.0



