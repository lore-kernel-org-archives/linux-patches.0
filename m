Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9595234971;
	Mon, 10 Mar 2025 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627604; cv=none; b=czTFy8wFuPPywcfeXPReGI0wJLIo/030vHBTDLsoRh57L9rfc680xcPoqhN9dAE5HSQL0KZ0awwFsPqJdZ3xHKoKGj5kszbrFYGpXjHGbHeSND30a7EGSflzmZJ1dGa8WhCaKL6sMr67ykjazFH6ugVI8F8YJEhnYIPTRedqLWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627604; c=relaxed/simple;
	bh=D9Ziw+bHYeUITQfFvLxE1Mh/eVnKVcsI/AmKheCKIt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjLk7zbwLYim960Ndl8lrftndRPUQhRMn4vhJJcJ4E4el0BdJBhzS6qF2tYbt2t8ElIffd5/7jxBQRuxHwbFGg9ukOoB3XWAi+jojiaePZXwqPvVZH0U18lV9jHwDcE7Vanx48ptcK7obZq64+fbBbX0rD0TwFl8Ddphf78F93Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BApqQ8n/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BApqQ8n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59823C4CEE5;
	Mon, 10 Mar 2025 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627604;
	bh=D9Ziw+bHYeUITQfFvLxE1Mh/eVnKVcsI/AmKheCKIt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BApqQ8n/h/WAeZD+kYw9bAF5d11KrTwpydseJupSZzNone4sa3nn0MinrzCq2bexZ
	 gdNDkCzUcSK9tI2IROkZfHAYBp/KzDtjUChNkY81PbSmFamWh26Tg7mQbtm3zNDUwy
	 RX6WjnCcoT+j9R2pz+6jBvTc5pzuaIUgCKNMdVwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/269] wifi: iwlwifi: Free pages allocated when failing to build A-MSDU
Date: Mon, 10 Mar 2025 18:04:57 +0100
Message-ID: <20250310170503.456657764@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 3b08e608d50c44ca1135beed179f266aa0461da7 ]

When failing to prepare the data needed for A-MSDU transmission, the memory
allocated for the TSO management was not freed. Fix it.

Fixes: 7f5e3038f029 ("wifi: iwlwifi: map entire SKB when sending AMSDUs")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.bc27fad9b3d5.Ibf43dd18fb652b1a59061204e081f11c9fa34a3f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b1846abb99b78..7bb74a480d7f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -347,6 +347,7 @@ iwl_tfh_tfd *iwl_txq_gen2_build_tx_amsdu(struct iwl_trans *trans,
 	return tfd;
 
 out_err:
+	iwl_pcie_free_tso_pages(trans, skb, out_meta);
 	iwl_txq_gen2_tfd_unmap(trans, out_meta, tfd);
 	return NULL;
 }
-- 
2.39.5



