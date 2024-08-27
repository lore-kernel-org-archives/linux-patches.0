Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A521C6F65;
	Tue, 27 Aug 2024 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772287; cv=none; b=WfsSg869UlETR4gWfY45N8pLanr64aK4v1iy/HxScDyeJY47nHabxHlvYPGQDEBJuVFlwM62jTbmkEEQG8SndIwYDXchDMV76ldDSDVhTsvNESyjM9rwq4Z7TGlsqVDgHq87y+40mf2VqRQgi7G4y4LE7SedHQC65COc2KjoK2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772287; c=relaxed/simple;
	bh=hGzSR6KCnf2uHX8OVtzrcrnVFBjRTJL3IkqX23dqejI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hn6PSzR17/hG9SqbLEPQ9fWbqNPxplRyuDQcnsKRDdGys2G9hNON+Cwj6dftFM2j5B30nb/CogRUIqNIxksK1U/Y080CkwDKhyvf+luOP+vg5PEK0zV1nwGcMkJnftjswBhyyqo88eKMsj/DG8od4N6PMfTqDKKMxx4hrCaWzIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IowDVF0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IowDVF0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A313BC61071;
	Tue, 27 Aug 2024 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772287;
	bh=hGzSR6KCnf2uHX8OVtzrcrnVFBjRTJL3IkqX23dqejI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IowDVF0JHnG22tCPC+cQkGRKSRL3vvXf3LKLyCKz9NpCFP/NrgzAxf2EiNr2/DEJn
	 ypYWqUCc9zyrIMDgBYLRoTZQWF7A21ycb1MQ3PTKEOQeawxV+YQkEvjwX8onWNLBe9
	 ZYCwQrHHIjxJkCAtOGd/3ptHVV9tB+PCnfy/EI+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/321] wifi: iwlwifi: abort scan when rfkill on but device enabled
Date: Tue, 27 Aug 2024 16:37:26 +0200
Message-ID: <20240827143843.495002841@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 3c6a0b1f0add72e7f522bc9145222b86d0a7712a ]

In RFKILL we first set the RFKILL bit, then we abort scan
(if one exists) by waiting for the notification from FW
and notifying mac80211. And then we stop the device.
But in case we have a scan ongoing in the period of time between
rfkill on and before the device is stopped - we will not wait for the
FW notification because of the iwl_mvm_is_radio_killed() condition,
and then the scan_status and uid_status are misconfigured,
(scan_status is cleared but uid_status not)
and when the notification suddenly arrives (before stopping the device)
we will get into the assert about scan_status and uid_status mismatch.
Fix this by waiting for FW notif when rfkill is on but the device isn't
disabled yet.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231004123422.c43b69aa2c77.Icc7b5efb47974d6f499156ff7510b786e177993b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 069bac72117fe..b58441c2af730 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -3226,7 +3226,7 @@ int iwl_mvm_scan_stop(struct iwl_mvm *mvm, int type, bool notify)
 	if (!(mvm->scan_status & type))
 		return 0;
 
-	if (iwl_mvm_is_radio_killed(mvm)) {
+	if (!test_bit(STATUS_DEVICE_ENABLED, &mvm->trans->status)) {
 		ret = 0;
 		goto out;
 	}
-- 
2.43.0



