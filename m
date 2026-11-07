Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062871;
	b=pWkyKXPAZ1bmZ86dsY2nEEOcqRvMMqu2eAaEuUK8r16SAaJ3iY2frydfXl8PcXvhcHAH
	 aT6Gg1OwK63ewTtg16RQ7fqbER+zwys5c+XwNDFNDYshaT79+Ij742VtK7NRRSFSYl3Gg
	 +x3Ow/F9TzR/+CFae3uffCCS3Dx5KqNZ1eU1yDYLUSnDATpH3wCSRhgtCpJh9siNNBgQ0
	 sBOvI4zeRNAbhRjRoj0RBxg8RO60kyKQ/+sjmTfj0eAUASiezTlJQc0xC3BncldpCAI2X
	 ZKY916m8dlaRAV1q3d7D3nt+QqIfOxleCj6qz2L00r78fQ5iTz9J77GpI8aXmDSWT6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eI4/bdKM/f0xNsw0jnmxHv7y/iygg9zEG+gOiMXs+bY=;
	b=b/zZe6sVjPM9wf57fu5uupE8n6FCZO+v85wLfk5OnQTMONWrxq8xFByFhEpCwDulq7z3
	 Gcc2dsdTsfsKJ4IPUhVfNI8EKkXDEe7RZCMtoYdyDYQqgB0Um6yjpGJCX7CIPGQ5XDx7h
	 owLFWMebko1O4vBmLB2RC2kWPHk6HVGhBOPB2Uu/PZvuMYDx4jSONBjZkGzjoIES50LRf
	 5Jf10CYrBqsG5SgyN8Sslj233TOhzT1UxCBc4q6qDhPGxxUcrs+xMze95yWp4Z9Twp54u
	 5DW7tp8649AnnPN5qMCxlh2/28DcPk+cydxLHBlAObK7AU+MCR/gSLmNCpwFC/KdloQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="buHQc/5r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2624606A326;
	Sat,  7 Nov 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=buHQc/5r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA531F0089F;
	Sat,  7 Nov 2026 14:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062870;
	bh=eI4/bdKM/f0xNsw0jnmxHv7y/iygg9zEG+gOiMXs+bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buHQc/5rL7zEttVJZ6RucyQeThlPcKZnGSx/rWLFRTvUHJb8CECkeOMU+caZo4cTC
	 QWVKkX+bcvzs9DuYffII0ANeYcRxDJacDuwrGR684RpaoZNcsAl6HmqQGNM+pe/KC+
	 xCTOuo+oqxRri6pGxGEb+89LBee65dGEov2XdGII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/869] md/raid5: fix NULL pointer dereference in raid5_free_percpu
Date: Sat,  7 Nov 2026 08:47:16 -0500
Message-ID: <20261107134857.540164718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index fded4b3eb88b9..6dfefbacfe3c0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7392,7 +7392,8 @@ static void raid5_free_percpu(struct r5conf *conf)
 	if (!conf->percpu)
 		return;
 
-	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
+	if (!hlist_unhashed_lockless(&conf->node))
+		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	free_percpu(conf->percpu);
 }
 
-- 
2.53.0



