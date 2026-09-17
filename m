Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEAA3B71AE;
	Thu, 17 Sep 2026 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665394; cv=none; b=jaYL3x0JWYfmSeb3ew45FlA68skHsc46TjQcTtnykJF0eJa0QKuuAmREB/ghQq5L3Xz/7z2zp+LW3I0/QwgvBtQfmiJQz3r/Mpk0YqVcT5JXHI5JRvKnu+sjc+Rq24k7RUOmqvEXUKzBrWgmQGEa48Hgh0F9O2651t5sS1+sF9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665394; c=relaxed/simple;
	bh=suV1BNQr5EVxAjVwQcpH3j6eibqsECHbU27unozIHkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEX4/XKWSbFIkbidYw/im/F0gIIUyJvGMUQA4UI/f/ZTo/N2TR0teqyJINu/Dli3CGAK+0sD/wXTLRuzRaE6sWEAXFszSdpBczcRliNPbAsBkyF3OSLO5ZRWC6mGgq6NQMtllwFjJLb2vbl239zUEIWSb+iPULyEIdkNybCW7tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNslLQnr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNslLQnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407861F00893;
	Thu, 17 Sep 2026 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665392;
	bh=BfiqywzWSMGtuY9iiVr+cA+XTPyO8GmntMPeNMu5kVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNslLQnrO1cnajX+yLZquC5H0dBrRmNg4GPLFZG7Hj/bAAL637L7CO+p5QuQ/MAVi
	 4mglKHpLeAYH/OguGSWDKn3i56141ZcGKZpAMkiUOyp2mPoWsZyK1R6CZfVXAOns3Z
	 ahb8KHjM4aSKcBkdsCd78C6G+8jfxiQul+FnyoIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0688/1250] tipc: Dont send random pad bytes in RESET/ACTIVATE messages
Date: Thu, 17 Sep 2026 16:08:03 +0100
Message-ID: <20260917151610.537310324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 931f55f781a13..da9e3b1b0ce21 100644
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



