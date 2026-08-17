Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C6E442B30;
	Mon, 17 Aug 2026 15:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979966; cv=none; b=ALDrwHYv2fyRTM8brIGrNj05kwn+vfYDa9FyOc2TeoA8eLzaMnDNt+eyTjRhk7n0cyBhZEICB1FHjPeXI1rhi8ATwb1LoCWATh0cMESXD9gmjFdSG2P+ILp+Ih3F7U+VsjjaAMbIDp5CI9cjiKJZaPCO0sWYRK2Im93Q5sqvjdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979966; c=relaxed/simple;
	bh=KhAjHVnigsoBoxtMaCGmQRvOQBV0SxocYXRhfYAA4p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbx7hCWYTj6DoyAs/WPyMIISRgxJVI+/zBBsAXsrxFo5LyU/NAqTw8Ej0g7bxDU+IdWEVw2fWE2iN5fdIZWQad5NLAcyXureK0l25X1SonfRjIeiFOPOhZd1D8RuwERWK7bhRnlCLHc84OmGULFOmZBX6jRKxI7jJSDMIjKxq4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEZko0Ap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEZko0Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FC81F00A3A;
	Mon, 17 Aug 2026 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979956;
	bh=OUgRv5Hn/E3d0mDiNWvcEyk7ovx+5mr6V+vhCEEV7Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEZko0Ap2P8NiGF0vOkk8PjHfZz2acsZuuRg+dQ9ifGlttkeOEwDvzJ6VIpfMAlQG
	 Qcz71Mjt1sXIuiGD7w5rQH3k4bfHVF6QMMpF5rbA94i8R7GWdsgYvUsdLUejRk0Uii
	 kldbiU44X6/smNZ/RF+3JD1t9EwBz53wRd+KQaaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 367/609] Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp
Date: Mon, 17 Aug 2026 15:31:03 +0200
Message-ID: <20260817132556.565572521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 1da637f81db34..b5603531a9d60 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4831,6 +4831,10 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 		goto unlock;
 	}
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan)
+		return -EBADSLT;
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
@@ -4876,6 +4880,7 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 unlock:
 	mutex_unlock(&conn->chan_lock);
-- 
2.53.0



