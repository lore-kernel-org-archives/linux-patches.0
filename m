Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9AE38C437;
	Tue, 16 Jun 2026 18:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635321; cv=none; b=XgnYJfVTEfoSnQKv3hKhIROU1jPEZPWjth47An556AQNj6kYUg4PCbGB+IcOv2/EswfQJ7z6ulT+OaEKEu4lQv0BT66O2X9eNR6xjtzZMAY9lmHf6s2ZDXjtQRduxX8YCzw9LRegNwDjK48LUtgd70Y2h7pATxtfgRCtxhD7aWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635321; c=relaxed/simple;
	bh=NDoxrjUdxl8CrAZtDfZFDpoi5ExozlaDRYMdp+rqkVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3UhJ8EJfE8ZILz4DYZ0ZIL2C8kJnBquQWQvKnrNgVb1POFoTaO7VpQ8v8eQboXoIUWLhXkKMnqBArjztdgy3kN+K4m5ka3mszkUPrljktbTIi1W+wbnYQTRRMaXUSjpg7VpX+er7bPskpJ381vmSAZHqR/j944GZ6/jpoiVyYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/fNQWbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/fNQWbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710A71F000E9;
	Tue, 16 Jun 2026 18:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635320;
	bh=wlcS3djamP12kdvyruNFLq0RywAwJE2DQSIilur/u9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/fNQWbwOk5WvQ4lwzayq75Z1ivm0LOiFGpwXLPUoKQZoBM7qKbGsvIMMw+2mJxMz
	 daifFUHq18gkwxNy/DNHsuyuBMA3AMCMCl8rCEx9gQKhc7rovz4Eo9JQ5PEM3b9qyf
	 NiEZTniSW5N3hSdr14DKKfDA00mkARLdDSrvq0dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/342] Bluetooth: l2cap: clear chan->ident on ECRED reconfiguration success
Date: Tue, 16 Jun 2026 20:25:23 +0530
Message-ID: <20260616145049.523585737@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
index 45e1e8192e3b63..f30624d20bb09c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6432,14 +6432,20 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 
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



