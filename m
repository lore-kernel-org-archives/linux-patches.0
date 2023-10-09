Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFF41A5BA
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eohbwcXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672F9C433C7;
	Mon,  9 Oct 2023 13:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857994;
	bh=nJQc2Pn7MIuB7R067MA4zwqMnUlEs3eQDPmFgp8DtOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eohbwcXAzXAe4Prw8KvltfPObrKAr/mkkrQt7/zaamjdgViWvuNoNSmaYk2Tzeo2Q
	 mS88hZsmWyMh96TPNpWnO6ZwX2k3/nmKu/ZSVWGClL1/rUM7dZssfJnBaVD7BVcACI
	 x2TQ5Urgw2QnkWnoNZWXdfj5mcData7V6AzOvsok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/75] wifi: iwlwifi: mvm: Fix a memory corruption issue
Date: Mon,  9 Oct 2023 15:01:54 +0200
Message-ID: <20231009130112.359963070@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8ba438ef3cacc4808a63ed0ce24d4f0942cfe55d ]

A few lines above, space is kzalloc()'ed for:
	sizeof(struct iwl_nvm_data) +
	sizeof(struct ieee80211_channel) +
	sizeof(struct ieee80211_rate)

'mvm->nvm_data' is a 'struct iwl_nvm_data', so it is fine.

At the end of this structure, there is the 'channels' flex array.
Each element is of type 'struct ieee80211_channel'.
So only 1 element is allocated in this array.

When doing:
  mvm->nvm_data->bands[0].channels = mvm->nvm_data->channels;
We point at the first element of the 'channels' flex array.
So this is fine.

However, when doing:
  mvm->nvm_data->bands[0].bitrates =
			(void *)((u8 *)mvm->nvm_data->channels + 1);
because of the "(u8 *)" cast, we add only 1 to the address of the beginning
of the flex array.

It is likely that we want point at the 'struct ieee80211_rate' allocated
just after.

Remove the spurious casting so that the pointer arithmetic works as
expected.

Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/23f0ec986ef1529055f4f93dcb3940a6cf8d9a94.1690143750.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index f347723092eee..d22a5628f9e0d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -686,7 +686,7 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm)
 		mvm->nvm_data->bands[0].n_channels = 1;
 		mvm->nvm_data->bands[0].n_bitrates = 1;
 		mvm->nvm_data->bands[0].bitrates =
-			(void *)((u8 *)mvm->nvm_data->channels + 1);
+			(void *)(mvm->nvm_data->channels + 1);
 		mvm->nvm_data->bands[0].bitrates->hw_value = 10;
 	}
 
-- 
2.40.1



