Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FF63D813F;
	Tue, 16 Jun 2026 18:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634602; cv=none; b=uJ0sPRPfQGJTEuWNRl8MLGsIO59QngKQoQKQy8Ouo6pJtTHNMWJxjCtkpw24x3rFN6+DLzaGlo4OBWWhfksw5UcMDTxXJs1GJPHu2pTg6xXypqv0XBcsyOkhzUJETWkdljy3JGABFvnJveB3rhhHrPe7e4dh24bzeNVMHz5faYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634602; c=relaxed/simple;
	bh=4faNniaUzROoGJkksre3TKFJfRCZ0JvLO1NiSe608f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEGImCDlXKWro2oWdDGKB5Qmvj/jbd5zI34g2Enk1J1LsCmnmjxpYGO98krmBO7KMr2eCNayu8UzOwUc/Rz9mgaRP1nJxPxHbxt9z9WAyVETu6HB5si67cqy5iOj3mIAZP2gwgZ3mHICEw2rD8BSS/md86WNCkL7pGhdLqWLzRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9mu2AJk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9mu2AJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FACD1F000E9;
	Tue, 16 Jun 2026 18:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634601;
	bh=SIq6m6FCsQVYBs2gfkbn9ldp9PsNH8Uk9MdVolBecBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9mu2AJkUQyGfReAvAs2mSdlETVHzM2vNEY+fvX9WPryBjgafW5ITexiil+IrH0T8
	 wh0GKnPW+WXYduiLy0SZa4ScbQATvFRPxiMYun4ID+M1Eb2qn4CcbijleRIYBzXBbl
	 ttZceg1JjR9shOOUleKXrgb5kO3DolI1qjuvYKN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/411] wifi: mwifiex: fix use-after-free in mwifiex_adapter_cleanup()
Date: Tue, 16 Jun 2026 20:28:21 +0530
Message-ID: <20260616145115.021300179@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hodges <git@danielhodges.dev>

[ Upstream commit ae5e95d4157481693be2317e3ffcd84e36010cbb ]

The mwifiex_adapter_cleanup() function uses timer_delete()
(non-synchronous) for the wakeup_timer before the adapter structure is
freed. This is incorrect because timer_delete() does not wait for any
running timer callback to complete.

If the wakeup_timer callback (wakeup_timer_fn) is executing when
mwifiex_adapter_cleanup() is called, the callback will continue to
access adapter fields (adapter->hw_status, adapter->if_ops.card_reset,
etc.) which may be freed by mwifiex_free_adapter() called later in the
mwifiex_remove_card() path.

Use timer_delete_sync() instead to ensure any running timer callback has
completed before returning.

Fixes: 4636187da60b ("mwifiex: add wakeup timer based recovery mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
Link: https://patch.msgid.link/20260206194401.2346-1-git@danielhodges.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ changed `timer_delete_sync(&adapter->wakeup_timer)` to `del_timer_sync(&adapter->wakeup_timer)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -399,7 +399,7 @@ static void mwifiex_invalidate_lists(str
 static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
-	del_timer(&adapter->wakeup_timer);
+	del_timer_sync(&adapter->wakeup_timer);
 	del_timer_sync(&adapter->devdump_timer);
 	mwifiex_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);


