Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B86332EA2;
	Fri,  7 Aug 2026 14:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113967; cv=none; b=aiHiPJS+u6uaRu4+/wTEOjLuVV8xSX47Gh5fL5ZVBpypOyseag+pQLzrCPf6SEsjawYKpwWukaBosMBNVO1a/E0b9kkXBdl4Bq/4vKn8F2L9rCkGJj8RCC8B9PkQvAmAnDL3RkSJYMroDyC0Vxz5W9Jtt7sHXByZY0YCqfvDFWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113967; c=relaxed/simple;
	bh=FzinT3ZrAnicJGAoqgpkpH/2CubMRSd80ZOvbDpeVz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxVM4zvP6YYl/kIWwUGfHFcdGPxhKKriXLgoxb94y2LMkcNTkk9aZh9k9PNnGcG2IeM9IUEQBOd6i/hSak4tjwUNeiMT5umcLk6lQUgO/qIzzfD7pw3fJ3NdfrDbLyDxHBXsnCVo9J8wJXKqJs03+Cz5FKwlm2XL8fKVXdNswQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntnHP4nf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntnHP4nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393361F000E9;
	Fri,  7 Aug 2026 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113965;
	bh=BByeBei8p8NlMudHrPm7oU5JCBpiYQoixs5CfPK6JD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntnHP4nfXNY9Gppa1QAAPiBhVZQI4+CDO6hbRHhTuScdlfrdmotdItGs+/qAk7m9q
	 n+qBf3dDnx3AOHO/ovsBW1tmHblmdHp205RtuU1yxfecM31yCTPDY7YAMfpCtOTcAx
	 6+BdY62Q2AcfmzHf+rohsA6t/N//7z82zQukjEO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/337] Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp
Date: Fri,  7 Aug 2026 16:35:00 +0200
Message-ID: <20260807143420.642739490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 56337f164d306..c876f986b27f5 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4796,6 +4796,10 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	if (!chan)
 		return -EBADSLT;
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan)
+		return -EBADSLT;
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
@@ -4841,6 +4845,7 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.53.0



