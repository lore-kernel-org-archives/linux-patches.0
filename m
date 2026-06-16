Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB723CEBBD;
	Tue, 16 Jun 2026 18:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636362; cv=none; b=YAvx5oRu+V8zBukWqy55qtDEskT/JwbtTfeALGX2ST1WbnRcxZaFNAqSxdOtmq93dqlVcyjk7G++2G0eKuAMg7enqEVpv5qGg+sI4qK6DWezPF5/RsHApCzlMMlWqZ0R7gQMXLXZT9702kRUjQ3GdE1kipZBVgeJv3IUX9LeRDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636362; c=relaxed/simple;
	bh=bAi2QD6yzdwBvxLGWgT7Jf16jn/sP7x2DpEke4YQb18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW3blaZMv2zhP+0K42H+DwJcozE2RuJqOxkBOZ8svDsYfEgyUJWa429wVl3431568AG94LvTRIrXSjiAOKYUNMoBBZv5PNDQ/t7bbxmvgetOWfOYKkVGik0OLz9owniJbxOWk6+fxrbyaguWud4aDDoG6dQGAtrUwZXIowCncYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IM5j02Ku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IM5j02Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED36C1F00A3A;
	Tue, 16 Jun 2026 18:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636361;
	bh=UkFNMnJCvn5KxyElR/sElK+zdAqyVrJEbpWNqieAF1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IM5j02Ku/rLBqBoGNyi3wh0LGwykSnEfHW06yVSmgUhPUOTV5iMkFJ+RP3YUyHHxr
	 vX+GPzGkpWkw3Q/wKBohogqQ964s3QfhsfZZ/N46a1SGviEtBBx1M363lAMCQllt+1
	 2bCRtQFDalbaRgsyUATKLOOX6F7dOCMHb2YKLJ+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hodges <git@danielhodges.dev>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/342] wifi: mwifiex: fix use-after-free in mwifiex_adapter_cleanup()
Date: Tue, 16 Jun 2026 20:28:41 +0530
Message-ID: <20260616145058.683484480@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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


