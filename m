Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362501D0BA2;
	Wed,  2 Oct 2024 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879370; cv=none; b=nXIQANPnl3/jIBAWApNDYYveFd1jjjZd8tK275WgdGH7Kgz/7LaD36ZviIO1FLayIuw1Qx/F6TcmKv5iEebgO7x1sV/rOd0P3cqw3BFEZhHNccHyeed33fVTXaAnygw5DDGlOzb6yjtpHDyICpHAzTXuoYkzVgScbq5Jk0/aoiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879370; c=relaxed/simple;
	bh=prZb7ly2v13jwJC232QIlFzPBc9WOgg/4kwLSrXJlSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PH9QTI7++O/bYYyH8mu2t/Hm8D3IVN7SSPODbxaO1iQ6rh16uxyFrCE0hqukCNBKtBhU7xSt3LnNGYiUvaP0exlmsIevfEivom/CzbWzRqJoaeNYBY+Uw4hHm13pKq7vLYuRxqD81wGYOeIo4MPSfDTw6L/zsqNlOrAkeNxu6Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvZhlw/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvZhlw/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B68C4CEC2;
	Wed,  2 Oct 2024 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879370;
	bh=prZb7ly2v13jwJC232QIlFzPBc9WOgg/4kwLSrXJlSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvZhlw/a1ra93zhxPXcrv4oTAZ2Pzj6S0+sm9VFucNQYBFtUo4rbdif9Y14LW+lIU
	 ug6rq25n+Wum139KUgS3p8xYkIwgQbmXt+paeSevtSIocFH+FstXF01Woea3wG+9gl
	 aEY7AQqOsy6y7rgTjZ7lneIy4OhYxc8ECyCr+RWs=
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
Subject: [PATCH 6.6 064/538] sock_map: Add a cond_resched() in sock_hash_free()
Date: Wed,  2 Oct 2024 14:55:03 +0200
Message-ID: <20241002125754.735895899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index a37143d181f95..2afac40bb83ca 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1171,6 +1171,7 @@ static void sock_hash_free(struct bpf_map *map)
 			sock_put(elem->sk);
 			sock_hash_free_elem(htab, elem);
 		}
+		cond_resched();
 	}
 
 	/* wait for psock readers accessing its map link */
-- 
2.43.0



