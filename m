Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765AD402BAA;
	Wed, 20 May 2026 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302576; cv=none; b=eV+Hl1sj7wZ72xjfxw+VCLexHRXIyD1Gnk58mR72en34Y6/HgxomLCUDOiJ0FDfPibUEdJfC3ypUhXTaOluxRA6p3oih4ZIF5RVc3xLC2JGYMz+DrwYSfmc74IJfr6fSLF2KZGgdMpFlvNGpHzu95rOPsZAn2urZ9PNLpKxljlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302576; c=relaxed/simple;
	bh=mwv8olfDksrydvVEaQxucHmwfbyBB8s7SpmHDtEY+oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta/jAaF9aUByHoVRenQwdGmtJ8HJDIbgM9lFjpGxcCYcqlSP98rUcWbJsk+5uJEZKBv5pLoHJS7KbPH73PJ3xz4tdpw2bRbYVHDvRXALL8gNlnM33+XwEIDitwKZzfrMTt01hmi9daXA3CI+PeY/5bX3PgAH6GTl2Bg76Owqn2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+sSH2K+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+sSH2K+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE31D1F000E9;
	Wed, 20 May 2026 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302575;
	bh=HNbX1s46WLu/gHQys4SXTJhaPOqNzq5SSPihGo7rSQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+sSH2K+JWPm0rv1sYSiOtQeWP0RTMBMUdElej7nm3/AZBWejNWNo4aZGxRqvJIwE
	 TPv6O4yHGw3KWjQqMMBk+KzQWnGsRhpO2GOLSexwX0VI8demnXoOr7QCJM2Zc/a1Su
	 Ug+4V3D8yEz5eV9hvyVNklU6NvPaqPW8ATcGFiwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 319/508] tcp: annotate data-races around (tp->write_seq - tp->snd_nxt)
Date: Wed, 20 May 2026 18:22:22 +0200
Message-ID: <20260520162105.549396249@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51e71407f4b89..a8cba4dc7df5c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3995,7 +3995,8 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
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



