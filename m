Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55FA3B27D1;
	Sat, 12 Sep 2026 19:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240316; cv=none; b=K9TPHzJ1LGDs6lmOAg9+29kSYnZkrZ4kqy7V+rl0yNnXqhsahW/rYE1G19/UZ1UyDj7xQBYcIH7zRZjGBiLSJSVMNKnhJGkbDlONMa754+kkms0H9UNmJxWMtUGJOk7R7acNOAVqINEmnpbNZ+Eh8CLA+9rCsW8Ig6UFabf8C/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240316; c=relaxed/simple;
	bh=PM40TO+8YVj0JasackdsrioNsHGdxUff0hCV+BDuxyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzZkLoUUOtILaSQEGCW/YQ6GsKAbJlLzoKY/VF2O6FbPvnFohUoshR3NfNn4DJm8MSJLjfyM6MTdYzefnyvJ6Vs7irAPaQv8AAeG76a950fKkZhgWLYx9SVgpzaFqlyaWLVNFSV6wrX61BDpnjjkvvKt4KLcgAnvWsAkgzd/q/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1rJ8ArS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1rJ8ArS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7FA1F000FF;
	Sat, 12 Sep 2026 19:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240313;
	bh=SUrIqxKmM3pVX/0p0/CQfqV/WwQ8YgQRh91fnq5O0EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1rJ8ArSToRZd7KvCJiD+DDJVjUN1tULvXREMmvS/s18HTT+R76RvCT/Y6hpx1css
	 MbPzTePDj7ekHdjzSghg5HnzLNrwTmnJKfFKkpZ24uj69XaAP/Y+0Z6scF1AsXlrtL
	 6ThJY5nwrprrSM6EqZZ2WrXF/NDvMvA59dPyyVk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 842/935] pppox: drain queued packets on channel handoff
Date: Sat, 12 Sep 2026 09:04:32 +0200
Message-ID: <20260912065546.139366073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 08364f10a43fa..61b3453469dce 100644
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



