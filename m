Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75EC2773F0;
	Mon, 23 Mar 2026 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278634; cv=none; b=QiDFsbi8ngQW4Gis+6LnDFMjZofgHUCgTlKNfafHDp9HHfA1Rx+yD3XCzmHRY22JMCjc8NAETFJpPapRQubc3rMMcZFG+2m/8t8dRNpdbMQpZJXjGKk3+C6NUBMf3Jd6Y8Ely33jZ17hZxY+/BsxfetQ2BZjYfyR6W48K277eG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278634; c=relaxed/simple;
	bh=cUoBACioXoWfDG6t82y8lKtp7mFtVunPZ91RpRA+jag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bds6kMZU3OKFJxCCGYkzmU19Nqdb7NTcibt0vsYol8FxwyBkm8BUkdgSnWuo6anvcAdnzNk6YtXOnMxN8w05eqw6eRzbQ3OLZCu6NeHVl1Bs7i81YHe8T1VjZMOwz2gJG5dKqROA0HWwUmwd7UkPDmh7FI/S1YT0/RPrUsjE+vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCeLUF0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCeLUF0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C460C2BC9E;
	Mon, 23 Mar 2026 15:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278634;
	bh=cUoBACioXoWfDG6t82y8lKtp7mFtVunPZ91RpRA+jag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCeLUF0Hyf4+Xib/M9FGsVyu71DAaiLh/FCqwdIX/xlBu5g6aEDA9A4yfsY16P9yu
	 +MaKbDdjWy/fBP16cI36wKVXKoqWiuBqsAZFu2Un9yXpSp1dBwNZFtbfc/lVgmtXUL
	 pKA0riXe8Uo/jG3dMNojDNmXRMXD/aSfHSdQGZyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 368/567] wifi: libertas: fix use-after-free in lbs_free_adapter()
Date: Mon, 23 Mar 2026 14:44:48 +0100
Message-ID: <20260323134542.925312208@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Daniel Hodges <git@danielhodges.dev>

[ Upstream commit 03cc8f90d0537fcd4985c3319b4fafbf2e3fb1f0 ]

The lbs_free_adapter() function uses timer_delete() (non-synchronous)
for both command_timer and tx_lockup_timer before the structure is
freed. This is incorrect because timer_delete() does not wait for
any running timer callback to complete.

If a timer callback is executing when lbs_free_adapter() is called,
the callback will access freed memory since lbs_cfg_free() frees the
containing structure immediately after lbs_free_adapter() returns.

Both timer callbacks (lbs_cmd_timeout_handler and lbs_tx_lockup_handler)
access priv->driver_lock, priv->cur_cmd, priv->dev, and other fields,
which would all be use-after-free violations.

Use timer_delete_sync() instead to ensure any running timer callback
has completed before returning.

This bug was introduced in commit 8f641d93c38a ("libertas: detect TX
lockups and reset hardware") where del_timer() was used instead of
del_timer_sync() in the cleanup path. The command_timer has had the
same issue since the driver was first written.

Fixes: 8f641d93c38a ("libertas: detect TX lockups and reset hardware")
Fixes: 954ee164f4f4 ("[PATCH] libertas: reorganize and simplify init sequence")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
Link: https://patch.msgid.link/20260206195356.15647-1-git@danielhodges.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ del_timer() => timer_delete_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -881,8 +881,8 @@ static void lbs_free_adapter(struct lbs_
 {
 	lbs_free_cmd_buffer(priv);
 	kfifo_free(&priv->event_fifo);
-	del_timer(&priv->command_timer);
-	del_timer(&priv->tx_lockup_timer);
+	timer_delete_sync(&priv->command_timer);
+	timer_delete_sync(&priv->tx_lockup_timer);
 	del_timer(&priv->auto_deepsleep_timer);
 }
 


