Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F074415884E;
	Tue, 23 Jul 2024 18:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760273; cv=none; b=sSCdNV0IdIRWT3RxTEjX85MQUVP6Tum0OC+jLgKEOXRz1Ti0KLs8aBnqlcT7BgvnD0Ql4mVoVllYkepWoS5hwgsfrROprICVPpsjW6V76DvjR24NoxoWPemosKpS2csfQmeNSwBlLt5cofmu2UYK49cLlyHz/LHHcDFhUlxvpKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760273; c=relaxed/simple;
	bh=1i9+KGAJZnGG5VukdjddR3J6+DWsQjCIH1VJdM54XWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaHR5Nf2OZra+ahTamANFNMTCbrxmmOkHYPjwo5iitojyhu4DTAXPqQNHMW7yZ98X6JQgeWq+T5Mh90IQzE5mFM1ms7m8N7EHXWAZNFYHGKzdCKzfEHlbatr2nbnjYigUM5rnzPZ6gfkZvojYZ/ZOATK45dUrhMC484kUs2yIdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNRYXIp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNRYXIp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77410C4AF0A;
	Tue, 23 Jul 2024 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760272;
	bh=1i9+KGAJZnGG5VukdjddR3J6+DWsQjCIH1VJdM54XWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nNRYXIp0Sm0sCrRPrebfmzNIuhszwV5Z9A7aV2ISwG6THk3qht+pVHrnGazrO4a3G
	 qqIN8kwwOvffe5oUmoNFymAt1lyKIFiMVnp49IvTp0qvhLp9YIvEwVDTmoPKrQjIx3
	 /50CN+80DhVzzhPolJLL66sYgPJZ6auVZ6bPuKw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.9 160/163] wifi: iwlwifi: mvm: dont wake up rx_sync_waitq upon RFKILL
Date: Tue, 23 Jul 2024 20:24:49 +0200
Message-ID: <20240723180149.652896617@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit e715c9302b1c6fae990b9898a80fac855549d1f0 upstream.

Since we now want to sync the queues even when we're in RFKILL, we
shouldn't wake up the wait queue since we still expect to get all the
notifications from the firmware.

Fixes: 4d08c0b3357c ("wifi: iwlwifi: mvm: handle BA session teardown in RF-kill")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240703064027.be7a9dbeacde.I5586cb3ca8d6e44f79d819a48a0c22351ff720c9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |    6 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -6189,11 +6189,9 @@ void iwl_mvm_sync_rx_queues_internal(str
 	if (sync) {
 		lockdep_assert_held(&mvm->mutex);
 		ret = wait_event_timeout(mvm->rx_sync_waitq,
-					 READ_ONCE(mvm->queue_sync_state) == 0 ||
-					 iwl_mvm_is_radio_hw_killed(mvm),
+					 READ_ONCE(mvm->queue_sync_state) == 0,
 					 SYNC_RX_QUEUE_TIMEOUT);
-		WARN_ONCE(!ret && !iwl_mvm_is_radio_hw_killed(mvm),
-			  "queue sync: failed to sync, state is 0x%lx, cookie %d\n",
+		WARN_ONCE(!ret, "queue sync: failed to sync, state is 0x%lx, cookie %d\n",
 			  mvm->queue_sync_state,
 			  mvm->queue_sync_cookie);
 	}
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1854,12 +1854,10 @@ static bool iwl_mvm_set_hw_rfkill_state(
 	bool rfkill_safe_init_done = READ_ONCE(mvm->rfkill_safe_init_done);
 	bool unified = iwl_mvm_has_unified_ucode(mvm);
 
-	if (state) {
+	if (state)
 		set_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
-		wake_up(&mvm->rx_sync_waitq);
-	} else {
+	else
 		clear_bit(IWL_MVM_STATUS_HW_RFKILL, &mvm->status);
-	}
 
 	iwl_mvm_set_rfkill_state(mvm);
 


