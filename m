Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E3E13C3F5;
	Tue, 23 Jul 2024 18:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759804; cv=none; b=akqtK7EGuYxDzVUcHOZnu7VmWEFUSaN2elf5EazlcUR4KNZ19ul5J5AICjt2XCdP7NSxEs5RhYkYzTF4yiqt+xUADAiSx/C84C7A7BsALEe13BbX7IL63ROVxKpVCjQK9aCXXqCwBgYORi9t27UNP2i+criIH36u9uoJm0Odu9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759804; c=relaxed/simple;
	bh=6ZsVrjUYIsjw1LcUckp120ziog8bI9TMDypFtj2IXCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgoSa8fMi4SxN/AkrA1xrTdYeQeeDgScEptmd4CZRtZzLW4FCFqitZcymyYEV6jw34ep+yLAMom3cs1juBWuvrHzrQVDj/1UaXAN81OMcgGkHeZ2rXHCyXWkpUOUDo0yTUp18xtbrd/IwjYWEQMKz1zDnulX1oRjYEQueiU/R9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdOjoZCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdOjoZCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E0CC4AF09;
	Tue, 23 Jul 2024 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759804;
	bh=6ZsVrjUYIsjw1LcUckp120ziog8bI9TMDypFtj2IXCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdOjoZCUDssPE2jHhZ4OaApnRcatUIC7QiDS8Po+srbb4g4chH79AM6AvsfReEoYz
	 iT3TL2iHS9wtCVZk0MB6JnSmu5jfCtmhX+M63Va+32IcE5L4KRj6r2/6vtrCuJImXE
	 QVwZT4/xAOBLvnTlFikLChitJOy959tu5iTLc1Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 126/129] wifi: iwlwifi: mvm: dont wake up rx_sync_waitq upon RFKILL
Date: Tue, 23 Jul 2024 20:24:34 +0200
Message-ID: <20240723180409.665586638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -6094,11 +6094,9 @@ void iwl_mvm_sync_rx_queues_internal(str
 	if (sync) {
 		lockdep_assert_held(&mvm->mutex);
 		ret = wait_event_timeout(mvm->rx_sync_waitq,
-					 READ_ONCE(mvm->queue_sync_state) == 0 ||
-					 iwl_mvm_is_radio_killed(mvm),
+					 READ_ONCE(mvm->queue_sync_state) == 0,
 					 HZ);
-		WARN_ONCE(!ret && !iwl_mvm_is_radio_killed(mvm),
-			  "queue sync: failed to sync, state is 0x%lx\n",
+		WARN_ONCE(!ret, "queue sync: failed to sync, state is 0x%lx\n",
 			  mvm->queue_sync_state);
 	}
 


