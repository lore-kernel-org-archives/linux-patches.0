Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FF117592;
	Tue, 30 Apr 2024 11:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475787; cv=none; b=ayKwHCVxpwDQAyTNOwC7MTiLwGuwS74o8FYeAMAMk2AedB/efAMLVBYLXMPHEDG73ac9eh5gEtVY9COoh8hr0u55tO6IOE3Bb2Mqoj1Du1lEJ7/JYUIIIQQtXut5NHexVTwy4X/7JPqI8AzLcJNBaznyrMKnSNEVEBvM0yJ4C5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475787; c=relaxed/simple;
	bh=2xbi+JpBzzhV2+Y5TimVbr/vXVKetHl4XivcwCF+3kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFsIOHJd7jimJSZfNsIGWaQg/tSP8GKnJKpkvh5l7i0iw2TAXPTz4lzLiTbB/4F6Gvr3cxDSxDI6+bDYoqBfNyiVkmWF+F/38VNPkLzcqPqXJedItdpOWSG/GEG1QWX4H8Q8ey4sXXNyZ6ZzuYLHN++TXxaUKu+7VNH5mdWjpkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmhRH58u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmhRH58u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3419C2BBFC;
	Tue, 30 Apr 2024 11:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475787;
	bh=2xbi+JpBzzhV2+Y5TimVbr/vXVKetHl4XivcwCF+3kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmhRH58uQv1PHYiXkLlHqaoPLAJIurH/01+8oIwZGIinfL1h3/uge/PhUAnknaYEO
	 b67gR8x3EL8eT6ZIGiUO9Mxet6wOheh0rvPjlGfONbvHaRY25AeQAUHqsUWt63i59Z
	 aLb5gaXw+eXEemUZzOBmrsSQoCEPrUBcrCcF6Q4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/80] wifi: iwlwifi: mvm: remove old PASN station when adding a new one
Date: Tue, 30 Apr 2024 12:39:50 +0200
Message-ID: <20240430103043.952157464@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index bb5fff8174435..2dcf5a827b361 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -48,6 +48,8 @@ int iwl_mvm_ftm_add_pasn_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (!pasn)
 		return -ENOBUFS;
 
+	iwl_mvm_ftm_remove_pasn_sta(mvm, addr);
+
 	pasn->cipher = iwl_mvm_cipher_to_location_cipher(cipher);
 
 	switch (pasn->cipher) {
-- 
2.43.0



