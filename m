Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9BA3D3334;
	Mon,  4 May 2026 14:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903701; cv=none; b=T+rmovbVCHbC6h9zQYiFDfgF1Km09h7ZYd8AW3IHWQM++2DlzCIGAYFvzG6T3NgSP1JB2vV3CQ+Fe1675FlOE8j/GJvVfLi93fJFtbcTG27Sj0IUf0diDM6hlr5zy9R/GhmpMWU63S8wt967s5bRPfEhd9GbZZ0Hq8Uhmt53s9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903701; c=relaxed/simple;
	bh=282i9gPB0ICBMjp7o/VSy8fPSN+9QYR+mkd2ThR9BVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jM/q2S1Rwp2fAGJfKeWYM0E3HvsOW8cp+OAVIwqwW4k5aiBj658sMFMZoP417VmSE3v50U07/4VVA4bzSzdkhrQjiA1oCNH0TndBAAUKPvghirqqmSDBcgNcp8RFIcw8WibpImSS7MQawzBOKNabt3Qhz6oj08opsbDHclKAv4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKcJjg2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKcJjg2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02019C2BCB8;
	Mon,  4 May 2026 14:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903701;
	bh=282i9gPB0ICBMjp7o/VSy8fPSN+9QYR+mkd2ThR9BVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKcJjg2/MNe9KK/fVyyLm3ON0fI3G+xHlG5IJ350ekPW0+kCBxZcnylp2fntYaHnA
	 crXcYrtJQAPd/8mkD17kbzk1xHKh8GrV8A1VBdOuowSGpcA/LX5UhLDQzqrrHGMXUv
	 0pZf5swaf6vo8n5CJoPA44BFc64rnmJBCa91sLgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 029/275] wifi: mwifiex: fix use-after-free in mwifiex_adapter_cleanup()
Date: Mon,  4 May 2026 15:49:29 +0200
Message-ID: <20260504135144.020019749@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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


