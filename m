Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BBC443E21;
	Mon, 17 Aug 2026 14:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976024; cv=none; b=kc1YJk0KeaQpu1JKLdi6ftiujmZSpwF/XPNGSkuvmTUZ3433a3U9HWO649oc4GwsFx7MLFRI6ZgeRVWBHnJdy8fVeU9CdKV3am3xRPMKNziRuAX4wciscEk7wHNoPGL/XSqM3wLub3FHO7WTHIQA+JX2uZa7Sh1aXbv4mIegxxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976024; c=relaxed/simple;
	bh=ct0Z7UCaQtmckAo112UtIn03lIYGquSWiferGBhhMsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eunFlUiU1pBoaRaxvDUXTiMP2claoG/MgdkNa7k6qhj8D7eP5eSd29VL+n6YZux6A/Q6qIicUah52YmFWrTBAm90g5jdqM3yzO/NwumoFo0IwrchzbLnOc048DsyNqSOePiLzkfML+qcFVItH9zO02DNK/bsIsvG/hkgVMZCuPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLJYcXcr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLJYcXcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B1E1F00ACA;
	Mon, 17 Aug 2026 14:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976022;
	bh=W2tXhB6jsnw6UKakiL88gs1aiBXE9C8Y5U4N+p9to1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLJYcXcr10VLNsBchZkbZ1Vmcs6/dJqm9VQM4x07AiBH99I+rq9MWpl+GI+doulWv
	 Tvs7cJ3OXQmlvn16+mOuyOZMq1ZYlzo1vZAjWaB6C6DTjly5YC0/nWRL28w+KRp4wj
	 g/FytmpoQthRuM4/FLgwlV6Dq4340yWf+1bmqYQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/389] Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp
Date: Mon, 17 Aug 2026 15:31:08 +0200
Message-ID: <20260817132548.162916562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit c4740e7f23ff9a8210198d8b4703259e21b9f69d ]

l2cap_le_connect_rsp() obtains a channel via
__l2cap_get_chan_by_ident() but neither holds a reference nor uses
l2cap_chan_hold_unless_zero() before locking and operating on it.
A concurrent l2cap_chan_del() triggered by a remote disconnect can
free the channel between the lookup and l2cap_chan_lock(), causing
a use-after-free.

The BR/EDR counterpart l2cap_connect_rsp() and the sibling handler
l2cap_le_command_rej() already use l2cap_chan_hold_unless_zero()
to safely hold a reference, but l2cap_le_connect_rsp() was left
unprotected.

Fix by adding l2cap_chan_hold_unless_zero() after the ident lookup
and l2cap_chan_put() on the exit path, consistent with other L2CAP
response handlers.

Fixes: f1496dee9cbd ("Bluetooth: Add initial code for LE L2CAP Connect Request")
Assisted-by: Claude:deepseek-v4-pro
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 6649532712f4a..c9c3bef3ae895 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5744,6 +5744,10 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 		goto unlock;
 	}
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan)
+		return -EBADSLT;
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
@@ -5789,6 +5793,7 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 unlock:
 	mutex_unlock(&conn->chan_lock);
-- 
2.53.0



