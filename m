Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585891;
	b=a8qq6Ujai10lu44yYEwMBEqFVaZoGSdFX/OwtqvXPSK0O8oJrgfHhtg1aZvHnvNxegk/
	 JqIJimpX3DFKDqZ26TnU1GsxYuOdhRyPHj1rOUJWkazKcy5q4qKrsSB/BfO/aWkHkYwpj
	 RL9ZxvgAXXIXhGYGYBw5E2Xjg+v5JCtbBY3tzge7yFZDo7SACea1502s53BGsMQoE54G1
	 yT14KwvNIPCoeflC3pfApdpjXenTMmJ+45Gkqu7RUvFl6zFW9uB+egnNP1YD4eR5Yuu5H
	 r4Hodltw2Fo6HoszVOoO35HEde0KU2exjRnyI8DtF4UUxvv8GOBSJAFnhX3YEFUb4Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vgsBivFUGXSOxX/W2ROlLclSKI0oWgKC+4DWSCbsWgE=;
	b=1pxVnOR6y1oj/Wt/kuoX2mvLNNoweOfCnTL8spFf4rispLxpcLfq6FeLV6VqFZemgvNS
	 zr5c4p5tcXXSD6thVljNjWR4zAPskG22UfeNRZluRIec1g8ENecdj5e15nbrR0moqB66v
	 /zCwXaXkLIvWQMzWVXZpLO8fNX/Yu+y+hMxida7YfsXGh+wfxg5bV9enYZWDj4YzF8v5V
	 Y6YPOoVUIoJAaAJ/kITBlp9Cn5UwhzG9/XpKagUK+nIQRELvk35gO/rUE7/Q44osrM/pw
	 UR+txwJ9hd/ua4KIvEp/BzYpyEei+47qBcbUdpoMcB8wvVFMEva1XyRQrb2rQonCTPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ECM3A0J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3158E606EA9D;
	Fri, 13 Nov 2026 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ECM3A0J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F261F000C4;
	Fri, 13 Nov 2026 16:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585891;
	bh=vgsBivFUGXSOxX/W2ROlLclSKI0oWgKC+4DWSCbsWgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ECM3A0JNtGN7EnA5pVOLjedQnvP02HMFx5TRT/JgGxB9csHkVTzbRVUy3r8soCtP
	 6PJxjxjWHKRyLjGLosXfjAnAhrZl/tpaKUipGijv9yZxidaZpkH2HrCty1vftASsOm
	 yfrJkx0Icp2dT8ogi4ibou81sIsAQnShf0cIwbAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 456/507] sctp: hold shkey across socket migration
Date: Fri, 13 Nov 2026 10:52:40 -0500
Message-ID: <20261113153812.180810871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit ad1320865b1826ffa2e81e37c49535751e81335c ]

sctp_sock_migrate() transfers queued DATA skbs from the old socket to the
new one. skb_orphan() invokes sctp_wfree() during that transfer and drops
the skb-owned shared-key reference.

If userspace has removed that key from the association, this can be the
final reference. The following sctp_set_owner_w() then dereferences the
freed chunk->shkey while trying to take the new owner reference.

Take a temporary shared-key reference before orphaning the skb and release
it after the new owner has taken its reference. This preserves the selected
authentication key throughout the ownership transfer.

Bug found and triaged by OpenAI Security Research and
validated by Trail of Bits.

Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261009074244.3718-2-juny24602@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 52ffeaa358d1 ("sctp: re-point retained control chunks on association migration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c616f1609d0cf..b5e205eca3077 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -148,9 +148,19 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 
 static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 {
+	/* Keep the shkey alive until the new owner takes its reference. */
+	if (chunk->shkey)
+		sctp_auth_shkey_hold(chunk->shkey);
 	skb_orphan(chunk->skb);
 }
 
+static void sctp_set_owner_w_migrate(struct sctp_chunk *chunk)
+{
+	sctp_set_owner_w(chunk);
+	if (chunk->shkey)
+		sctp_auth_shkey_release(chunk->shkey);
+}
+
 #define traverse_and_process()	\
 do {				\
 	msg = chunk->msg;	\
@@ -9649,7 +9659,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.53.0



