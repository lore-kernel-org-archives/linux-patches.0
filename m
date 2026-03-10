Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4932F2BF3E2;
	Tue, 10 Mar 2026 11:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141130; cv=none; b=FRvqgh/QcP3uQzP5u9TTJYoVNUzx50WhflFdVJ0l3DPDMYToAqikq5AgokBd/B0zFIDf7MYnBUTry4KVbrqJWaMP08XGtENBVBBa9Jgs7eXjvsi499RmuVMlWJhOzpgZK3ytTRzpPg+DPBhhLWN2qYjgAUKPmJs9VyPHHePY1VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141130; c=relaxed/simple;
	bh=L0wYUwMq94zzuJI06sf2BKD7vh/GWRG3SbMI2hYJ2t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxGW2Ld4NSnd2aZyHG9ZEOkpdpP+1biBJmYw13UONm4X2mqoN5O7WVN+Cl7fP4hXIjod4IeIBVNx7ITrUhVkTuto+rlODDlTZPyVceSjDmkuSgvk469G+kKxDLy6XPmAQrkYz44zY3RnPsZymdeyxYkzkpvHX55Dsjy2QftE0vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3LWKKFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3LWKKFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ECBC19423;
	Tue, 10 Mar 2026 11:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141130;
	bh=L0wYUwMq94zzuJI06sf2BKD7vh/GWRG3SbMI2hYJ2t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3LWKKFjbHM6IR0Jr1val8JEyLogrW312xkCA74BoGEpdUMVYXc+hAa6sl/LBUsPM
	 05MiANEN7jQXKASPtIquExmbpO9PiJddC21M8p9/o73ULwPLLzxWM2PNua/J51cuId
	 qAMCCrSPG+4yF0V4nZ0yyXlArrsi6W2hgvzeQ6mnvChYgxIqAPJmk+nt1h2mXquqKh
	 WT3evzn2IWZb6QbULr+1XysFA9ehIMppDQB8MEUTC1U56TXHf0fuTrmG//KD9jkgDR
	 o+zt6vp5YCK5wOVQk9eNzyJhi0XQvU6gDW2S5RiCGogz8hYQBtGMjUtZ2myFD+3j0l
	 /ax5/VgDVhMHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 133/311] wifi: libertas: fix use-after-free in lbs_free_adapter()
Date: Tue, 10 Mar 2026 07:03:00 -0400
Message-ID: <26bbf4bb176d1382f46029699efdabe00bf3cb30.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Hodges <git@danielhodges.dev>

commit 03cc8f90d0537fcd4985c3319b4fafbf2e3fb1f0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index d44e02c6fe385..dd97f1b61f4d1 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -799,8 +799,8 @@ static void lbs_free_adapter(struct lbs_private *priv)
 {
 	lbs_free_cmd_buffer(priv);
 	kfifo_free(&priv->event_fifo);
-	timer_delete(&priv->command_timer);
-	timer_delete(&priv->tx_lockup_timer);
+	timer_delete_sync(&priv->command_timer);
+	timer_delete_sync(&priv->tx_lockup_timer);
 }
 
 static const struct net_device_ops lbs_netdev_ops = {
-- 
2.51.0

