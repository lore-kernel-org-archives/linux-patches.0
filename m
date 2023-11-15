Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9713307B
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAPH9jnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB54C4E777;
	Wed, 15 Nov 2023 20:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081612;
	bh=vWgvZfkfbc0i7SXkWgw3/Y4OLStX5ZgVvM3uza8cEbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAPH9jnkUgWIOFU2w/bT/doL1y7S2i1fJ9qfD3KIUIzvSPgR5oABm1qoFlR3ydkxr
	 N7PXQF6A8Ab3SpA4Zh9Ng1/3w+HdoGUYpPx+UoyESSl9JVlDH58Fz1sNnNWNiv/Ma9
	 4gbNPgmGxJvWX2S+WUAszK2z454K4RgtncVgGY2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/191] tipc: Use size_add() in calls to struct_size()
Date: Wed, 15 Nov 2023 15:44:51 -0500
Message-ID: <20231115204645.481399767@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dbb1bc722ba9b..5f849c7300283 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1410,7 +1410,7 @@ u16 tipc_get_gap_ack_blks(struct tipc_gap_ack_blks **ga, struct tipc_link *l,
 		p = (struct tipc_gap_ack_blks *)msg_data(hdr);
 		sz = ntohs(p->len);
 		/* Sanity check */
-		if (sz == struct_size(p, gacks, p->ugack_cnt + p->bgack_cnt)) {
+		if (sz == struct_size(p, gacks, size_add(p->ugack_cnt, p->bgack_cnt))) {
 			/* Good, check if the desired type exists */
 			if ((uc && p->ugack_cnt) || (!uc && p->bgack_cnt))
 				goto ok;
@@ -1497,7 +1497,7 @@ static u16 tipc_build_gap_ack_blks(struct tipc_link *l, struct tipc_msg *hdr)
 			__tipc_build_gap_ack_blks(ga, l, ga->bgack_cnt) : 0;
 
 	/* Total len */
-	len = struct_size(ga, gacks, ga->bgack_cnt + ga->ugack_cnt);
+	len = struct_size(ga, gacks, size_add(ga->bgack_cnt, ga->ugack_cnt));
 	ga->len = htons(len);
 	return len;
 }
-- 
2.42.0



