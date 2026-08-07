Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0532D1A681E;
	Fri,  7 Aug 2026 15:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115970; cv=none; b=eBUJEGL44jIIzWye1hpGhwDRXeA+EfVD8LsPzj1GA3r047/3u1k4EdgZcyL/Don4e1/fm2yC4uAHPlI3b+3sNlR3VkK7Aa/VoFhz03ykkKbFEUikhPTiSlKhr5Q/ve2zcevfQJJVrxseoVjwNwUnHMMb96mB31PZm3tHt3YEG5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115970; c=relaxed/simple;
	bh=poP9nOq3qHsGoKUwk5ashHlmSx1LsAr3LjwIbrzJhbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csnxGrrj6LLcsx/l78vkvtgoMoZm0kz1UMQmpfe/oox1X38hMAqLZcMkCHne07ZXKotzpHoHU33YTEt4oi5OuRtT1o1G9dA8jOsWSrp+QYYTA9V5XuR7O62VNaprteLr2Jp8Dx+D44M4M0GgoqpW1uF6DQjFb+mkX9Ke34KMRmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KE9WT6Jb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KE9WT6Jb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED571F000E9;
	Fri,  7 Aug 2026 15:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115968;
	bh=jTaXOBlwtsC6ajlbxPRkNbRzo9PXIzyPkxERc+xyhb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KE9WT6Jb5F0m40tMGUW195Gb+mpXLfeLzh3HmlZsAnMGIi4kpsM5IQKdYB+ESE1Qn
	 uxcTbamPply7dy5uQaMP0EOx+XWJx3z+T3cp/ixxSQE3Pwe/gUyW1r2GQ6YYVl7l1v
	 IQJi7kMNTuSrUrk+cX5VR9i0SUGKAuoGeDuF4V1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/261] Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp
Date: Fri,  7 Aug 2026 16:37:01 +0200
Message-ID: <20260807143416.764884637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
index 792974eef47c0..9643a8aacb96b 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4779,6 +4779,10 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	if (!chan)
 		return -EBADSLT;
 
+	chan = l2cap_chan_hold_unless_zero(chan);
+	if (!chan)
+		return -EBADSLT;
+
 	err = 0;
 
 	l2cap_chan_lock(chan);
@@ -4824,6 +4828,7 @@ static int l2cap_le_connect_rsp(struct l2cap_conn *conn,
 	}
 
 	l2cap_chan_unlock(chan);
+	l2cap_chan_put(chan);
 
 	return err;
 }
-- 
2.53.0



