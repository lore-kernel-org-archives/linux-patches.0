Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ABE313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301082; cv=none; b=fCCUJjodQ7MZqRCyDM+8AlrbJ1m8i3/ZLmI8dHg1e4iC1dOPbRdghky8j43nulboDYdd5bTY0WoMjbhppofoe/F/ibF4sWj9h+mFyvuaJ142tFSZQ3C7ftBODgKBUKKT5ZW6HVC8jLODTzGjm3TAMhPG66F310EGJtgxj6dUbcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301082; c=relaxed/simple;
	bh=vGJ+ODU1O2pnF5slHFB5e8eITxNGC7zuB7JpGnFop2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJAJYYDV8xeCQFEAbiOr7UsLYgekckKTSr+nxFl2w8wbd3gnZk6PCycwchKaPBswCuZoWSiDOK85bvohIcRuJb3jmflF/mB+iD4mVJxYrVHNCOIvz92g9BXqjlD1M/nQLhQER80aDZdPNXiQUYStxGRsVnxvhiq8DFtysV+68tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euTUf+FQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euTUf+FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E8DC19423;
	Sat, 28 Feb 2026 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301082;
	bh=vGJ+ODU1O2pnF5slHFB5e8eITxNGC7zuB7JpGnFop2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euTUf+FQ8RepH8Sm/TtOF/1FOoPeFjsC7PMLfsAvP+C6gOpUTzx8A1WD+NnRrklTj
	 AM4HO2ULnQ5xTzuigE5F521m7fDcC/gzl5GckpgQFyoih6vtcsFdtPsskvJ/8Hdk3d
	 daucaTvJD03jjsvymJ1jgi6qUZAl5U/dbYKADeryrPF71Svv2+LuQZ/QI3kz/h9XeG
	 fYUTpIYhNesK798M1d3j2rbJ5vYsbglykzI7M28slp6mTnI2tQsKBEhDkhgMAZJwyn
	 UdMY4cHKZK8kPstQOdQN7czYJutKR+nXv4v6GAN3KEIBh9VLf9eXEN0w3oviTFdIpZ
	 YEksUN7NUsf4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Szymon Wilczek <swilczek.lx@gmail.com>,
	syzbot+67969ab6a2551c27f71b@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 230/752] wifi: libertas: fix WARNING in usb_tx_block
Date: Sat, 28 Feb 2026 12:39:01 -0500
Message-ID: <20260228174750.1542406-230-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Szymon Wilczek <swilczek.lx@gmail.com>

[ Upstream commit d66676e6ca96bf8680f869a9bd6573b26c634622 ]

The function usb_tx_block() submits cardp->tx_urb without ensuring that
any previous transmission on this URB has completed. If a second call
occurs while the URB is still active (e.g. during rapid firmware loading),
usb_submit_urb() detects the active state and triggers a warning:
'URB submitted while active'.

Fix this by enforcing serialization: call usb_kill_urb() before
submitting the new request. This ensures the URB is idle and safe to reuse.

Reported-by: syzbot+67969ab6a2551c27f71b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=67969ab6a2551c27f71b
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
Link: https://patch.msgid.link/20251221155806.23925-1-swilczek.lx@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index b3c4040257a67..924ab93b7b671 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -426,6 +426,8 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb
 		goto tx_ret;
 	}
 
+	usb_kill_urb(cardp->tx_urb);
+
 	usb_fill_bulk_urb(cardp->tx_urb, cardp->udev,
 			  usb_sndbulkpipe(cardp->udev,
 					  cardp->ep_out),
-- 
2.51.0

