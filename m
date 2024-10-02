Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3B11D0BB3;
	Wed,  2 Oct 2024 13:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877465; cv=none; b=llhjwpvj/a+Gs8gqPsVB3ALEcXx8de5y4bFnXolIaqR6+vhrNmw4VVkV7mGebBiARqqnrRvtlVEQOcWU4IzYtC9sPivWHSIp3O3lzslLUocRP/Y7uIPPlGNM8Ygoz0TUYDhzgTrsGX9+Bt+3rSDWLC2GfeT+fvCnapBu4FZ0V/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877465; c=relaxed/simple;
	bh=AnXw4tGQ/1UwWXo8/CFcOoNuYkWpqbr/iZd+iLqIPCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRn/40jhz7G9HZi8vmifG+5dZoGtzbXHYQW0h9rFxlcipKyFo+F8KjNdHqhhp0j4ZAL/aHtub5g82uJeIEFNRLoEaUCyJxBn1BYEgVn/Ri5rjN76700h0mUOufzxq/Sz+HqQ7PqhlwPanNKCYhiZYiumP/CZbtt1o9IEGUPNZeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wccnim5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wccnim5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7991C4AF16;
	Wed,  2 Oct 2024 13:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877465;
	bh=AnXw4tGQ/1UwWXo8/CFcOoNuYkWpqbr/iZd+iLqIPCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wccnim5SmNSHJEHUOiyRi1BmgDi/0EEtPVstApFkNawky3su2XWbvOS1Eo2HwqyO6
	 KA94NDgeK1ojT6QyXO290uKsSYbcfs0P3DvEHDUY3JI0GS/UI/+g5ci0VVGLNGrkN2
	 c/fj4DC8TiHEkMWZAhJD+rLbAkxKKvCNZQJEqFqI=
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
Subject: [PATCH 6.10 087/634] sock_map: Add a cond_resched() in sock_hash_free()
Date: Wed,  2 Oct 2024 14:53:07 +0200
Message-ID: <20241002125814.545399256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



