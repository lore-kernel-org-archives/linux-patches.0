Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228881BFE04;
	Tue, 27 Aug 2024 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770386; cv=none; b=aErO/dH58qZtkPDK/rRlg+HjGKVE5U2cI7NGfamBh9AkcsY17qIhRn8tnneMVIUVTLCYZKoEHr7u3TgbpkoQen2785YaQd0mBF6pmrgxNcyDrkFBA1XEQqivOu9+0jDI8audCwdwqzDskX5kZi2HiECNSYDvYNtWEtgaz8Wagfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770386; c=relaxed/simple;
	bh=kH15TltWF3ajfbv0MYSmbP1ggIbdykhLttbliXl9SxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBhcLVGED9abpxUdx12m+ttQVRxXOYSvNW6bR8fLAfGnOIDy1smPxGTjKLNsSUeHgUugJGP85e7dj6I2Br3O0M2+KlXly52wpc1h+Zme4DRNSuE9H7G2zYx9f8aiAh0WVxaIPb7XT5Z47Q2nEzChgz3VqtLjHuYnAAtE3Ullt9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjTTUOT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjTTUOT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93882C6104B;
	Tue, 27 Aug 2024 14:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770386;
	bh=kH15TltWF3ajfbv0MYSmbP1ggIbdykhLttbliXl9SxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjTTUOT/sOgaMzrndepz1OARYLd+fbtyD6RprFzcWyrXysrCrNM7ihNlnuTrxu190
	 6rkSvwMdxU0Ksd/DQG7CqWzR2HZEak1+U+2WT7gljCsdUn6ObDav0brUZ3ZV3SLl2i
	 R3WEoelhVgj466L0dpjCngJFjEoAYMhGoGasQfOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/341] Revert "bpf, sockmap: Prevent lock inversion deadlock in map delete elem"
Date: Tue, 27 Aug 2024 16:37:24 +0200
Message-ID: <20240827143851.515606288@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 3b9ce0491a43e9af7f108b2f1bced7cd35931660 ]

This reverts commit ff91059932401894e6c86341915615c5eb0eca48.

This check is no longer needed. BPF programs attached to tracepoints are
now rejected by the verifier when they attempt to delete from a
sockmap/sockhash maps.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20240527-sockmap-verify-deletes-v1-2-944b372f2101@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 01be07b485fad..a37143d181f95 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -411,9 +411,6 @@ static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
 	struct sock *sk;
 	int err = 0;
 
-	if (irqs_disabled())
-		return -EOPNOTSUPP; /* locks here are hardirq-unsafe */
-
 	spin_lock_bh(&stab->lock);
 	sk = *psk;
 	if (!sk_test || sk_test == sk)
@@ -936,9 +933,6 @@ static long sock_hash_delete_elem(struct bpf_map *map, void *key)
 	struct bpf_shtab_elem *elem;
 	int ret = -ENOENT;
 
-	if (irqs_disabled())
-		return -EOPNOTSUPP; /* locks here are hardirq-unsafe */
-
 	hash = sock_hash_bucket_hash(key, key_size);
 	bucket = sock_hash_select_bucket(htab, hash);
 
-- 
2.43.0



