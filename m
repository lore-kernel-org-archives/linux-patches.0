Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E2B42DA3F;
	Fri,  7 Aug 2026 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114955; cv=none; b=RFP9FLZsQaZzoaaysvGwO9RNMlbMmi0ALO8Dm/dIHYu3HPXvs6RYMxxVwXyvDVLrPkbU5PiTXtnUNbKdK1C1khcY9af3Vz9LhfYtTWsK0T/lZHLnDqdF/AkEkiT7wFShmsUaGMkO3vx6qebgL7QHisCTcYm2HgQGhsy8hYBEM00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114955; c=relaxed/simple;
	bh=MGSR/SNVjshH1NPLHCu8Nbp13iA8xNUKb1G/jSESgOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPTSbvOexZSEFikQCNfFpFRozv7nkzHKg9A/kz9ZDqVf+BH70+FZWqfgqZObJVLAfm2peqCf6zzMGhQPfLYK58HHQ49CtuKZ/+/KUqBTlHkFsYk5V+HCx0S6KDpjn65CQzfpK7RH3OrnxT+dpmNy6VaukVVanRIUAkOoarluvns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ab4+ycNn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ab4+ycNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4D81F00A3A;
	Fri,  7 Aug 2026 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114954;
	bh=sTyv/NWAuo+BolqzCbk8HPw99Q5XL+LhTM98EzUyFkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ab4+ycNnnm0JH582iagoGUr7GJ7mvQglBhRc68cw0+dBUzstHea4FTLBH4tEydqfX
	 ik6xkV0/6qggyP0IroHF99v9E5YJqHLmRVnbR00kgCjEX86OA8GwmjL+rZjDbBKCQz
	 p+BIFeX7adtZSS+1gf+LW65MlrM9I+TTYQClx72g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/396] Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp
Date: Fri,  7 Aug 2026 16:34:27 +0200
Message-ID: <20260807143426.602868351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
index e04948fb6832e..6133c65b20172 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4831,6 +4831,10 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	if (!chan)
 		return -EBADSLT;
 
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
 
 	return err;
 }
-- 
2.53.0



