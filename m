Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C0299929;
	Thu, 30 Jul 2026 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425870; cv=none; b=Bd17ieHPNxcArBXXCSi8p+4kcD1tiEByIlKhNGlJv58w2v51qcZFHRCvqtrCcAaRf8wcW8d/TwOZ0gXmvZ/RKO+GHzCM0YjJy3O+VflQEiuzNSqLKRBe+KZNNC4so8T2HtClK95t7oE7Py4VT/sgMxqQq2LG76fz3OPP/oOPsNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425870; c=relaxed/simple;
	bh=CmVfsFXxzKr8nnMW1Ex9tVugxAUp+uWm8gSNgpFHWcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMubQ0heBpfbIe12KVl4m0x+KMUUpJgznien1Wz5usspEfBaANH3IT8MqzdhimGXbcLaEUZzIbqDsNchXlBdJlk1I+Hi5ptyOonR3HpzCz6lLZbUAWwrIHJ47Ng7BPuNwE5Z6/k0rWxuTNi5IS9MOC7Af3HMsyYm8NJVKMvoCe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEEH98Ch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEEH98Ch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5ED01F000E9;
	Thu, 30 Jul 2026 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425869;
	bh=+zymMdSupxwvVmWv7+JWBqRVnNj6L+MgbFA3mtFU51A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEEH98Ch/Rv/38QO5UUUBrRS4Q2IC2BpX8Nf64hIy2fFmwvS2HXARDqOllIlkMMmj
	 SyI0ipgG5Iyfbrsvy7Nnm/URGycFzXV4TcDBngmogNGx5j707lNo8Ie26oYjFGVUxf
	 oKqyaTUZ0mM3jcYIeHidfi+fnZvPD0UJgQS7OhSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/602] sctp: auth: verify auth requirement when auth_chunk is NULL
Date: Thu, 30 Jul 2026 16:10:11 +0200
Message-ID: <20260730141440.557927375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 96e92719ff4df3..818878f484a795 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -641,7 +641,7 @@ static bool sctp_auth_chunk_verify(struct net *net, struct sctp_chunk *chunk,
 	struct sctp_chunk auth;
 
 	if (!chunk->auth_chunk)
-		return true;
+		return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);
 
 	/* SCTP-AUTH:  auth_chunk pointer is only set when the cookie-echo
 	 * is supposed to be authenticated and we have to do delayed
-- 
2.53.0



