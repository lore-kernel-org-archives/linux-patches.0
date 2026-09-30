Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB6D51C060;
	Wed, 30 Sep 2026 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784990; cv=none; b=fUotK0wqNRAUhu+hrBx29u+ZfDx3MCKFWieyEdHqbtE1TmuziwY2nW0eNDznp8PbtN/l2NnZ2X1aSLnU656VjG3rmZH1ixFUDdvT6Qkco94NfLRTnJj3enR4wYYrOWmkb/d6qx/phS+9RrnSdtpneYt/1YOSqnRl7A/1hBhFkNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784990; c=relaxed/simple;
	bh=0W8gVBlModI+ZwOySFcx5RwI3RAII5S7I9+366R22S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL+uXuYwX+UH9rOW+6dlaac6n1zoOCbAODxaQ5oZ8EuSHlmAw9QpOZrNxFAP4+GkWnAM+99OW+Ymoh/xZXMXzXUQJ+X+qs59c20I/3P9lSMUy5svMuIeGP49q3nR1UhfVOW1VIhzvORDQnhf4RdpUPPoEHyQa+PBmldT1r9Mj7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdHhTBif; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdHhTBif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7771D1F00898;
	Wed, 30 Sep 2026 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784986;
	bh=jFe0mN2IxMN4m+2mus3lbTJs/biSJex8fP79KCKEYAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdHhTBifPZ8qUUFcy7DITZL1obbwrnCYVatF3+6myYKh82UBmAYZXSD5Kt1fkoyu7
	 R1Qw5B2f0NwaGfXqKQKwQ2+eC6RD44Bv055ChCS6695wWyG2gFUloXF1GpQOhLeH2k
	 rYjiZwl+v+hRW77gOkRRW+HsVYl6lorb32ZcoPFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 347/982] Bluetooth: L2CAP: clear FLAG_DEFER_SETUP only for same PID/PSM
Date: Wed, 30 Sep 2026 17:18:03 +0200
Message-ID: <20260930152424.268652214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1a625c4fb395c..1e3022e097118 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1350,7 +1350,7 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	if (chan == conn->chan)
 		return;
 
-	if (!test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
+	if (!test_bit(FLAG_DEFER_SETUP, &chan->flags))
 		return;
 
 	pid = chan->ops->get_peer_pid(chan);
@@ -1360,6 +1360,9 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	    chan->mode != L2CAP_MODE_EXT_FLOWCTL || chan->state != BT_CONNECT)
 		return;
 
+	if (!test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
+		return;
+
 	if (test_and_set_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
 		return;
 
-- 
2.53.0



