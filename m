Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A49C26738C;
	Sat, 30 May 2026 18:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166402; cv=none; b=nyfpcbCANg8JPgUcJ+cU0sCeSkyGioR7DJhI6JwaHzzj2TLmsSR3ZwFa1hU0P8QhpgJb/PeV7VO3XtHaypK6tnpd1m35BL19stJwWZ4x1oAv3FqrAgtWx0FLeRvSHY7QA67uc50s4mEMBhFGFAiGuyEbfkTOc2c3BV/HNRo84eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166402; c=relaxed/simple;
	bh=BSOWyHfV5JQ/ZCaRAiP57FHtt5SD1iWhKzsj+TOnPcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gukzsDQQ+i+sfEvvtOJ384xBgsB/SOAR5j6At7BoH8ioZRxsanV3ARMzo8pn7owkSkWF2JS1lbLOjbPptOirvYmkrrtPsssqJk8UIEqiDfVrUzc8SgrC/L5Ss52vhlPWZWYlAlQxCuOJdYgMc7PLhddR29JwsGi89MDOnCOCCUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHBMrw49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHBMrw49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9981F00893;
	Sat, 30 May 2026 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166401;
	bh=zfB2L5v6jck+PqleNjRffIWhSNgm5k1UDfTmuwLTVQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHBMrw49V4KFGP7YZQZ6o1Q5yfcoSWMYamvyMvdorXm/Ed1BDb/M72kJkAUOccsz2
	 LJsfCRjFQGN3p7VciNhyeu3m3ntbisKvvsB+Fg9xN15jJe4fX2g998r9Ok794ul9Rs
	 BEE5PISb5j2Jysn39ExRFSZas5VgYcrnA3eRjJfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 318/589] Bluetooth: l2cap: Add missing chan lock in l2cap_ecred_reconf_rsp
Date: Sat, 30 May 2026 18:03:19 +0200
Message-ID: <20260530160233.292613424@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 42776497cdbc9a665b384a6dcb85f0d4bd927eab ]

l2cap_ecred_reconf_rsp() calls l2cap_chan_del() without holding
l2cap_chan_lock(). Every other l2cap_chan_del() caller in the file
acquires the lock first. A remote BLE device can send a crafted
L2CAP ECRED reconfiguration response to corrupt the channel list
while another thread is iterating it.

Add l2cap_chan_hold() and l2cap_chan_lock() before l2cap_chan_del(),
and l2cap_chan_unlock() and l2cap_chan_put() after, matching the
pattern used in l2cap_ecred_conn_rsp() and l2cap_conn_del().

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 24ee019c0b696..45e1e8192e3b6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6439,7 +6439,13 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
 		if (chan->ident != cmd->ident)
 			continue;
 
+		l2cap_chan_hold(chan);
+		l2cap_chan_lock(chan);
+
 		l2cap_chan_del(chan, ECONNRESET);
+
+		l2cap_chan_unlock(chan);
+		l2cap_chan_put(chan);
 	}
 
 	return 0;
-- 
2.53.0



