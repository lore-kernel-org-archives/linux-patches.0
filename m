Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F81C07C4;
	Tue, 15 Oct 2024 12:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997058; cv=none; b=aiMHK9F0y7FhDfvGAcu282KCtMTdlNX9h0blX22pEfxfl5zLoJotwEDQUhyAb5TlA7Qkktwm5LMNF+R7OHbaW8BY7ckxrWfzbzDu0+Ub+JyFsTG5si2yTKKozrysgNYzqwKKFZ70UNGfGMWiXb3UiVNWyLNjQtBUsAuRRiELBlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997058; c=relaxed/simple;
	bh=8Q+pevY3htlmekcjYyhItPJcCx1Uuzoo7AEU1qmpq1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNqgguolw9MG9iKXPh7nAJqkBn8jLHl2U0KMJRFvQDzGCjA9T99yfSO9VaUXx4gS75zH0uEqD2C37dyufdM1vOWSAk3SOpO2A0vtlbXfPxZvl2QrL2isxYx3Lpo0pqEDvSLbUXT+FZJstuB2qDDrt0rfWiKST8YNK1WIxEdsH5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsEiULk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsEiULk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F039C4CEC6;
	Tue, 15 Oct 2024 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997058;
	bh=8Q+pevY3htlmekcjYyhItPJcCx1Uuzoo7AEU1qmpq1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsEiULk8vHFXuQK8ApQ/AZB8dt5NN38V4HXUJCEPcHUKD0m6sZMZmKL+ZSrhHwnWe
	 3cq/zvEAP0PpTsVsQxzyjwD0pe9w8oHnkYm/4BOl/7IZIT8nc7DokZWOiJQWr5RuSk
	 4dCkcZMhoecpKYsDSxgslkJQmT7oJQM+k7ntHb6o=
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
Subject: [PATCH 5.10 076/518] sock_map: Add a cond_resched() in sock_hash_free()
Date: Tue, 15 Oct 2024 14:39:40 +0200
Message-ID: <20241015123919.934333397@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d1d0ee2dbfaad..73c081fb4220f 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1219,6 +1219,7 @@ static void sock_hash_free(struct bpf_map *map)
 			sock_put(elem->sk);
 			sock_hash_free_elem(htab, elem);
 		}
+		cond_resched();
 	}
 
 	/* wait for psock readers accessing its map link */
-- 
2.43.0



