Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AF91DFE1E;
	Wed,  6 Nov 2024 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897874; cv=none; b=irCRw2Znqd875PVrGch+3TqWqtQbTRXcsQrx/5kzFBitAfW68VvZd3F4943TqPgIejtsg8WATDFVDJU76310V8uI+Z6K7gRDVzO8cHspdoUEMeivpuGUkrHdnlcU6uXd5mjx991VARFxUYY9QgLFn3JMTXzlWIBi0EzHErg2eX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897874; c=relaxed/simple;
	bh=EpD5Q3p95h1DNVnAEbul+YjY4k9Ec6ZpuLwVqWo8WY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jS6636Cb8uiXOi+QSBJT3YrCvCMkxrTJ1ZI7VsOvdSube9K9I4K6tAEE3FTO+KYQTQTRr2ig3NTk1Vk07WbBTdaNNswUXH9+h8jAaVNEa8G2U+lgS7Qkq2oHbWOB99fvEOFI90dvfsbfJqHHQeN3kfCMu7UR4CYAwjADuE5KpJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjwipn8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjwipn8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AC9C4CECD;
	Wed,  6 Nov 2024 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897874;
	bh=EpD5Q3p95h1DNVnAEbul+YjY4k9Ec6ZpuLwVqWo8WY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjwipn8JXK81dZqR4ZMZ7+Xk9QzKb1jg0C+4SsRSdxPnb5Ijnqrf4S/NbcXrDBvNX
	 a3oUslVJRe6RFNkw/FiekEAbCWj0LsGePBkGPCb6iHbQYe1LWaYa7txkvZnsXj1uL2
	 C8i55pjv8djhkaTNXcckXt1n+V7WUbrYP9buuKGw=
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
Subject: [PATCH 5.4 048/462] sock_map: Add a cond_resched() in sock_hash_free()
Date: Wed,  6 Nov 2024 12:59:01 +0100
Message-ID: <20241106120332.705358241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f9e9212ff7e5b..42d521443b338 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -945,6 +945,7 @@ static void sock_hash_free(struct bpf_map *map)
 			sock_put(elem->sk);
 			sock_hash_free_elem(htab, elem);
 		}
+		cond_resched();
 	}
 
 	/* wait for psock readers accessing its map link */
-- 
2.43.0



