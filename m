Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053693;
	b=x8qYsy8aoH689mnZlaoEdZdi2dJTPwtr5ytIoPp6k6DXkkg1OiLJWyeWwA52r50w2BsN
	 CNt0nCRzkr0LNmWkp/U90oPV4QhfTO1raGKBS9A4GgT9b3g0yw7HvhqicwX010u3SmPFS
	 S4gt1ucCbU75iLlas2dAwt127tf+y809YnEeelreGWer5IdzDlDWN/me4Wx84ejWvx5o4
	 zFSToEIiBsZGC3X4YhUlZy2NNiv9quloFCEuX0OaJde4+AtYAmsy87Kgf4vQ0A6NDU3MZ
	 n4vvP0Jc3G5TLpwWS1cCTQw7yxFARMWCvZXKPKhFMpNbWw1cFGAuM9ybUZXclmPnr2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pimQfB5wrdCFDAw8D0PugejP3d4U65vtsTW2ZoGfD/U=;
	b=K+vBzWVcSgSYG17Q3gIR4LEPTqTi1s00pJ49T92ObsNxS4+gXV47WrshjUQYL8y2LBfm
	 b3bSzFRmvV0WcBzSroaWEyTo5gpb4o//HQV1/ZD5U0DNs1u3U4upztIo53JZZTHSNkH1D
	 EUPZ7nza8drdHSmcdh7bKV8cNTAlMdo5LnyPJyOWzjrv1S2gA8Ctp8yQ6XTR++Nc1FP2b
	 isIrAtHomv4o3EV21mD7uZiZFWSv7g9oyJk52zuHV5DaHrRlECtxagG7VgJm6pFZ03qfq
	 PB7rfbYjYgHEAx5ceF+xmE86VnKIPNwH4iivi4/kPwUYoq0fuwkjW3BkDeOqMZ/C6iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSfiHYQQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98E2606A31C;
	Thu, 19 Nov 2026 02:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uSfiHYQQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C87A1F000C4;
	Thu, 19 Nov 2026 02:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053692;
	bh=pimQfB5wrdCFDAw8D0PugejP3d4U65vtsTW2ZoGfD/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSfiHYQQfCAOluPCmGqBJXK+fmw4XBaj5QPcRxrvdQydQKtzkreSUp15ByWpq9Fjt
	 dHCV0br8Tuaf1iUsqtPH1GFKSVzjzbDOGo+DRt2PuGa5A8dfqdGK12ahEbUFqI5e7d
	 BPVbR/U/AuGYXaA6QYJAHG5me12RgwseRHGwqhk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1008/2214] sctp: hold shkey across socket migration
Date: Wed, 18 Nov 2026 15:44:44 +0100
Message-ID: <20261118150052.714367644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 27bf81a893a7b..7cc3f146b1fcf 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -146,9 +146,19 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 
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
@@ -9698,7 +9708,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.53.0



