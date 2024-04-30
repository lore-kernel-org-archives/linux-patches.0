Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF0412C46E;
	Tue, 30 Apr 2024 11:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475377; cv=none; b=rRPz6w7k5rTqb6T3VJAh5Yx70fXCWYSZrCsQ8wcdlOeOJgqhEYl3V6rqIG1LTZtT6P+0QgtrVY/e+IjTEpVU27mUyQ1aWRMNAorfTotV+MW80rUsbtNt8mRTTWdRZxntV1C9CKDJAcxmP/D1e0vD1uU1BneLyh8PkQheyFkdy/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475377; c=relaxed/simple;
	bh=lrzyqbwuRLcIlLxaqODWqG8CK6QHjl142DqTYlD50Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwBjF+60bkvY4HS0+WlEvGXQiC4C/KmPGFvEBi7Z7LC346gNa+T7YbobNmzyCGubx5aC+63kCdhE0Td+HF2yrMzazJj+QIy9qPp5UD9vXh5Edlxvk+ASdTAuUNwcdXzegSAVXNKJFZGtcz+2C3H+WYE2Nm90HNpTsMp9uMK4gT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzRvsNFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzRvsNFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008ECC4AF18;
	Tue, 30 Apr 2024 11:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475376;
	bh=lrzyqbwuRLcIlLxaqODWqG8CK6QHjl142DqTYlD50Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzRvsNFOVO4kbO3Gd9Q8ym2dfeeRj/tH+Hxxzyh72B4Z8vCi9OhBScayYGP8pt/rB
	 mLYCPMZeQkpKv/kQ+QpdbNVe8wUfQtDk54qBtynsjQ54GIHV6Qy/VMAnYpyAHYg5qi
	 d34lSCpz870bwQYphfz8PGFq2+GFoEGzTnS9y/10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/186] wifi: iwlwifi: mvm: remove old PASN station when adding a new one
Date: Tue, 30 Apr 2024 12:38:10 +0200
Message-ID: <20240430103059.136911989@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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



