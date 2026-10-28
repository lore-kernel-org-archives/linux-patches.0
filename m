Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216742;
	b=TsUnDkQDXEoD27V6pvZDVOVSGzpYjyvtK+HgYcpIr1ceNKEbUt+wmJczlUV/4/+/yLIT
	 n+hE/o0F4ZSAjspdv5ZbHPqX0xezn8JtIg7XU5ne5k8s2TQ82dt0q1Kf5h6b0u/H7av3j
	 L81sctp7q8ZunUolhszNOwvOcqAgfGxoMCBQHVhsphH4TSoJibpwBOloBrwa7bib4lLWA
	 Ma0/gQlBp2XeudMH5t/f6cZfxcP05Kl2az59yn/q6zYJviSy7bfJGmkJMl193HiXvG1+w
	 UgJy/x5aBl0OeIGcQwiekCf2DV8TW6zoadMNm9DVs8iKG1HDubQ6HaXABBPS1BkOzfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sctXtH8HEgEVd5hDAU61FM3VhxGdX0tjsBqxT30use8=;
	b=K6GirdTAs8XzkMnY3DYrIufVvuVZ8WREdlFI8+NRw5e4m1ryqzCX3WvZFj9xvVd1ORNe
	 ZE30wKBSm9dP+bJbMPqdjuoFf44Y2m8cj/eO91TIZ19F8jvQS0SkASy0i5x4YJZcf8CPR
	 7TXXwivWe5VKj7WRBuxdoS7t+di8sM8ws06R1RsED74FSIHk6nhP17B/aDCK609cx6eGg
	 aFqwm0YmxQ9CFgSlVmZH6dVOS5cNcvdhEs6bCuzbMiiGZgnriPT0PMycpk7ux6CTfMK5v
	 Zplb+wY264T4VgmarvrviVuOx2rtMNGzeimSRfRUYMWjmlVCC0SUxhKKm9yj/15Eu1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6LwMr12;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954AA606A31E;
	Wed, 28 Oct 2026 19:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6LwMr12
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69D41F01828;
	Wed, 28 Oct 2026 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216742;
	bh=sctXtH8HEgEVd5hDAU61FM3VhxGdX0tjsBqxT30use8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6LwMr127k5DdlTy+m8PeO36a3beuaA/XOcsbGNbqUVFqE8DwlNt0bU/obDdrGeVZ
	 TKskV4O4esp4Sw9kVy+9pxIUAu2KJCGfV/Y36dsEVHCAuerRudDTuzrMRiMuXf0WLj
	 hYjIvHpp8IjGoYxsUMkc6LKl8klp0Gl7lN9BXGXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jia Jie <jiajie.lee@starlabs.sg>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1663/1887] perf: Fix addr_filter_ranges lifetime
Date: Wed, 28 Oct 2026 18:02:39 +0100
Message-ID: <20261028170537.303280575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e62d4192e593630f355094adc467058a05bdc935 ]

Lee Jia Jie reported that since event::addr_filter_ranges is used
under RCU, it should be RCU freed.

Reported-by: Lee Jia Jie <jiajie.lee@starlabs.sg>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 972686eec8125..95dcc8e6907e2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4802,6 +4802,7 @@ static void free_event_rcu(struct rcu_head *head)
 	if (event->ns)
 		put_pid_ns(event->ns);
 	perf_event_free_filter(event);
+	kfree(event->addr_filter_ranges);
 	kmem_cache_free(perf_event_cache, event);
 }
 
@@ -5048,7 +5049,6 @@ static void _free_event(struct perf_event *event)
 
 	perf_event_free_bpf_prog(event);
 	perf_addr_filters_splice(event, NULL);
-	kfree(event->addr_filter_ranges);
 
 	if (event->destroy)
 		event->destroy(event);
@@ -12058,8 +12058,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			put_callchain_buffers();
 	}
 err_addr_filters:
-	kfree(event->addr_filter_ranges);
-
 err_per_task:
 	exclusive_event_destroy(event);
 
-- 
2.53.0



