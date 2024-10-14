Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A6F1AC891;
	Mon, 14 Oct 2024 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917490; cv=none; b=ltfIw+nwZ9Qm+DwP66unDqYqruH7g2BniRDZxyn7cpswI3K3mzBeNIJpvuvnxrwwRTp5ChvQQ3NnWlcSpirWP7l4lZwZyAp78Jxgx0Stq/JRu/iRAvOZExrfu859n/QXtVjgUoQEwa2oBBLkUugpb/R7TwkkxQFjyJP17Wvu1yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917490; c=relaxed/simple;
	bh=mCI779XvRBKki9T0V0fNweZyULi6auRxhbCnHJqkktc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIQV7s7kGOAJbZa4VI6zOmi5m6uLBKXDYbIx/zpcYWcwdr6CXaTHRtF7EfNps6dWwYdN0+7XbRJ20OjMV7x8juTPiHYQA8/aQOoVWzU4KLm/c0zAptCQnwIMX+KkveDXfgfQzv5/jMJLoDHX+FBrtdqddmbuxXW5QOYogeE4V9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMeN4/kM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMeN4/kM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144A1C4CECF;
	Mon, 14 Oct 2024 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917490;
	bh=mCI779XvRBKki9T0V0fNweZyULi6auRxhbCnHJqkktc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMeN4/kMdZQoPMGhhv9ZDlxBLwd1CuVxmWucs0W08QmcSHeNUGhiyXTbBrBAbaaia
	 GHELJcRG9eFYtkx+JZXkUsDpz6afQftPoZTcgEl2K4L3S9WA1ovHLlFWF9oDSd3qGu
	 OStAoYOmcKTSafqRCZeORH+jGfpO0mEzbjHwmRU4=
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
Subject: [PATCH 6.1 049/798] sock_map: Add a cond_resched() in sock_hash_free()
Date: Mon, 14 Oct 2024 16:10:03 +0200
Message-ID: <20241014141219.869931861@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c1fb071eed9b1..25b5abab60ed0 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1172,6 +1172,7 @@ static void sock_hash_free(struct bpf_map *map)
 			sock_put(elem->sk);
 			sock_hash_free_elem(htab, elem);
 		}
+		cond_resched();
 	}
 
 	/* wait for psock readers accessing its map link */
-- 
2.43.0



