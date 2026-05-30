Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D5D355F53;
	Sat, 30 May 2026 18:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164009; cv=none; b=pIw7UeJpnNk6AK5uo8axrJQcQSgcnbnJbDimXjKVdb5L7IYOLiCdZlawOeQc1pzhMearlklN0QuZI9mAxso4jDba2p1qIR2fidVvSDK3FGTI8xPZxokXtTrx7HE+SVKKs+4faHh7GncbjPeqkms93CpRzAyqCbXIKZ49zYJFN/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164009; c=relaxed/simple;
	bh=gevESrQk1UOVlqFrMV9e6KqCDGRyQbDZi2uAY9WKyMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhJgDlinmGVAf2iKN5eEWBYPsZcxgsz49Rr0HH4kVCNFu22Arxefrsq2vn0FZr2P56M+a9MKQE3RnxzZjO8MiEUYSZ2MdyACga/XQYqfYdhZoAymwySiKnhOaAD+9txGa03JGkynezBIrU+PEmhW/m9MZHINZvoa6Kb9LGdv64Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlZbKc98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlZbKc98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022061F00893;
	Sat, 30 May 2026 18:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164008;
	bh=WdN2NEBMi3Ypu7GMhsMrQ0g+yB4ZO+HQECWpANKfpPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlZbKc98FCCIddTrfTpSogzJiW7yOPXG+4blBG9SHg+7wTMaMy61kC1qCPQtdSTWg
	 3tmexiR+XSqSpikO6nSBwyZ2HDM2WpbibETWoSE2/aAPJg4bqX1jt8ghs1LOZmI4uZ
	 kHW628u4HALYMx2HG+fogT/rdjtp8/juMWnAewjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 426/776] Bluetooth: l2cap: Add missing chan lock in l2cap_ecred_reconf_rsp
Date: Sat, 30 May 2026 18:02:20 +0200
Message-ID: <20260530160251.460550899@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index 9bb9301414f8e..a5db427c13de2 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6429,7 +6429,13 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
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



