Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF122DC783;
	Mon, 17 Aug 2026 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977898; cv=none; b=nmEvep/zjpUYfQgNRKRLYi5eIFLGhGM3wZSXN3x6C9Vfj31Tn32TMsE4FyFmIo1xas9tqYvoiRdySbv4v3LNVxyqYkwkxpB9Rhr4poWhA1WO3fCj7W0JPUAHEoU+KSVK5jRe5XRf7yoyxiT4gi4yecTFeL7doOYDeUxEYD9Q7t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977898; c=relaxed/simple;
	bh=4ZKA/ez7QqVslW7Nljedd0QHzPXJdvN+/f0f+8yGujs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwaZLWNkRI3rZ1ckzjrDqKUtV5z65b74qH4+2gzijXLzITN/ZIoiHLn7jhyOtpgI9sTi5gK0mclzSDdxgkF9tOGFCtY9Vta9487cXUohraHIv4DE5xpAc4eZ3q1nGUr5YQqLkrksK8hX87Ot1NzCOIFmcOuaFMfhgA2OO084o8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14aHsvrg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14aHsvrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233821F000E9;
	Mon, 17 Aug 2026 14:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977896;
	bh=FcYPCDelOdnDHsj/z1OBOCvX7WvARZApQnTnOseqH0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14aHsvrgGdeom2yCnUmhh5of63Y5Z5Vg6NkKZfGweXZnFenFgFR3WTizJL4ISscq0
	 gIBcbU5ydokyYLr3v8QeosnMql5hCuEtNeY9eU1gmzmJEhR/y2SvBNkZr0kclQ1q67
	 sIls/KGy7hrZjqhpGoGYCwhU45rV7w4QBgCsoOnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rife <jordan@jrife.io>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/181] bpf: tcp: Make mem flags configurable through bpf_iter_tcp_realloc_batch
Date: Mon, 17 Aug 2026 15:32:04 +0200
Message-ID: <20260817132536.560895793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a9f3ee89302ce..cffa0fc1ae6e1 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3032,12 +3032,12 @@ static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
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
 
@@ -3149,7 +3149,8 @@ static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 		return sk;
 	}
 
-	if (!resized && !bpf_iter_tcp_realloc_batch(iter, expected * 3 / 2)) {
+	if (!resized && !bpf_iter_tcp_realloc_batch(iter, expected * 3 / 2,
+						    GFP_USER)) {
 		resized = true;
 		goto again;
 	}
@@ -3578,7 +3579,7 @@ static int bpf_iter_init_tcp(void *priv_data, struct bpf_iter_aux_info *aux)
 	if (err)
 		return err;
 
-	err = bpf_iter_tcp_realloc_batch(iter, INIT_BATCH_SZ);
+	err = bpf_iter_tcp_realloc_batch(iter, INIT_BATCH_SZ, GFP_USER);
 	if (err) {
 		bpf_iter_fini_seq_net(priv_data);
 		return err;
-- 
2.53.0



