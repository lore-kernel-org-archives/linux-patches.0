Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CFC4F7984;
	Thu, 17 Sep 2026 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659116; cv=none; b=XxsWFTxFfbvQ56ce19IeNTtBWWw0LjLIbFezgQfIkhoaM+bYdltGA9dMj/5ahh3wyQnreg5ypLCT5X0TxZBo7JKs0tp079cIUIDhjezEKiwAUV49FJs2DBxfSs6p1/pKa/WnfdG1wvl808bcSAEfEFABk80pcj1FE42Id0DjdbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659116; c=relaxed/simple;
	bh=VPcLWQDWI+mH6ys8f2rpGX929NU1d0mRjruee+DDn2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ug4c0XoegKiGn/PdYm3Km6uoFvkZry4ydsQBZo3CNp9KqZaQscVj3IvQpj/2bMM7xqTzdPmdSfhZdv/ZuQrP0fxA6YM9K23IiW9INdv5sIN6LbcSBpstetglOK97n9HajapZ4Hm1w0d9zhzdyE4WF49/QOIMhLio94UwFQceMJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXz6gI/Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXz6gI/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5021F00893;
	Thu, 17 Sep 2026 15:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659111;
	bh=yMYPe2Lzkuw8z/w7XcP3JCzUxMpaqhs82MzhTnu/mMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXz6gI/YbI8rpMtXWJgak/0mDQP4OwCqHlPffowL0Oc05jkchV+9iJGVoMbYXDbC5
	 yguCmZMKPLozrHwUu3u0n4TPD1mGTccugeeVlWOWs7h7RdWBvnoAbOFMMvUcgfOMaJ
	 WeQJCTVgJv5mGmiR1+b+Jad6A0U1mkPfwZpplIEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 147/733] tipc: Dont send random pad bytes in RESET/ACTIVATE messages
Date: Thu, 17 Sep 2026 16:07:35 +0100
Message-ID: <20260917151354.713844964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit 81c600c26302a27852ed8b19c5f2f647ea3555c9 ]

The interface name is passed in a fixed length (TIPC_MAX_IF_NAME) buffer.
Replace the strcpy(data, l->if_name) with memcpy() so that the
pad bytes are actually written (l->if_name[] is zero padded)
rather than sending random bytes from the skb to the remote system.

Replace two other strcpy() with strscpy().

Fixes: e74a386d70c7 ("tipc: remove pre-allocated message header in link struct")
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260829115813.188600-1-david.laight.linux@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 49dfc098d89b2..6427c69f89294 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -504,7 +504,7 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
 	snprintf(l->name, sizeof(l->name), "%s:%s-%s:unknown",
 		 self_str, if_name, peer_str);
 
-	strcpy(l->if_name, if_name);
+	strscpy(l->if_name, if_name);
 	l->addr = peer;
 	l->peer_caps = peer_caps;
 	l->net = net;
@@ -574,7 +574,7 @@ bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer, u8 *peer_id,
 		snprintf(l->name, sizeof(l->name), "%s:%s", tipc_bclink_name,
 			 peer_str);
 	} else {
-		strcpy(l->name, tipc_bclink_name);
+		strscpy(l->name, tipc_bclink_name);
 	}
 	trace_tipc_link_reset(l, TIPC_DUMP_ALL, "bclink created!");
 	tipc_link_reset(l);
@@ -1898,7 +1898,7 @@ static void tipc_link_build_proto_msg(struct tipc_link *l, int mtyp, bool probe,
 			msg_set_dest_session(hdr, l->peer_session);
 		}
 		msg_set_max_pkt(hdr, l->advertised_mtu);
-		strcpy(data, l->if_name);
+		memcpy(data, l->if_name, TIPC_MAX_IF_NAME);
 		msg_set_size(hdr, INT_H_SIZE + TIPC_MAX_IF_NAME);
 		skb_trim(skb, INT_H_SIZE + TIPC_MAX_IF_NAME);
 	}
-- 
2.53.0



