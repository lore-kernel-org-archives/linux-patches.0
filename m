Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C5136C9D2;
	Wed, 20 May 2026 16:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295008; cv=none; b=LOR1Y7CmezXIKEp7l1yCmleqtCIRD/ur0dPj2fS+rMBMMDIWpwjKzXr8gRg+yBQKgth+vu0Yn71D+Uk//i0e5uKdTEXvWTQQ7bo9OAOICVwWf7LcwfKzTCI06HkA2XaA0Q103zUoRGQg7MQg/VC+zYNESFqu8DcU5NF0/0V3VDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295008; c=relaxed/simple;
	bh=7dUSnBPKrFIFv0Zb631XinKuyfahkCAM0d0hBwDhF4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTV66cQjlJDEQYAGtZ6IF/sKEYkINIA2dQ1u4btMKsr3SItDhpA4idi+ic72X30N7zXjoOu1Q3cTBY7gV39rpyz+7nIBbrpP/9SPgw2eyFpUlMGiLJbiZZg+27ysly4Rtt0uUHrXkWvI1ZNwGlBH88gk+VV4abbqnE7vTI3j8Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/hHreGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/hHreGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A691F000E9;
	Wed, 20 May 2026 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295005;
	bh=DTqWZDRQ9WxC1R0WfRLOEJH9NE53Aj//ts3AmlzeYBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/hHreGi/8pyrijM8TWLM1epKEZ9e5iQ8SQeDGv1Vccg6D7fESGCiX/87zOSsBJ9b
	 wPWzartajbUcfZtvYz00VD5iH/vkFjpC/jEPRIiz1GBh8nqPNX1VdVN+z2O/Xx1J4g
	 h+2J3CSGt+Pt/+Fi9/FUgK4h74T07FeGsriFsigA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0214/1146] Bluetooth: l2cap: Add missing chan lock in l2cap_ecred_reconf_rsp
Date: Wed, 20 May 2026 18:07:44 +0200
Message-ID: <20260520162153.104755726@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 1c82612679e60..0d8053a3fc0a6 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5473,7 +5473,13 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
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



