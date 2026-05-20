Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1698348C55;
	Wed, 20 May 2026 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301174; cv=none; b=ikjp2RBFHX9opJ+DAt/QRWts76ZLwwwc/wYTwYeyCtUc9VmP3cpJEBbkbmyJMr/a77q+k+8SO/hbddGm3xpvn3+eCOFH1644/2XxxKDNiUfthHOGuYi4Khh5/R8BLdhVqYvlzIEl/qSB38FWRgyQSGD2mtSYX5vXiza3cZyw2/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301174; c=relaxed/simple;
	bh=iz2YoB1QaLo4tBhvfVUnaTKOXDyAmeD3U7XQAMdCkSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhUTaQa0rz7wjSz5ZFdRnDcVdehttlUuUUTdwXw+nPrWrO6WIMEq6fkau4UEpOaViHQCC/F7CLJHEfay+0fd6/v5wU/qUiREfvl4wAuk7CySSQ7+O1wsMKVWpWRVAooH4MYnwEiPE7e8o4N1Pf6a9aKVG4uTwA2/sooW3J9odpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKzDHIed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKzDHIed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624381F000E9;
	Wed, 20 May 2026 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301172;
	bh=rDUfwvojpac62Gp2YEunSK/bEbf8GwuKO1wuz8KkKLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKzDHIeducV8tpqVTYZ7q0BIkeYKIPRtitxu2RGb+7Hh+iomN8OzzytGGOjBOAM0k
	 eHQqxw8BMdP8a7KIGGq8+ppRydT4RfKW7yAamtX/sk/N/VPKWHyI1hD3GMooDLfNGI
	 VqfaQR2AXaxzCj5GXh8ESRrJ62uNqtDyUwrTgHXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 454/666] tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)
Date: Wed, 20 May 2026 18:21:05 +0200
Message-ID: <20260520162121.111235640@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3a63b3d160560ef51e43fb4c880a5cde8078053c ]

tcp_get_timestamping_opt_stats() intentionally runs lockless, we must
add READ_ONCE() annotations to keep KCSAN happy.

WRITE_ONCE() annotations are already present.

Fixes: e08ab0b377a1 ("tcp: add bytes not sent to SCM_TIMESTAMPING_OPT_STATS")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260416200319.3608680-14-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cacb298147d4b..45e093ca22533 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4311,7 +4311,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u32(stats, TCP_NLA_SRTT, tp->srtt_us >> 3);
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
-		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
+		    max_t(int, 0,
+			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_nxt)));
 	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
 			  TCP_NLA_PAD);
 	if (ack_skb)
-- 
2.53.0



