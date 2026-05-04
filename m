Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098BF3DC4AB;
	Mon,  4 May 2026 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903005; cv=none; b=EsmipADZ/oBkthHWTRNLJfOFPmkU1kzT3aLkXwlnPxAKIR9TGYisJRU3vgWkQuE2cIz2wD2A6JMmUklIxZIkf0nsJj3NG2BWvq4BZI5iIIXKSp3snEsVkZVRxSISWfX3jiugAXmhNZrg4cki966XbP1kaLVAzokQTvxvePLqnsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903005; c=relaxed/simple;
	bh=f0rFnf0OCZBzDyWNFHPMB3Ic3aKTiiUC4TNfErJUMOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1z/NWKc30v9lNDyWmj3bvciMEFwoMnf8tzlIXlzOS1hXTj/UbuQNdOgR3uW6gJW88lMCJC2WoJKbvWcTPzHgD+ZOy/bYL2h87r0H+8h632zxKBYMIDN8vjtlyUzjpyD7UiFqT/9Z3g3hcSvoDw1uU7aIE0pJ19JGb4oXOUbemg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKrjjRWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKrjjRWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94336C2BCF6;
	Mon,  4 May 2026 13:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903004;
	bh=f0rFnf0OCZBzDyWNFHPMB3Ic3aKTiiUC4TNfErJUMOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKrjjRWW2myKggOdYe3xfzUUaZFqneKYa6EnTJvS9w5tHXXKrf5RSN0zs/WcQ+q+M
	 eEBj9QZzZ77jFI0DzxY5EByvO3fy/K+hBvj8Ko0sIwdKWtVOJnArpFVrGVR9bQgwxk
	 h9dz7m3K+7ABu1NLeX4l/c9kT574Uoi86kCVP9G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.0 034/307] wifi: mwifiex: fix use-after-free in mwifiex_adapter_cleanup()
Date: Mon,  4 May 2026 15:48:39 +0200
Message-ID: <20260504135144.111167217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hodges <git@danielhodges.dev>

commit ae5e95d4157481693be2317e3ffcd84e36010cbb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -391,7 +391,7 @@ static void mwifiex_invalidate_lists(str
 static void
 mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 {
-	timer_delete(&adapter->wakeup_timer);
+	timer_delete_sync(&adapter->wakeup_timer);
 	cancel_delayed_work_sync(&adapter->devdump_work);
 	mwifiex_cancel_all_pending_cmd(adapter);
 	wake_up_interruptible(&adapter->cmd_wait_q.wait);


