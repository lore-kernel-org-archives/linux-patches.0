Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697922798F8;
	Wed, 30 Sep 2026 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782885; cv=none; b=qOsSCmw+AT9rk9vtZK53TKfFKNtelNptZEaefBnKNbbsFjFXsv1itB+gIPEWGpQa2Cflz08dnyVeDXymvS+AnMU10Nbcd/d/6q162MkIKyHwSmCAFIiG6H9reqa1n5NpyGVW8WCpntSKWpqX9e5U2jclz2gUPyhafxUPZHmg5DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782885; c=relaxed/simple;
	bh=SNjzunkMbqMNd0mm7AuoQe3dKrXH3z8yo1xtk5/hePo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBrSBhX3LFHsuZHMWK9WhomvWSsqzRXCVEOQqQQkz0wE6ufKBEBs0H5/PcxCv1klYsrj8XkVb0pYirgGQWekxELw+nsFcAQEA2QaGEncGaxVLeGZ/RX+9+QCQxEN9ISblfFE2IkYMlnKddFPGiDkcJCmr+kQlwMLsldDIHjK9W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxSBFOyw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxSBFOyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA941F00898;
	Wed, 30 Sep 2026 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782879;
	bh=HCp1tDpWa/7cou+xQ21BP7P/5H6PGeSLoBAySriwJvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxSBFOywjMkBtiYIWVpDs/nt7LZT75CVeDMYsiZFoNS9By68SIXsFZKmDWqad9UK6
	 JpI1yJQIajtZL9eoc4qkso5FF2Y7XTEh8QDwCqTtlr3NOxHnb44lI8FM8nbj1UkPOG
	 ToH3O3kJhpKB0b7jDvcnCWcTjMCBDwMrlsOZhxkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/595] Bluetooth: L2CAP: clear FLAG_DEFER_SETUP only for same PID/PSM
Date: Wed, 30 Sep 2026 17:21:33 +0200
Message-ID: <20260930152352.037181753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index df2daa2c2ef3a..e974d8038dec8 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1477,7 +1477,7 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	if (chan == conn->chan)
 		return;
 
-	if (!test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
+	if (!test_bit(FLAG_DEFER_SETUP, &chan->flags))
 		return;
 
 	pid = chan->ops->get_peer_pid(chan);
@@ -1487,6 +1487,9 @@ static void l2cap_ecred_defer_connect(struct l2cap_chan *chan, void *data)
 	    chan->mode != L2CAP_MODE_EXT_FLOWCTL || chan->state != BT_CONNECT)
 		return;
 
+	if (!test_and_clear_bit(FLAG_DEFER_SETUP, &chan->flags))
+		return;
+
 	if (test_and_set_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
 		return;
 
-- 
2.53.0



