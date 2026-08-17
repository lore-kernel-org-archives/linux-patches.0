Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A600843F8A5;
	Mon, 17 Aug 2026 14:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977296; cv=none; b=prFrhTRpjM2NOs8II5RGjAL9R/0KK+nnI7pW8/YUoZVWsWIhzWRwnERtpsoXI9hdR2/ad2CnbSKcT3B1RWZIFPoFkZSI02iYteFzwBwWfl1jQwXKctwUoPZa2+y0Xrz4ms4sgaPet4BCghYVHeewQ5jwcTbndJ6dAl8Aobtbt7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977296; c=relaxed/simple;
	bh=zZPbs8PcuYLR15CbV1vB8CV0rSywHl7xwwZReFGpNMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odwcSH1Dkwmawgjd+M7r8G3Dn4W3Ar+norpALXUC7moiIQioiolbSdjQ6MvMLBTL1lRKXIt9SIb+vpGKSa9sk6slUnOuaHkkmzpizjvHp/IrK39VArUZBzji2NlLpRBW1IJVS9s76uW2Mxb/r0k6mT4WZCMH8otDdx1v5k/gFTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHJxwZu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHJxwZu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABA91F000E9;
	Mon, 17 Aug 2026 14:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977295;
	bh=byZ1bNQxkFt+0kQtVHb/YoBX00nRlYFshCBHH+41ts0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHJxwZu0SjufstvKoMCSbMV7EKOKEAdVTXcm8BTntJvAYJt61kDkYqDw2f5pt6kJa
	 kVpCyvQ8Eo/JZtLzP+8Yk/T9IoAxglFG9ZrRg10GCdedIkXM4bIsebkO0OJUAPOhWY
	 E2fHd37pgGB3F69JWzbk4xKf7Yz0E58QlQh00PGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/456] Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp
Date: Mon, 17 Aug 2026 15:31:11 +0200
Message-ID: <20260817132550.927828893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 196b3bdca2644..913c0d04a481a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5734,6 +5734,10 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 		goto unlock;
 	}
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan)
+		return -EBADSLT;
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
@@ -5779,6 +5783,7 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 unlock:
 	mutex_unlock(&conn->chan_lock);
-- 
2.53.0



