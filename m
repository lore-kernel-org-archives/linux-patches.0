Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F541CF28B;
	Wed,  2 Oct 2024 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875441; cv=none; b=LyiFcpQiwjFMbjyxapwgTsnfvkaXlyqd6dbP675QD7+cMw87zUiIpaYLhnrHzs6ZDswqWEfKwPf9npTt/ZsQUzaeo89CE8NOVpzNSR7w14J5qaUGJPjRi7mGTPentmtJ6n+dPBdd4NGfkMlZGqD82KqKpREO7pLNMLVWf5fUURY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875441; c=relaxed/simple;
	bh=Nz7GqlHT4cm8X2SEU0ArYrL4mtyACZSQMfXycYe0HFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFQLJvuD3RQnQf7llX+ugR0Ne67tCbBifzyn0vKodNAMgnYX0QNVtBdLxXlHuxDXzEu+sTrsMhuCnvNfNZ4qaJO8+qjNRXoAi9YHrT+au7zdsfRQQVa4XxniOeVKwpywZ3mue2H/KevU9mer3sRoFmQqdVNaza7blGs/OBAZMQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbmIDOFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbmIDOFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40EAC4CEC5;
	Wed,  2 Oct 2024 13:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875441;
	bh=Nz7GqlHT4cm8X2SEU0ArYrL4mtyACZSQMfXycYe0HFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbmIDOFwHYqEoZO8lhEGDosTdvfvBy5KZvkZ141r8gExWK4TVFwM1/NUp3MzQgVUk
	 inQ8UfeuB1bAHEQqmNvROvlTY5CfHjPKS3OQ2QF1LHR7gePIaQZQB6DKtgrRjarbJE
	 o/PYzSY65offLX1yagHkgAIXUvzHPCgvDpM3ei5M=
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
Subject: [PATCH 6.11 102/695] sock_map: Add a cond_resched() in sock_hash_free()
Date: Wed,  2 Oct 2024 14:51:40 +0200
Message-ID: <20241002125826.546830977@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d3dbb92153f2f..724b6856fcc3e 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1183,6 +1183,7 @@ static void sock_hash_free(struct bpf_map *map)
 			sock_put(elem->sk);
 			sock_hash_free_elem(htab, elem);
 		}
+		cond_resched();
 	}
 
 	/* wait for psock readers accessing its map link */
-- 
2.43.0



