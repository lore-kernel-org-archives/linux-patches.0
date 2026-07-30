Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD98413D8F;
	Thu, 30 Jul 2026 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422073; cv=none; b=ee54kIJkBUzZqDRtFgRGGAYu4uAgYUHmBlLAqpZxYzGDNPuHwOiaKapcuknaJ3UYEqPsEhG2nk3OkoUhpDG17RI1rKPQaOGzq9ZRkRbN+DtyTVG2T445WbRfirWNe39xyIgS8RIXCR83jMQmjFktsvRaVnO4R9+hqhfTYJgCCoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422073; c=relaxed/simple;
	bh=JVThtQQtmMV99KmSfwWLB0n7ARZEufL5itIT5ksxs8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiIoEEhxQlMhQlh1zHwnBw5FcSUPAcjCvyP78SiaNX/pfWp3+SYYetiJ75hucY7ip9njdMAyKX/CoadQpIVuubzLbssFb2rFb9FRbwx/jxPXeu2hLw2gBRNhjJFJRa1dBKU9fAtdNkC4NFZnlaajYcTk466MUWrLtmIBppFX2jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aypgm8yx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aypgm8yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3685B1F000E9;
	Thu, 30 Jul 2026 14:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422071;
	bh=I8G7w969NHrfkuvIdmEa6n6nCad8j87q13wvPWDY21E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aypgm8yxXMx4t2kFgKfoWkUAG1wKQm4GfByXrRQRXgl8VI12VFa9pkstw6AYFtYBD
	 UMJaF4JId/kMYFip2rz5+eI64FG8KZXbWLRUawWRuf8xTN7K1WX6iBSE8T9LsISfD8
	 8OVWPfcIFhkee9Ngelp7mBDoaNkANf2TRaSTZ3/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 313/744] sctp: auth: verify auth requirement when auth_chunk is NULL
Date: Thu, 30 Jul 2026 16:09:46 +0200
Message-ID: <20260730141450.938899468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Luo <luoqing@kylinos.cn>

[ Upstream commit 8e04823c120b376ef7dab14b60ebf6823aa16c14 ]

sctp_auth_chunk_verify() returns true unconditionally when
chunk->auth_chunk is NULL, silently skipping authentication.
This is incorrect when:

1. skb_clone() failed in the BH receive path, leaving auth_chunk
   NULL. In sctp_endpoint_bh_rcv() asoc is NULL for new
   connections, so the early sctp_auth_recv_cid() check cannot
   catch this.

2. No AUTH chunk precedes COOKIE-ECHO, so skb_clone() is never
   called and auth_chunk remains NULL.

Fix by checking sctp_auth_recv_cid() when auth_chunk is NULL:
if authentication is required, return false to drop the chunk;
otherwise continue normally.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Signed-off-by: Qing Luo <luoqing@kylinos.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260721015532.120157-2-l1138897701@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 3893b44448b381..708fa07d5fffc7 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -643,7 +643,7 @@ static bool sctp_auth_chunk_verify(struct net *net, struct sctp_chunk *chunk,
 	struct sctp_chunk auth;
 
 	if (!chunk->auth_chunk)
-		return true;
+		return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);
 
 	/* SCTP-AUTH:  auth_chunk pointer is only set when the cookie-echo
 	 * is supposed to be authenticated and we have to do delayed
-- 
2.53.0



