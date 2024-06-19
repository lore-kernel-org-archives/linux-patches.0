Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A1F1442F1;
	Wed, 19 Jun 2024 12:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801916; cv=none; b=WdeSFvsMKBvHqHC89jCDMfG00KzIpQJTUwvZahFPehkdoJRoNkH5MF361pmJjoCD6ItE9PwbIdj0anN4KemXiM+8Tl3I3C0HkQ7pUucENRyn2FxFR3J6GhPVJapl2GXOeThp+kho+pT7BBDRfyxiy4qMXDisKZbQfWvXoo67tfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801916; c=relaxed/simple;
	bh=q6O7uSU6obijfaLaGMrTP0hc5sXFcDgGAZ8Rec+wE6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHA362dGvEawRzv60mCfujnqmI0Tr3ywbYp0KO1LN19eI2miphmN7bMbt1uFfcl6I5oVWxCM4+Of9CFNhkZ7os+cN8op+L/hDUkdWFVNxmSuRnLVzCmPjkXXP058nh2vUmrX1Er2kBok6iuXLvLnUMJzc55gKMO5SMOYkU9viSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHSrom74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHSrom74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BB9C32786;
	Wed, 19 Jun 2024 12:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801915;
	bh=q6O7uSU6obijfaLaGMrTP0hc5sXFcDgGAZ8Rec+wE6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHSrom74Xx4IifPm6E+mbWtHWXfHRT3qFyQ40taqxfsU631uDk+QPERFfxWELWPOI
	 JqD6g0NGzKu7Wxrlc8EPPw/VRLFglK+Y6dL8DdgzjILHYv35Jz2WhchSFOJUUh7n3z
	 UbxtXTPn7R2wa7FKJ3jjH5VjPIEyAVPArpXEPuWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mordechay Goodstein <mordechay.goodstein@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/267] wifi: iwlwifi: mvm: set properly mac header
Date: Wed, 19 Jun 2024 14:52:39 +0200
Message-ID: <20240619125606.672896842@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 0f2e9f6f21d1ff292363cdfb5bc4d492eeaff76e ]

In the driver we only use skb_put* for adding data to the skb, hence data
never moves and skb_reset_mac_haeder would set mac_header to the first
time data was added and not to mac80211 header, fix this my using the
actual len of bytes added for setting the mac header.

Fixes: 3f7a9d577d47 ("wifi: iwlwifi: mvm: simplify by using SKB MAC header pointer")
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.12f2de2909c3.I72a819b96f2fe55bde192a8fd31a4b96c301aa73@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index e9360b555ac93..8cff24d5f5f40 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -2730,8 +2730,11 @@ void iwl_mvm_rx_monitor_no_data(struct iwl_mvm *mvm, struct napi_struct *napi,
 	 *
 	 * We mark it as mac header, for upper layers to know where
 	 * all radio tap header ends.
+	 *
+	 * Since data doesn't move data while putting data on skb and that is
+	 * the only way we use, data + len is the next place that hdr would be put
 	 */
-	skb_reset_mac_header(skb);
+	skb_set_mac_header(skb, skb->len);
 
 	/*
 	 * Override the nss from the rx_vec since the rate_n_flags has
-- 
2.43.0



