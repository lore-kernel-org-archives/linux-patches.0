Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA9A412BE4;
	Wed, 30 Sep 2026 19:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795189; cv=none; b=fwW4QLzsBOmA0oTLCDzSLiaJnVAUffrTw1mrlYBI5T5BZu3IGZZl8nP2r0nW8hT5ujW3WhT5cxq91gVBPhtyOSJ9MYtTr8plBra0lXv1m4izlh8WAAWS6ifJ/d+drMNq/u2tUrXAlryOGd8BYY344A6b6JY2gtmEVdmiLH3ghE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795189; c=relaxed/simple;
	bh=1PsGVscuNHILceKfIiU3X/WBrRQ8GMve4hj1AYx82Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrOrbPRVBQKRZOoiz6jEs4X79vtHjjBdBqeccneQg2vBRSM7nME/3IvDAO972i5BtocyDVyB0dIH2p6WfgSukeBmJ+I1FiSmBJGgiel81UhQm5E7+4YTOL6bBDZ6Chz78s9531+ePDE++Qngi3nGmuVN3GwnLGVgvWW0Gkmci2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UC10GAty; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UC10GAty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ED41F000FF;
	Wed, 30 Sep 2026 19:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795188;
	bh=8iDKHZGFsg1RQvJr6Rb9POjHhRCxwmjTUvMvypHOcDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UC10GAtyJGkfbb/V2QyY2ATHY3xQ/6L7tFqo/1ujKarMzFAawVttnGRVSyRe4LMcj
	 2tzwptvDatCiShIkuacZiOdVp8pB5gq0orwHpUzCQqGvpzG/6rfcyo3jkB7rzIkQZR
	 JyXZl8qVaBzOQQ3f2yYwfhRcy5qrVhv1Bmzx6ijc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0419/1193] Bluetooth: L2CAP: clear FLAG_DEFER_SETUP only for same PID/PSM
Date: Wed, 30 Sep 2026 17:18:23 +0200
Message-ID: <20260930152443.512530979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 0d77683237270702fa93489ca759c89b4e970554 ]

l2cap_ecred_defer_connect() clears FLAG_DEFER_SETUP also for channels
with different PID/PSM, which will not be added to the same
ECRED_CONN_REQ in any case. Consequently, only one ECRED connection
group can work at a time although it appears intended they would be
separate for each PID/PSM combination.

Fix by clearing FLAG_DEFER_SETUP only for the connections that could be
added in the request. Retain test_bit(FLAG_DEFER_SETUP) before calling
get_peer_pid as it may be NULL otherwise.

Fixes: da49b602f7f7 ("Bluetooth: L2CAP: Use DEFER_SETUP to group ECRED connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 6a4b22ae9570a..728f1522eae80 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1340,7 +1340,7 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	if (chan == conn->chan)
 		return;
 
-	if (!test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
+	if (!test_bit(FLAG_DEFER_SETUP, &chan->flags))
 		return;
 
 	pid = chan->ops->get_peer_pid(chan);
@@ -1350,6 +1350,9 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	    chan->mode != L2CAP_MODE_EXT_FLOWCTL || chan->state != BT_CONNECT)
 		return;
 
+	if (!test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
+		return;
+
 	if (test_and_set_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
 		return;
 
-- 
2.53.0



