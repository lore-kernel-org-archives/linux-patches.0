Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAB812D215;
	Tue, 30 Apr 2024 11:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475034; cv=none; b=qczPX4/hYIkoOfhXLNFCELehjfTnZVI2z7dMqLYndOFqakqebpEa/T1YAvFkmuTvwsUpFSFobLlcWamdLqr674Z6iHKpimoDKwU8Dn4vzGc03H6tzwOKrvCX64cFD75eKbAco6tUQURbmTw4wprR7RxHZFMTSJGVMnX8BRR8Q4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475034; c=relaxed/simple;
	bh=s5HtLo6wUIcDvY2GnloYrw9PZ+5JaOVRb9Mn7qGv6gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNZPQ1O4ifrID7OI4oaBKuWGWRqY0W28TOV5W3vGjoxEEhw51rwwHcG0Y7pEVB3nUV5O/WqVHaKQDXW6+h5iotabxrr1apySH09seeo9QM2CioHX63JrOVSoIFFyi942T5xzgBTrHpHiF+RYwGhlg82drPu3WfET5lJBfbJf5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYVvnrVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYVvnrVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25348C4AF1C;
	Tue, 30 Apr 2024 11:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475033;
	bh=s5HtLo6wUIcDvY2GnloYrw9PZ+5JaOVRb9Mn7qGv6gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYVvnrVKR3AYUFqfan5v+LeZbsjRwI0n3WqnZh4/38scWYC2SP6ljVsgiC7l67D5q
	 MaCD6SCHRQ9GEeOK/hvtHlx+VHiHn5IIxXnOc+Qzx/wBRqcdf+rurmhNmCr5WtGiy8
	 KeeOg/pFJG71rbag00z0GpZv8vj3tDJg66i0bj5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/138] wifi: iwlwifi: mvm: remove old PASN station when adding a new one
Date: Tue, 30 Apr 2024 12:39:29 +0200
Message-ID: <20240430103051.893656709@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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
index b1335fe3b01a2..e2df8ddc1a56a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -106,6 +106,8 @@ int iwl_mvm_ftm_add_pasn_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (!pasn)
 		return -ENOBUFS;
 
+	iwl_mvm_ftm_remove_pasn_sta(mvm, addr);
+
 	pasn->cipher = iwl_mvm_cipher_to_location_cipher(cipher);
 
 	switch (pasn->cipher) {
-- 
2.43.0



