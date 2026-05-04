Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831B13DE45C;
	Mon,  4 May 2026 14:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904808; cv=none; b=gzJim9iBDiI8velOcxYzGWhli4f+5KK9/2ICMlv5H3bOfBO3jubUMP1NPvnelk7FcPn0I74q0+5IIz6BLmgzCnpTYx/FRElKUZPZSxSdvBr3OBXHwWRycUNqkHlx9T5oAVdUnFOLZPsDzpsKhaRkST7Nazz3uns0oC1dctyRj28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904808; c=relaxed/simple;
	bh=+19UC6W4XD+zwmFBy5oDC87GOrO1khJFaHf39QO6CR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyHorZNC8qoase0AqfzxEUyCPo5HvjeO0wiKhTRcuAhkpi4zno9QFSsEyT7iYf7RocWIapQdOtjY+BaHoiiRnPJy8ulEatfXJA8NGUTnhQ7j5lHievGc30NDmFKpx6j019r27IkE/lw3rHY351ctED5sEZjF+8BmEF5+10DknQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlJMbDNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlJMbDNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196F8C2BCB8;
	Mon,  4 May 2026 14:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904808;
	bh=+19UC6W4XD+zwmFBy5oDC87GOrO1khJFaHf39QO6CR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlJMbDNE1DAONBXSkvA2PQfuz6wXhuDYSPlxoPwRbAV/n5GEDLsSWWF//EuIEo9D/
	 U8YlfLyIipASHmytwRkWch1lEF44/ISRNlDq1BANMdjIUdRFdlUkctug4fDm6HGiTU
	 ChJ8DXJIOqoOB0NnhdgT1Wwx8Y3btGFqlg0cGPCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/215] wifi: mwifiex: fix use-after-free in mwifiex_adapter_cleanup()
Date: Mon,  4 May 2026 15:53:22 +0200
Message-ID: <20260504135136.900213943@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
[ changed `timer_delete_sync()` to `del_timer_sync()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -390,7 +390,7 @@ static void mwifiex_invalidate_lists(str
 static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
-	del_timer(&adapter->wakeup_timer);
+	del_timer_sync(&adapter->wakeup_timer);
 	cancel_delayed_work_sync(&adapter->devdump_work);
 	mwifiex_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);


