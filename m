Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339313AAF76;
	Mon, 17 Aug 2026 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975617; cv=none; b=usiLmXchEnVxEVmmo3ZK6yIQ9Z2X3XbtSwomok0EYZl/23va4BVPZLVmWVg3Lop4MC+OArkvrWPeIXTAKTjh9XnGxWfSubUVCho+90ltuSBF3gP0qL5/afbaNnLHJKd1k0Dy18VPbPSMsqjK8mnRHW7aidE7QTQu4UlT0z8JJqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975617; c=relaxed/simple;
	bh=aLEytHHqFZgKtGQFQI2yd2ZznbMiVTITvC3iyEdN6ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyqefyIl8ZFQJ+NFrhBFanJcWBPKnIVNZFkvr2bWy4Los2FwqKPYqVAaOJRukvEwVkT4tRctfHb3Hq0zZ49d/i9yiOBb/se4McrpE+uVJ9PO74jQKCKE4BSpYjxytw+HLg1kZmqmRzCRcMXgfpOjQWr7ogo9uEJ0J3JgY9fAcKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0WY99xS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0WY99xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8686B1F000E9;
	Mon, 17 Aug 2026 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975616;
	bh=bXZtLPcvnops/oLnGjRrRiBC1tu8SPDZYsnXtChXs6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0WY99xSNmKv8Rs5ZY36XBN2zZRiooREblGjb705eQEwVF+Virjimdw4UetiaTBqV
	 GwNyS4AWgl9+E3AM7NEicmC7NN4I6ZCZ+D6gFAgoaxhoKJdc1jLfXP0443HH2610ih
	 tWHPPnvv7zBcn3OOLoL6g3wjbmSSWd3rsWjVUAIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/389] sctp: auth: verify auth requirement when auth_chunk is NULL
Date: Mon, 17 Aug 2026 15:28:48 +0200
Message-ID: <20260817132542.583452646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 17b9deb0cc758b..4ffb45aea51d7a 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -632,7 +632,7 @@ static bool sctp_auth_chunk_verify(struct net *net, struct sctp_chunk *chunk,
 	struct sctp_chunk auth;
 
 	if (!chunk->auth_chunk)
-		return true;
+		return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);
 
 	/* SCTP-AUTH:  auth_chunk pointer is only set when the cookie-echo
 	 * is supposed to be authenticated and we have to do delayed
-- 
2.53.0



