Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B473D5C07;
	Mon, 17 Aug 2026 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980235; cv=none; b=H/BsU1znCN+W3wUHCVHJ8rTrwbgZviAeIm9WxAOm1sTfVq0ON0G8JKZH73+E/DVnWOGZF/j5RgFEonKX3xEK70CzQ0EqdFYGnJCyzKA6Gi2ZBMx1vHohv2tlDWi8r6yaeE2VNo7aGDvsrU2ZLeiZEhMfeesdCeimnqQORM5jLAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980235; c=relaxed/simple;
	bh=1s8kYdx9EeIcTNukeJzJc62itDs2dcIZYPwVyZAkGRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5zAMNDVNoj1HMRlHN5YGFHeYRUwwXVJjbvf0lGjV4ZIokZSPSTvb4TPE5G6CuVT+gy+KhpdgLZGymaytQJZeqNJmEbi0F6pzCuxbqudzQMflJaGu4C3KKJwYPy2j2mkisb+p/jnZALYGR1M8a5SD7Suj9XtomMaQ/616kYyES0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEe3BcA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEe3BcA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913AC1F000E9;
	Mon, 17 Aug 2026 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980234;
	bh=ll8gyrC+JRZfXa5RNUlcprQHk33AqnyLBY+j+rgQ/cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEe3BcA0MNCzYdxaz7DYkS+H8gNh2CyW3RcuUyKTwe4IusWUlqygGW/gOTLW/SW7x
	 vHQmgtaItcT7+XSwdtqrqmGWsdsaHsEwOd9Fz8ian3mNf5IT84bmQw0wD3UIdrNhqd
	 Mj8pQwDyuIFWXXKSa3RXd86IftQ6Q1u0R4OhMWuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rife <jordan@jrife.io>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 503/609] bpf: tcp: Make mem flags configurable through bpf_iter_tcp_realloc_batch
Date: Mon, 17 Aug 2026 15:33:19 +0200
Message-ID: <20260817132600.710862488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan Rife <jordan@jrife.io>

[ Upstream commit 8271bec9fc1cfe522b1a18cacbefd6712a3d41c2 ]

Prepare for the next patch which needs to be able to choose either
GFP_USER or GFP_NOWAIT for calls to bpf_iter_tcp_realloc_batch.

Signed-off-by: Jordan Rife <jordan@jrife.io>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Stable-dep-of: e5fd3f514e27 ("bpf: tcp: Fix use-after-free in bpf_iter_tcp_established_batch()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 89200b4314018..7823e55bc9e73 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2759,12 +2759,12 @@ static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
 }
 
 static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
-				      unsigned int new_batch_sz)
+				      unsigned int new_batch_sz, gfp_t flags)
 {
 	struct sock **new_batch;
 
 	new_batch = kvmalloc(sizeof(*new_batch) * new_batch_sz,
-			     GFP_USER | __GFP_NOWARN);
+			     flags | __GFP_NOWARN);
 	if (!new_batch)
 		return -ENOMEM;
 
@@ -2876,7 +2876,8 @@ static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 		return sk;
 	}
 
-	if (!resized && !bpf_iter_tcp_realloc_batch(iter, expected * 3 / 2)) {
+	if (!resized && !bpf_iter_tcp_realloc_batch(iter, expected * 3 / 2,
+						    GFP_USER)) {
 		resized = true;
 		goto again;
 	}
@@ -3293,7 +3294,7 @@ static int bpf_iter_init_tcp(void *priv_data, struct bpf_iter_aux_info *aux)
 	if (err)
 		return err;
 
-	err = bpf_iter_tcp_realloc_batch(iter, INIT_BATCH_SZ);
+	err = bpf_iter_tcp_realloc_batch(iter, INIT_BATCH_SZ, GFP_USER);
 	if (err) {
 		bpf_iter_fini_seq_net(priv_data);
 		return err;
-- 
2.53.0



