Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B6935F602;
	Sat, 12 Sep 2026 09:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204218; cv=none; b=T4gD/masRXko1Sab/8rxmCwBR0/Y3AM0DUq3n2Y0eNlLQjfSmjQA3K3TZD7pI64oEgYIj3GknR9Q4dSm26BnRqesEf9J9op6vgr+uc5T2937nT6j2OnTbI60f4Np/KmNn8SCbvz25FjRh7yMTtx3aQXXqTT9y7vq1JStvIHJ7zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204218; c=relaxed/simple;
	bh=WOKGdciHS5RFDQodom2cgyne56glqbihC7mtuC+vqCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTT0A8Ljtl66/F1x5c9JgeKXxnvEpFX2dVBdewlfYMHkhuFsry/YHgXRy7doz3B2F8WtWeWHDYpWq9hY8ZehBEsn+rI5IJfmv67CwlKQ8yo3rKZPEBg4I2erZYYzK7cyFxpMu1K7nmo8JC6b3ReatT2F8h5Tk/C+lglP5ER7nOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJn2SM1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJn2SM1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B3E1F000FF;
	Sat, 12 Sep 2026 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204217;
	bh=I/YbpeHb5Vdf3Vq8JMi3YuK/CCa7W23zATGqif+O3Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJn2SM1ZGEkhzrm/L3F8rbrJk0wStyQpGNJZyLiRBeD7L0YNQ6mxCnLp5L2Y/004w
	 TbVWUdcMyGCR0nGCFIuphMbaZdNDQK6rfMPou4liPP9Al8pwOsBnRLx7jAELsMQXKe
	 CTy8dqiRspW9xmfTK45W2FSmogUM2xMWEOt3FA3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1568/1815] pppox: drain queued packets on channel handoff
Date: Sat, 12 Sep 2026 08:55:18 +0200
Message-ID: <20260912065725.804445917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 92c1bf630abf0af646562398eaa36f80b5ff677d ]

PPPIOCGCHAN both returns the channel index and marks a PPPOX socket as
bound to generic PPP, despite its getter semantic. Packets received
before that transition are queued on sk_receive_queue, but a bound
socket is no longer readable. Such packets therefore remain queued until
the socket is destroyed.

After marking a socket bound, wait for receive paths that observed the
old state to finish queueing packets, and then drain the queue into
generic PPP.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Link: https://patch.msgid.link/20260811035314.302878-1-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppox.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ppp/pppox.c b/drivers/net/ppp/pppox.c
index 5861a2f6ce3e6..a6f72c813bef9 100644
--- a/drivers/net/ppp/pppox.c
+++ b/drivers/net/ppp/pppox.c
@@ -74,7 +74,9 @@ int pppox_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case PPPIOCGCHAN: {
+		struct sk_buff *skb;
 		int index;
+
 		rc = -ENOTCONN;
 		if (!(sk->sk_state & PPPOX_CONNECTED))
 			break;
@@ -85,7 +87,22 @@ int pppox_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			break;
 
 		rc = 0;
+		/* PPPIOCGCHAN historically marks the userspace handoff to
+		 * generic PPP; pppd then attaches the returned channel to
+		 * /dev/ppp.
+		 */
 		sk->sk_state |= PPPOX_BOUND;
+		/* Let lockless receive paths finish queueing against the old
+		 * state.
+		 */
+		synchronize_net();
+		/* Drain packets queued before the handoff because a bound
+		 * socket is no longer readable.
+		 */
+		while ((skb = skb_dequeue(&sk->sk_receive_queue))) {
+			skb_orphan(skb);
+			ppp_input(&po->chan, skb);
+		}
 		break;
 	}
 	default:
-- 
2.53.0



