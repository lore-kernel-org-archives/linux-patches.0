Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FF94071FE;
	Sun,  7 Jun 2026 10:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828121; cv=none; b=XA9T2T2TgOffjHGDKILvEtUAdTCXEJIMHlUQ0ITnf6iseYpQeUJoZV/pmPeZUK5aNGjZY+fJGfHneX0kzQyE0fayRoyA4ym2mfJVLEakVHggFYYZnH22jzrv+dyZ/KV0RKYRyoWipcFqds4OAKoa5Onr6U0XLGnNisLzQVgrZMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828121; c=relaxed/simple;
	bh=ai8KPyyQgP/W6Znx3KgECmTqwdWSFqwuayhTKculkN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRdg53CkOzxmUQKOnx4kLfLfZdgl4B87R9/k0TlTYCpXZWlYiqCArhyVR39A7yXByWWw732M52cwSuM4HciGMGOGP6Im2e+EXsHSY4GTyKUVi7TKRqK3ZrEH09EXl9yrZx3sD48uuZbxqjtd4UqFWNI7LWJB0ZMHTEVxK+I5YdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZ3vXKfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZ3vXKfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09AD1F00893;
	Sun,  7 Jun 2026 10:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828120;
	bh=zbQokqNHQ3SUb1KLTdXSc/00oiwgYxlhgfgV3HOnDxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZ3vXKfEKA+5x6wdVwFVeS8KCHBJERsL+ddtmlIoUh96Fs7Ky38j0RYs6SWeQr8fk
	 11XDbo8lPHfq2QmDGKnzrvltkhqho39w4BULi0smeecO/eGTiGvi+cTamSaSYbrSvr
	 uiZGsFC6o9W4kt/9S1eTLxgPBCV2tnE9SgMbSlCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 129/315] Bluetooth: L2CAP: fix chan ref leak in l2cap_chan_timeout() on !conn
Date: Sun,  7 Jun 2026 11:58:36 +0200
Message-ID: <20260607095732.362658421@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 9dbd84990394c51f5cee1e8871bb5ff8af5ed939 upstream.

__set_chan_timer() takes a l2cap_chan reference via l2cap_chan_hold()
before scheduling the delayed work.  The normal path in
l2cap_chan_timeout() drops this reference with l2cap_chan_put() at the
end, but the early return when chan->conn is NULL skips the put,
leaking the reference.

Add the missing l2cap_chan_put() before the early return.

Fixes: adf0398cee86 ("Bluetooth: l2cap: fix null-ptr-deref in l2cap_chan_timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -411,8 +411,10 @@ static void l2cap_chan_timeout(struct wo
 
 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
 
-	if (!conn)
+	if (!conn) {
+		l2cap_chan_put(chan);
 		return;
+	}
 
 	mutex_lock(&conn->lock);
 	/* __set_chan_timer() calls l2cap_chan_hold(chan) while scheduling


