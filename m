Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABDC1EBFED;
	Tue, 15 Oct 2024 11:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992454; cv=none; b=g6idaopvNWnE6wYkWLGTB6KzH2WsxwBHptfeel2yCuw5rTVKtkydlPyizX5A5iBZGN687emPvtyHse00pgI29dci10wVmSde8+VjRc76ViENxr9aB8oHPjifyRatgRoxD3FNAaj8iQSCamph7ml9BwcuYLVbWmfg3TwEicgL1hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992454; c=relaxed/simple;
	bh=aVfac0RqHmfVMZJpegMbGEW7FKKprgDw/AnGlfaECb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCAkzIPSTCmDIPW6AssbTz6x9yQqEFKNv/BAeqVQWj/UKWkI+dZAojL5WyFwWMMeO6Wk87bDjImF+yldiknPhFE6PRS7YZ5fYTqBqPBM/VN07v6CVGqeg8yZTC7Yc66RkhSiJfGYd2DonTWD9npqjUhm/kf1a7crGy1/LbYrezs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSVf79+a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSVf79+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7763AC4CECE;
	Tue, 15 Oct 2024 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992453;
	bh=aVfac0RqHmfVMZJpegMbGEW7FKKprgDw/AnGlfaECb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSVf79+amVvp2pGZzkto1Fk9aJYRr+Th09utDvrdyba3F5kR3McyMwrgrVBitYiYH
	 JR9+HRx5g5hpfWf4C70lbIvJVXkzMTQ+xjDQfvPsuNN4VBELxgHg6lWttkez0KKaSH
	 NNNvPbi+jT1xBcUh7inp/W8daZDguzAjueNI8Hvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/691] sock_map: Add a cond_resched() in sock_hash_free()
Date: Tue, 15 Oct 2024 13:21:10 +0200
Message-ID: <20241015112445.199191676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b1339be951ad31947ae19bc25cb08769bf255100 ]

Several syzbot soft lockup reports all have in common sock_hash_free()

If a map with a large number of buckets is destroyed, we need to yield
the cpu when needed.

Fixes: 75e68e5bf2c7 ("bpf, sockhash: Synchronize delete from bucket list on map free")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20240906154449.3742932-1-edumazet@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 0f9648c6bcf76..9ef58dd1139d3 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1177,6 +1177,7 @@ static void sock_hash_free(struct bpf_map *map)
 			sock_put(elem->sk);
 			sock_hash_free_elem(htab, elem);
 		}
+		cond_resched();
 	}
 
 	/* wait for psock readers accessing its map link */
-- 
2.43.0



