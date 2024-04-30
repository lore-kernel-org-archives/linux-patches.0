Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7C812D1E8;
	Tue, 30 Apr 2024 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476407; cv=none; b=n5CBWu2L+QxO1K4SueF2V6vANPEmzKcakLhU0dEzWcvjXpGfqpuYlICt0W9J25FYPqZDPdWCYZ3T8BVjT4Ow/7Fmx4AuRMHMYCHmZAvZ7MUokyVEGBFo7TMmxRbqz1H0mo9piJouuY6aDVJW+d3gC9LML36GJpxe/ArX5IKWk50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476407; c=relaxed/simple;
	bh=QEFPhHXpX0XZsPTl1JL/q31MBslNvLiSo1THNsCYwd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoCoCHaQZw9G9DyVDCnQhLwX4+q1zJhmK3tOo13Xmohzo5gkBHp/MOXCmlAyWtQIZRkA7r/r9pqFqcnGF8nDCDueQC6YS4132I2lwDnF+PnZccxWr1GEIODL4XRF7oN4fOgVqCGW9/GdD7LJwL5Amu2yKAhd4hoM9hgXFfpgh7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV7XTDsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV7XTDsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B20BC2BBFC;
	Tue, 30 Apr 2024 11:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476406;
	bh=QEFPhHXpX0XZsPTl1JL/q31MBslNvLiSo1THNsCYwd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gV7XTDsgox7nm+9kWxNfpDAIanJJLpHNF2Vu2PADufI86gwb6cB+NaNh+SI5zF307
	 WUYWbKiZi1frDHb6xVM7k5zv/JRNj0EyD3bUVAJCwuIlRTHpBiQUWrIZW6/Ea21Zos
	 Ls4ApE8ux9aZ+l4qXmmPK3z2ih80i1ybANmVqTs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/110] wifi: iwlwifi: mvm: remove old PASN station when adding a new one
Date: Tue, 30 Apr 2024 12:39:52 +0200
Message-ID: <20240430103048.255023069@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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
index 8c5b97fb19414..5b0b4bb2bb684 100644
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



