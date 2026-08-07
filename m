Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B423C35677E;
	Fri,  7 Aug 2026 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116895; cv=none; b=tj2k5l8KM/SbFIE5pC1sivV5ZFErRFfMrLgvYbi7M6Vm0LnnvVtanjhTOtpfVZlzzFbD+6NSiD/Udz7SSVLcjIMUoZ+gpmMIKEb4xg47R0/H/Nj6yJhAurX0rzPN7ZwRW7SkjyWcneBeSQ3acQQkTORTjhTh+HhfymxPYlhf1/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116895; c=relaxed/simple;
	bh=auFYja0wObxIe6XBSU6+QDdH8uLGyfwaAXmexa07D0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAEFpt+xtLnfqLLMWLrep31D7UL7lueZIg141gPgsNN8GlKSqThOF3qOJSCjBZLnBJG3qHuodc+8VjbIrt+AdUa8LIkOjZ7kq6jYUyg5xhNT0OOX9NneP7wHOWc4WLhVaDJs4+E7EskmFZ96tyQj0L5rLI1zRtVEt6btCx7wWNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wd/5fqua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wd/5fqua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0AF1F000E9;
	Fri,  7 Aug 2026 15:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116894;
	bh=bSobyqOjOqumA4iZRXLWnjf9u+EG+A1VqY2sraBhFWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wd/5fquaDtiyCGoQNIKEVs7bIqjJI52CpZHWT6QAXn9slrOFxVsUBACkhGJ8NrjC2
	 SSuavlkAq4ZIR8+aV9o+3vPWfNlgCjwoM8f7iJiODSG2u3jybe5A6CRiSRhaGKRdA/
	 SEpVcTnI1k6mnSUpz2SkkvNbyLhDjK4F11A7F8Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 129/438] Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp
Date: Fri,  7 Aug 2026 16:35:25 +0200
Message-ID: <20260807143430.744695476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 189085000c73b..6585f08fe4a14 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4823,6 +4823,10 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	if (!chan)
 		return -EBADSLT;
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan)
+		return -EBADSLT;
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
@@ -4868,6 +4872,7 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.53.0



