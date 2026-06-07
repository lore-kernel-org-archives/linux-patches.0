Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45DC4071DA;
	Sun,  7 Jun 2026 10:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827523; cv=none; b=rTdZMlm/fKUX9PlzXFnY4rS/EqtKjzbajxWoL9rWfiR4BCvGW92FpR0m9TvLtWL76K0bmZ1drupZGzobR/BlvRpNwtu4fla3+QYiNUCjK/L2Ibkw+4/olUPZXUmZiucLsQH7sPXkEjj7RiLFfvvoL/qRkvGZT8D+BTEGh3pLsXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827523; c=relaxed/simple;
	bh=+1fu3ItfATl7N9jABB+xx73VI1vGDuolLLQMW4E1wFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KepSgxKP+2aWRsSHS6ndIdqWn+vCWe4RVLdv0tdS3BPPuO+hX1zGP+Y0RK4VqpiE/nVvkAk2jsD77MaRsfZQubj+zIijNr5eq7WQ4LHwKS2AFU/nhE7rcSGHboL90qvS79PYX1hc5ODfbi0BRuGnGkdSYQlKfKN1iRnNYan5J+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDhDzOn5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDhDzOn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE9D1F00893;
	Sun,  7 Jun 2026 10:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827522;
	bh=GF/750bHVrw3ARdtF6CVWwnUDDj6APUTbdbb6o07+m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDhDzOn5ah1y2Jo66DPixjQIuGKyXlCjSrnTEvuRQbGcpk3U98b7gxLEXy+utUTrz
	 i8bEOfowbo1x9UgZhcxfFwQkyj6IImmA8mzlKqZAFspmAXjJuIiwjjijm09stF5yt2
	 DvjElFt+cdM3FJLHJDJjehzZGhcv7SVQ+g+LMA1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/315] Bluetooth: l2cap: clear chan->ident on ECRED reconfiguration success
Date: Sun,  7 Jun 2026 11:57:47 +0200
Message-ID: <20260607095730.553528769@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Zhenghang Xiao <kipreyyy@gmail.com>

[ Upstream commit 00e1950716c6ed67d74777b2db286b0fa23b4be9 ]

l2cap_ecred_reconf_rsp() returns early on success without clearing
chan->ident. Every other L2CAP response handler (l2cap_ecred_conn_rsp,
l2cap_le_connect_rsp, l2cap_config_rsp) clears chan->ident after a
successful transaction to prevent the channel from matching subsequent
responses with the recycled ident value.

A remote attacker that completed a reconfiguration as the peer can
replay a failure response with the stale ident, causing the kernel to
match and destroy the already-established channel via
l2cap_chan_del(chan, ECONNRESET).

Clear chan->ident for all matching channels on success, and harden the
failure path by using l2cap_chan_hold_unless_zero() consistent with
other L2CAP handlers (l2cap_le_command_rej, __l2cap_get_chan_by_ident).

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 87ebe81277c510..57f5e3c7429e79 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5466,14 +5466,20 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 
 	BT_DBG("result 0x%4.4x", result);
 
-	if (!result)
+	if (!result) {
+		list_for_each_entry(chan, &conn->chan_l, list) {
+			if (chan->ident == cmd->ident)
+				chan->ident = 0;
+		}
 		return 0;
+	}
 
 	list_for_each_entry_safe(chan, tmp, &conn->chan_l, list) {
 		if (chan->ident != cmd->ident)
 			continue;
 
-		l2cap_chan_hold(chan);
+		if (!l2cap_chan_hold_unless_zero(chan))
+			continue;
 		l2cap_chan_lock(chan);
 
 		l2cap_chan_del(chan, ECONNRESET);
-- 
2.53.0



