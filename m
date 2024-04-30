Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0EA12C47A;
	Tue, 30 Apr 2024 10:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474044; cv=none; b=qp/vb3QWoJDCalCCF39z/TdVuc6oZbRc7sa/scpHhGom9lkSz2o5GXV4aVuBWj9s5azZLCNmTvUY5/ypOj3antCjbKvhHwq0+7v1I0DTdhkQMBGtDY3N+k6/42w8wL/VCOJYaYuZ4QsZTSRwClCxs8pLgE1T7bjizFgtox/+tgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474044; c=relaxed/simple;
	bh=SkySI2xn2Crk8mTJKE4Cgu8tPFt49PPWdM8p93WI/NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRFbuU9cuchUslhGTou60Ly9/JTwX8/wUwkKO9/ALghnT1iRJuDU9noS6G3Vwvr58sxYI80sRnkWikgVb4j1BrV3KiJIGIx2B21TZIxhk4EB7S/xk0tgANABDeQW9/GV4PS/3OEdYvb6067aBu5s7i/CRRFQ4B81Yoasyt+9PDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQcMSVq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQcMSVq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77836C2BBFC;
	Tue, 30 Apr 2024 10:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474043;
	bh=SkySI2xn2Crk8mTJKE4Cgu8tPFt49PPWdM8p93WI/NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQcMSVq8kbzL/HpnZ9lFlj6kntJZdKXGqbkDEDSjTHPWJHyscRBUOj8hrCfENAZ8G
	 /p0AXtf5FwwrJQHIQhiHnwkVdEPldpO+El2yv85g37nMn0iDTlBpUjjxrD30utbCjm
	 ATuf6QnIb24NcJixL3O5JdQOvfij9IIOUgeeKe2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 042/228] wifi: iwlwifi: mvm: remove old PASN station when adding a new one
Date: Tue, 30 Apr 2024 12:37:00 +0200
Message-ID: <20240430103105.028216223@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit dbfff5bf9292714f02ace002fea8ce6599ea1145 ]

If a PASN station is added, and an old PASN station already exists
for the same mac address, remove the old station before adding the
new one. Keeping the old station caueses old security context to
be used in measurements.

Fixes: 0739a7d70e00 ("iwlwifi: mvm: initiator: add option for adding a PASN responder")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240415114847.ef3544a416f2.I4e8c7c8ca22737f4f908ae5cd4fc0b920c703dd3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 233ae81884a0e..ae0eb585b61ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -53,6 +53,8 @@ int iwl_mvm_ftm_add_pasn_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (!pasn)
 		return -ENOBUFS;
 
+	iwl_mvm_ftm_remove_pasn_sta(mvm, addr);
+
 	pasn->cipher = iwl_mvm_cipher_to_location_cipher(cipher);
 
 	switch (pasn->cipher) {
-- 
2.43.0



