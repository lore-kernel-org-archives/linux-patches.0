Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729F43A380C;
	Sat, 17 Oct 2026 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260741; cv=none; b=Z1yihCwJdV0Yfep1L7vUaG52sZD8sGKe+7wn2nHJdi794WCgxa86UxPfVROX0fsIs8BhPV6tRTu8Y86LT6TIr3H3r8gBfnG73+OhvzITHr7QEfn66xxP5W4wIVFFFPMO2s3JsZ8I5XDT/fBvaYO4Oi16S1WbIkyUqQmtZMJDTPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260741; c=relaxed/simple;
	bh=AhZXVbAQeNBZ2RXxAKkPT1NT1ZkoF5nOK5nGh3mT4hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGIV6kCrl+v9fdihEQyJ/5CI8YpB2tLdmL4sLLvOeelIPKH3GB+rjwDqInx6N/2BNuDblrsNM6R1psyCSaElfgRKwk4FEBzsJphbDDdIdDbIISvASMmSSaWO+69+2bE+n7xWJi25m4pYCUoWtxTyUMmKM3s5BLt96SZpxB+3rNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypLN3ka3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypLN3ka3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17151F000C4;
	Sat, 17 Oct 2026 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260740;
	bh=0lbEwQiz24BEvqcjWrWq8W8h84OLGT0VF049bSgy/Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypLN3ka3UuC8lHVEBy2m83c08LWbuRyXAgp8pV1a6tdHqLiDyNO+m7ls89cTlayrU
	 Madj27q+K4whWxcHIJV2Zz5bjKRaikknCAsjSNYgLZk/nPP1NbtlHCIM3hRcaNcMo+
	 xGFwi+9wWP+pOR4A6ug/CFLWpaBYzDTVn5cuM00g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1646/1674] tipc: Dont send random pad bytes in RESET/ACTIVATE messages
Date: Sat, 17 Oct 2026 18:05:18 +0200
Message-ID: <20261017160513.320798028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 6c6d8546c5786..9bdb054eafaa4 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -528,7 +528,7 @@ bool tipc_link_create(struct net *net, char *if_name, int bearer_id,
 	snprintf(l->name, sizeof(l->name), "%s:%s-%s:unknown",
 		 self_str, if_name, peer_str);
 
-	strcpy(l->if_name, if_name);
+	strscpy(l->if_name, if_name, sizeof(l->if_name));
 	l->addr = peer;
 	l->peer_caps = peer_caps;
 	l->net = net;
@@ -599,7 +599,7 @@ bool tipc_link_bc_create(struct net *net, u32 ownnode, u32 peer, u8 *peer_id,
 		snprintf(l->name, sizeof(l->name), "%s:%s", tipc_bclink_name,
 			 peer_str);
 	} else {
-		strcpy(l->name, tipc_bclink_name);
+		strscpy(l->name, tipc_bclink_name, sizeof(l->name));
 	}
 	trace_tipc_link_reset(l, TIPC_DUMP_ALL, "bclink created!");
 	tipc_link_reset(l);
@@ -1923,7 +1923,7 @@ static void tipc_link_build_proto_msg(struct tipc_link *l, int mtyp, bool probe,
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



