Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229953A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urZQh4Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AF6C433C7;
	Wed, 15 Nov 2023 19:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077982;
	bh=JW7Gg5JunY76RJ3CiQZap94sDh+wrZq6qYqbWnCAk4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urZQh4FwMgO2r/BL6urUSOYF7IIDH2nnHYIjLTm4N3intone+AeOVVl8aTItjYZpa
	 xhAbkCf+UZC2Tq81H77wYERxWHKntEA6nSWR4cqRSZPRBgJI03UZihKKDwMiBGTrFL
	 0HNBGcscStjaSlR+exPkykgkGQeKXMUxiWtgrzRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/379] tipc: Use size_add() in calls to struct_size()
Date: Wed, 15 Nov 2023 14:21:52 -0500
Message-ID: <20231115192647.354910842@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 2506a91734754de690869824fb0d1ac592ec1266 ]

If, for any reason, the open-coded arithmetic causes a wraparound,
the protection that `struct_size()` adds against potential integer
overflows is defeated. Fix this by hardening call to `struct_size()`
with `size_add()`.

Fixes: e034c6d23bc4 ("tipc: Use struct_size() helper")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 2eff1c7949cbc..8715c9b05f90d 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1446,7 +1446,7 @@ u16 tipc_get_gap_ack_blks(struct tipc_gap_ack_blks **ga, struct tipc_link *l,
 		p = (struct tipc_gap_ack_blks *)msg_data(hdr);
 		sz = ntohs(p->len);
 		/* Sanity check */
-		if (sz == struct_size(p, gacks, p->ugack_cnt + p->bgack_cnt)) {
+		if (sz == struct_size(p, gacks, size_add(p->ugack_cnt, p->bgack_cnt))) {
 			/* Good, check if the desired type exists */
 			if ((uc && p->ugack_cnt) || (!uc && p->bgack_cnt))
 				goto ok;
@@ -1533,7 +1533,7 @@ static u16 tipc_build_gap_ack_blks(struct tipc_link *l, struct tipc_msg *hdr)
 			__tipc_build_gap_ack_blks(ga, l, ga->bgack_cnt) : 0;
 
 	/* Total len */
-	len = struct_size(ga, gacks, ga->bgack_cnt + ga->ugack_cnt);
+	len = struct_size(ga, gacks, size_add(ga->bgack_cnt, ga->ugack_cnt));
 	ga->len = htons(len);
 	return len;
 }
-- 
2.42.0



