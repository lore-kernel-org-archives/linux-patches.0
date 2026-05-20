Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D7272E56;
	Wed, 20 May 2026 18:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302044; cv=none; b=NflQKd1hkC5pN9Krc+6wwGvOZX/xqsXtoWcotvxEfrDyLGVi8vqAW+6e3MZcZy+DkzbQAY0Ps5+r1oD2KdpZQkB8G9jjfR/qePObMy20ICSiu+a96+ii+6atLsZVVd4PUhU1sx+61McG1/mB8O5YpQbwlBFkE3zLHJdHj2lo0Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302044; c=relaxed/simple;
	bh=lCNYRC7dZBVPDxy+Obez/3ztRDVrgj2HyokGmny8kJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiOP1vO/8D06XgX1HXQRKjiFbUrL9Cw0f+DOwQ4AepVFbQLSMuG+8GAsE1pABJX7qPxxA93f7/1s01qhW65s6zVCVELHQQVzgj80QMu+8q3Z0QOz2x3xOm7VWXeWkHTaAnbx0/g7lxoYI7/hOMAR/fWXV5m7cb/iD0Vis/p736A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZEBTO/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZEBTO/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8B51F000E9;
	Wed, 20 May 2026 18:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302043;
	bh=uz8284G7WcBEBfVwvNQho4uLEnN7S1fk43UySb3nuiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZEBTO/8oSgADNjqjXed00RLVa7hY70p/6WrxlHPkXHfbIjZtipA1YYji7Q+ZMLUD
	 GCApznKBjXBzEld1P1JYSHOt6J2UVxIi1mtEVT96bwOh5ZnN8yl5v9tAlP1BoGwWsE
	 AjdbJC95xfMhCIGVRw2Tg0IxkfFpKjvB66Lo+mPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/508] Bluetooth: l2cap: Add missing chan lock in l2cap_ecred_reconf_rsp
Date: Wed, 20 May 2026 18:18:23 +0200
Message-ID: <20260520162100.343726007@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2a15863a882d6..bbaf0070ca617 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -5400,7 +5400,13 @@ static inline int l2cap_ecred_reconf_rsp(struct l2cap_conn *conn,
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



