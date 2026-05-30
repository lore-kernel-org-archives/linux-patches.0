Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B11F3148DA;
	Sat, 30 May 2026 17:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160973; cv=none; b=EeMlEFWBwwcyC6e8m+iHbuYeIVa1mu0dzChXYWVNSR1GTnzKbiraEwqWQIcwU+QLbJjMrBy98i1HYSJPx0/+93Y5F6Y/aY1lo67VScCoIKwDf7jw2KDhnciDNYtFCIwqT1WB96NwxaafvCFBYdQhV5TLa/4Fl5rRAZQqAYz03P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160973; c=relaxed/simple;
	bh=5l9QIreEBsmU71KrBzpZ6Xc3nnGVrvIwcfWpAWIVWc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoFaoOVQUT5j9XVlN45hBvr2V/DFfa2RTLHvBj3RAza6MX04s4RwNCelOlKeJF54lN+SSWqTmSYd5SpY0vZYlimLCosCrfWJUEUmMj35f2ZJHJ7hT5PB1NGhU5+kfbpdzNk67S6WUSWGwFgmi9zFPlSfLpMj0x8Wil3Pv/MMFZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADbv9aai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADbv9aai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F27B1F00893;
	Sat, 30 May 2026 17:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160971;
	bh=/bfe0zEDjRKWrbnfZ8wZd8y12b4Fmif7RGeNY0u/6fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADbv9aaiWeRHJzI5z5OgyhFc62yYSckbFMX3I/9cZQ9PzvpaJjkBL75besgpbZD9B
	 H8lQqI4tiiAYhKuPEJbP91H1Ff8J7ioIdNpUjOBmkv8/uX+eGC5hBMPUqLSu9BLfXL
	 yuG6XEK8ENVatV0dopEV+Twk9qZWDV0r78r8Tc10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 488/969] Bluetooth: l2cap: Add missing chan lock in l2cap_ecred_reconf_rsp
Date: Sat, 30 May 2026 18:00:12 +0200
Message-ID: <20260530160313.785016084@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 56fbf8d2769c6..21f63ca434e3f 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -6461,7 +6461,13 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
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



