Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C126B145B25;
	Tue, 27 Feb 2024 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044114; cv=none; b=fodpCDfUREQ2sb/YX4xrHDu0JiHt7NYD2xYjKilkI+r6VU56i+WmB4eAt6amAJoEXRrxip6TP/hkKmmsFZ2BEbadCQnrjP6AD8QuGZQE8t9mn2VEvsfqY+7tgcijHKmrU/grMdSxkdLg/bRkKTPBOfsDN8kCPqGKyV9ka8pagzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044114; c=relaxed/simple;
	bh=rNmrItn4QQavFu6ARBxT5/r8lSw+Jv4mGe++ef1XrEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bo2AAtY5++KuN/CfY/nHqQUQ+nZZfQK1j1ofZMlaz2d6tHLGzA1FNXPZqmdiUPX9gSQU73Ig/9lvZGGMwkkXtlhKou1TkdvxqiqZYhxPW15K7VA+MSc7r9jcCfeXU2yCFM0IzHOk/Fo94F6E73SHdwW79K3e+/zslPsRwVnBsCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePz5Wi1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePz5Wi1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1590C433C7;
	Tue, 27 Feb 2024 14:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044114;
	bh=rNmrItn4QQavFu6ARBxT5/r8lSw+Jv4mGe++ef1XrEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ePz5Wi1y0FWZUvl7wf5cPo14UEjVbR3craNv/cvDEeETBjvpTLoLcDKMaNRs951OD
	 xmHYiwj/i3cY7rh7KdtztyT7UUNnDppVrcp77bdVksDn+H2V0F4JUFIO8jNiDX+6pI
	 iGM6enRx+I3c5VUN+iA22DfRHTadNJrknmyb8cy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/122] iwlwifi: mvm: do more useful queue sync accounting
Date: Tue, 27 Feb 2024 14:27:08 +0100
Message-ID: <20240227131600.894920980@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2f7a04c7b03b7fd63b7618e29295fc25732faac1 ]

We're currently doing accounting on the queue sync with an
atomic variable that counts down the number of remaining
notifications that we still need.

As we've been hitting issues in this area, modify this to
track a bitmap of queues, not just the number of queues,
and print out the remaining bitmap in the warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.0a3fa177cd6b.I7c69ff999419368266279ec27dd618eb450908b3@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Stable-dep-of: 5f8a3561ea8b ("iwlwifi: mvm: write queue_sync_state only for sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 11 ++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 10 +++++++---
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d2c6fdb702732..f2096729ac5ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5155,8 +5155,7 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 
 	if (notif->sync) {
 		notif->cookie = mvm->queue_sync_cookie;
-		atomic_set(&mvm->queue_sync_counter,
-			   mvm->trans->num_rx_queues);
+		mvm->queue_sync_state = (1 << mvm->trans->num_rx_queues) - 1;
 	}
 
 	ret = iwl_mvm_notify_rx_queue(mvm, qmask, (u8 *)notif,
@@ -5169,14 +5168,16 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 	if (notif->sync) {
 		lockdep_assert_held(&mvm->mutex);
 		ret = wait_event_timeout(mvm->rx_sync_waitq,
-					 atomic_read(&mvm->queue_sync_counter) == 0 ||
+					 READ_ONCE(mvm->queue_sync_state) == 0 ||
 					 iwl_mvm_is_radio_killed(mvm),
 					 HZ);
-		WARN_ON_ONCE(!ret && !iwl_mvm_is_radio_killed(mvm));
+		WARN_ONCE(!ret && !iwl_mvm_is_radio_killed(mvm),
+			  "queue sync: failed to sync, state is 0x%lx\n",
+			  mvm->queue_sync_state);
 	}
 
 out:
-	atomic_set(&mvm->queue_sync_counter, 0);
+	mvm->queue_sync_state = 0;
 	if (notif->sync)
 		mvm->queue_sync_cookie++;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 64f5a4cb3d3ac..8b779c3a92d43 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -842,7 +842,7 @@ struct iwl_mvm {
 	unsigned long status;
 
 	u32 queue_sync_cookie;
-	atomic_t queue_sync_counter;
+	unsigned long queue_sync_state;
 	/*
 	 * for beacon filtering -
 	 * currently only one interface can be supported
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5b173f21e87bf..3548eb57f1f30 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -725,7 +725,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	init_waitqueue_head(&mvm->rx_sync_waitq);
 
-	atomic_set(&mvm->queue_sync_counter, 0);
+	mvm->queue_sync_state = 0;
 
 	SET_IEEE80211_DEV(mvm->hw, mvm->trans->dev);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 86b3fb321dfdd..e2a39e8b98d07 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -853,9 +853,13 @@ void iwl_mvm_rx_queue_notif(struct iwl_mvm *mvm, struct napi_struct *napi,
 		WARN_ONCE(1, "Invalid identifier %d", internal_notif->type);
 	}
 
-	if (internal_notif->sync &&
-	    !atomic_dec_return(&mvm->queue_sync_counter))
-		wake_up(&mvm->rx_sync_waitq);
+	if (internal_notif->sync) {
+		WARN_ONCE(!test_and_clear_bit(queue, &mvm->queue_sync_state),
+			  "queue sync: queue %d responded a second time!\n",
+			  queue);
+		if (READ_ONCE(mvm->queue_sync_state) == 0)
+			wake_up(&mvm->rx_sync_waitq);
+	}
 }
 
 static void iwl_mvm_oldsn_workaround(struct iwl_mvm *mvm,
-- 
2.43.0



