Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F5E36405A;
	Wed, 20 May 2026 17:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299052; cv=none; b=ZU99D4Qg92MtINZN9pneYmCpk0KzhaiUH2IygMA3M7w7qVFGKZLfeNpFJbPQo+m/5NzGqVp/5zthm3jetAi6HMb+vY6JqYP/JyLU3XJWomUkoB08Vr7UikrG+enbmGitRfZHZ6ksFd2YRITKJBrklGw20GZ1QYhhEl1rLRLira0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299052; c=relaxed/simple;
	bh=UoTj+jyDGXFx/Co02jM9q6njvdB2twx/vLsSGWJDhb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni8ETz6miBfb7vKkBn5S8cuszgqke5WV9AcNavPCtkTuGhk41gY+7vM7WBIy8WGz57X8Of347F2SQALcl3u1X4GFqAzR7LuTLu761qsmocqi33bjeRpzlIGuKhI/LwJoayhyyJpaqe/8vmyxNeIUvvCOQ9WgGVnabkcxFMNT+Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuCfHJ7t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuCfHJ7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65A51F000E9;
	Wed, 20 May 2026 17:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299051;
	bh=fI8UZCVUorgAIOIK5xGSsWjfYaePxLxmO9hQDMIk1LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuCfHJ7tNHYiOpLvjywv8jIc9Sht+0/BlvwUINmO+zKsWjffZeZgllgWTrxBTzxp/
	 CCgV4ZDCdFnbLUNkVUGpOuSjVVVB+QTjgPR1VIMTbGSIwcutJBipGmbw8kzcqQJl/n
	 GS8ZIhK1MY0rfsNdqM48gDGOeBPzXIVEicQqciHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 644/957] tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)
Date: Wed, 20 May 2026 18:18:47 +0200
Message-ID: <20260520162148.494118149@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 888fe31e42f0b..fe91675ae5678 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4447,7 +4447,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH,
 		    READ_ONCE(tp->timeout_rehash));
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
-		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
+		    max_t(int, 0,
+			  READ_ONCE(tp->write_seq) - READ_ONCE(tp->snd_nxt)));
 	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
 			  TCP_NLA_PAD);
 	if (ack_skb)
-- 
2.53.0



