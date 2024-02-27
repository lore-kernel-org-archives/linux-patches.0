Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0502D1420B3;
	Tue, 27 Feb 2024 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044120; cv=none; b=nB56YlONaVgHvE062yX53CyyqRbHy48T1icIj8YrqbqlCAoF/kR9PhoR7k5ppXdK4Tjf6ETxsSU6JPVuEFfwTcG9gp4HKJXyTP/cXvMzc3rgp185AUuwHip9VoU2ONFsT9z85SecBCLZXoALSSG+XfQPrq6pX9JL3EhzNbzTJg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044120; c=relaxed/simple;
	bh=r5NhY1zyJJUuwQsXNl44pXkOaL9f3s5cN1q4S4IDLc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFTvpX7xTWgW1BZni6vFjNuuJEwapVErdgP+sqIJEqbNNq28zcd+bs5WPXW3fu3WAQ2lMTsqyrWG9TW7FCZI6IqX5ihdkG5bFrGUIQfeljuPjnRw7DPRntOa2bx+ZjFK7H/Ld5SwJZjmeEjA/Dpn+mFERGTNS4iho/ItBj0lDAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MF4qqxDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MF4qqxDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878B3C433F1;
	Tue, 27 Feb 2024 14:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044119;
	bh=r5NhY1zyJJUuwQsXNl44pXkOaL9f3s5cN1q4S4IDLc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MF4qqxDg4o6FNXJsvBxep82129fjmg1sNRh36lOn2s4VgPgBlUgBbga6E8rvDuwKE
	 JOiONdsy11tPAWkWwSjXKBAnZOZqCoj3hWEJr3vxVqdhM7PwEtRvzDhtq3oQq4NtVm
	 iCKMSvQAza4CfdpXzzPWBoDGmG7O0+lk5ouEw86w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/122] iwlwifi: mvm: write queue_sync_state only for sync
Date: Tue, 27 Feb 2024 14:27:09 +0100
Message-ID: <20240227131600.926898633@linuxfoundation.org>
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

[ Upstream commit 5f8a3561ea8bf75ad52cb16dafe69dd550fa542e ]

We use mvm->queue_sync_state to wait for synchronous queue sync
messages, but if an async one happens inbetween we shouldn't
clear mvm->queue_sync_state after sending the async one, that
can run concurrently (at least from the CPU POV) with another
synchronous queue sync.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210331121101.d11c9bcdb4aa.I0772171dbaec87433a11513e9586d98b5d920b5f@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f2096729ac5ac..08008b0c0637c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5177,9 +5177,10 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 	}
 
 out:
-	mvm->queue_sync_state = 0;
-	if (notif->sync)
+	if (notif->sync) {
+		mvm->queue_sync_state = 0;
 		mvm->queue_sync_cookie++;
+	}
 }
 
 static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
-- 
2.43.0



