Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9845313298;
	Mon, 13 Apr 2026 16:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098977; cv=none; b=vGo3mf2rvbYSbqHYFFdJOR0gCX8y0KiDzbT7BfTz+nGb9pHpmSI4FBnxcPXSDmIGCNuxgPxrexb8SCrgWXN9mVQunAe3m3VHNRjd1SW2XUuzoRArjBYZOxkRJ7KJHpoDi6/pZgml1AlLyiFcQeyknx7sCZ2Kui2tPxa8ZMl+aHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098977; c=relaxed/simple;
	bh=h0iQOVaSIW7tAuvolL0kGO4RiR/HFLFpvDZuNciQUgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubbyXwfEQjMqFTxoE5tOfw0Hb7T2IsQqAnWzJakfixZnOHP4DCPojnUHtaCZ6vuC+FzkMSD8L0EBnz2gPkhhtVpxbvxN74AyyER3Yy6Rex20/vUqQjAGExBt7CBDZukKD9FUzAXfVACUe+vdZ4BNu6lgueM+kHdE+fTB2AtXrVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOG2B7Kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOG2B7Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7AFC2BCAF;
	Mon, 13 Apr 2026 16:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098977;
	bh=h0iQOVaSIW7tAuvolL0kGO4RiR/HFLFpvDZuNciQUgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOG2B7KbRr5+P35kJRfuvFi14VlCv44/QwVXzo1L70gk/ouqhZ18t+gdzsUzMILfY
	 q5em6vMYn8bwQ+4QNkjVTMSmSr1yzpShYrEN76xymz8/osE6x0443nq2xIoD50+cEL
	 mD07if8ILP+YCj4NaeOIfNIxV4peYAbdFnRJP9+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/491] wifi: libertas: fix use-after-free in lbs_free_adapter()
Date: Mon, 13 Apr 2026 17:56:47 +0200
Message-ID: <20260413155825.102187063@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -882,8 +882,8 @@ static void lbs_free_adapter(struct lbs_
 {
 	lbs_free_cmd_buffer(priv);
 	kfifo_free(&priv->event_fifo);
-	del_timer(&priv->command_timer);
-	del_timer(&priv->tx_lockup_timer);
+	timer_delete_sync(&priv->command_timer);
+	timer_delete_sync(&priv->tx_lockup_timer);
 	del_timer(&priv->auto_deepsleep_timer);
 }
 


