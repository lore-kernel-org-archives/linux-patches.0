Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591425;
	b=S1O2MZOmSMcPlc6qtdHY8C/jkLaM3f2OpSX3s/02xj0dC5hMTvUCDrBf8bYieOkNSKzi
	 OacQqdZmgk0MmXTxWmLFI/NQTjnRdKKFXNZCVL7REECHSCv9RqPe98GVWgXzdPHBj5tSh
	 iYf5VXgPQy0Wa1EeXDHdfindkYwTSIpEwSiP2aRrcdd1wz5ex4lFBKeWizakhnC+xFPIW
	 Vdf+shiCat+X+rTSqfEvftIHfFmKN84Rbp6cKRXXvIcO9K5a4kk26xN4oV3ZnWptlGtfx
	 0y+mah2hvyOiplYQ2Hn5oGOMcK37ci2RDKAAn2+tZDQg+YTbABmkSh9+8bbMMRsSXJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lvnz278wKp0xxnpUgHw0AT972Is296b6tm5IBN+IHQI=;
	b=OwsycwpUtgnXsPYII4pdZYUv7QHiue8F9JDPFt/6P0L55PjjwaCZ48YUTwoExswT1jbb
	 iFnsKn/ty8W1RDWd4cTmgPk37qxQV5gJrRijloprWy/iDKjtXEhJg+ebdK8r185/4uKwY
	 JJ4gKIHNPwDM/KBYwSbgcc1byocjKX0VvTAN6S2kApCN9a3V5qey8bGjxgjKjHpXumzAC
	 KhEk7AH9Sw1x9Yc9jrxE0Rjwj1c+ISrNCwt1HSHLut5K+xJOzZW5HDeFILmZGVglVWOFR
	 /EQ4Zf/RJgU1IrWrJMMatMN1jDdVRDlOzk7LCG3pqYcCWhu8YDr/+k/ZW81Nj+iDN1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=byzHCrcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BF3606E203;
	Fri, 13 Nov 2026 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=byzHCrcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A371F000C4;
	Fri, 13 Nov 2026 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591425;
	bh=lvnz278wKp0xxnpUgHw0AT972Is296b6tm5IBN+IHQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=byzHCrcOvr2rHnQP+IT/ikSRE8nLpkmTiayJr1Ki2Ifx6Qs/K0PMVo8e7LBD24rvq
	 UU6UMAvwSVV+w+/WiEUfsiZgWU/K4JdohkOzEH/OChHivyjQOCexi5i5oTxx3bdmlX
	 SUMOZw0RI13x1dpKwWGD51fMr6x2Iz/HpybUD8QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 476/670] sctp: hold shkey across socket migration
Date: Fri, 13 Nov 2026 10:50:40 -0500
Message-ID: <20261113153828.084011261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e2885a994314a..3d45188488b97 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -149,9 +149,19 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 
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
@@ -9707,7 +9717,7 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
 	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w_migrate);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.53.0



