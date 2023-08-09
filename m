Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E65816428
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F9CC433C9;
	Wed,  9 Aug 2023 10:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578727;
	bh=hAq4wA3iZaQs7gsL0TDsyBa62aiRfwkbC1AqTmSZTW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjH37FVw/qKR4EcVzRDSwrNlV4zrhZSJuDDRoR+qxIFNNqTO0e6nMmrorTGfseNQz
	 SjvTBqFVJWVi6TVmbJxp7gtVj+wgE+4glgIHj7FHDqxlNWKFWKP/DDP1nZ/p2XEaVr
	 4FDx8DCut5uv0FFaCrPQjeWL/0pegc28aS11mNBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/92] bpf: sockmap: Remove preempt_disable in sock_map_sk_acquire
Date: Wed,  9 Aug 2023 12:41:12 +0200
Message-ID: <20230809103634.864526648@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 13d2618b48f15966d1adfe1ff6a1985f5eef40ba ]

Disabling preemption in sock_map_sk_acquire conflicts with GFP_ATOMIC
allocation later in sk_psock_init_link on PREEMPT_RT kernels, since
GFP_ATOMIC might sleep on RT (see bpf: Make BPF and PREEMPT_RT co-exist
patchset notes for details).

This causes calling bpf_map_update_elem on BPF_MAP_TYPE_SOCKMAP maps to
BUG (sleeping function called from invalid context) on RT kernels.

preempt_disable was introduced together with lock_sk and rcu_read_lock
in commit 99ba2b5aba24e ("bpf: sockhash, disallow bpf_tcp_close and update
in parallel"), probably to match disabled migration of BPF programs, and
is no longer necessary.

Remove preempt_disable to fix BUG in sock_map_update_common on RT.

Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/all/20200224140131.461979697@linutronix.de/
Fixes: 99ba2b5aba24 ("bpf: sockhash, disallow bpf_tcp_close and update in parallel")
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20230728064411.305576-1-tglozar@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 86b4e8909ad1e..85d3c62bdfa6a 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -117,7 +117,6 @@ static void sock_map_sk_acquire(struct sock *sk)
 	__acquires(&sk->sk_lock.slock)
 {
 	lock_sock(sk);
-	preempt_disable();
 	rcu_read_lock();
 }
 
@@ -125,7 +124,6 @@ static void sock_map_sk_release(struct sock *sk)
 	__releases(&sk->sk_lock.slock)
 {
 	rcu_read_unlock();
-	preempt_enable();
 	release_sock(sk);
 }
 
-- 
2.40.1



