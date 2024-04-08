Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD5C7BB15;
	Mon,  8 Apr 2024 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584952; cv=none; b=eBzzI6r8trnzWoXHr75QkkgBN/YYGJmXjf9Crd+ijyG4P3B5U4AbDTU90yGZJEcc1rZo+lm2lU4e1NXCPhIbBdSFVG+DPuoONpLnab1oytJFdtMwQRvGiKQ43qkqu0Wv/VKF8+AoxHY5JmYZH0fVXEM4iE9SB50dUYnfTksKOfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584952; c=relaxed/simple;
	bh=Z0n5p4lopmJpkFf9/AOTCs1SEh6M9Js9G5JFdQ+UiiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIQeWrRwlwmYsDaJoFRQ/vjsdKWji+cv52znl6Es786rBcYwPOQoImrg+EYoMUCVqlhd84fA3PgbtxeS39xKgUVgfZimjYl6M8bjsEKyZT3nDoUwhDM943J1KMZk5Jb7ySkVIdYxqAAlZ77yxvUQDSvxI3bpgMldB8+K5AfQ35I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjUBnLFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjUBnLFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D55C433C7;
	Mon,  8 Apr 2024 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584952;
	bh=Z0n5p4lopmJpkFf9/AOTCs1SEh6M9Js9G5JFdQ+UiiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjUBnLFNQ/hAuGS+p6bYHydJfeRZ4kIDHGCnNGScdClh1Hf/+v5O4YuAoZiaBASXL
	 hrpZ/GKTs76UXn76dQE6MhlrPfHSHfqnsb+h0p5pm9KEPK7pPy+6kHQFeKwn/GAeFI
	 hcYrUeT+geoPy1Kcyd92oBYweKVNnJwRMDnj+IMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bixuan Cui <cuibixuan@linux.alibaba.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 611/690] iwlwifi: mvm: rfi: use kmemdup() to replace kzalloc + memcpy
Date: Mon,  8 Apr 2024 14:57:57 +0200
Message-ID: <20240408125421.735586835@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Bixuan Cui <cuibixuan@linux.alibaba.com>

[ Upstream commit 08186e2501eec554cde8bae53b1d1de4d54abdf4 ]

Fix memdup.cocci warning:
./drivers/net/wireless/intel/iwlwifi/mvm/rfi.c:110:8-15: WARNING
opportunity for kmemdup

Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
Link: https://lore.kernel.org/r/1635317920-84725-1-git-send-email-cuibixuan@linux.alibaba.com
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Stable-dep-of: 06a093807eb7 ("wifi: iwlwifi: mvm: rfi: fix potential response leaks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
index 44344216a1a90..1954b4cdb90b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -107,12 +107,10 @@ struct iwl_rfi_freq_table_resp_cmd *iwl_rfi_get_freq_table(struct iwl_mvm *mvm)
 	if (WARN_ON_ONCE(iwl_rx_packet_payload_len(cmd.resp_pkt) != resp_size))
 		return ERR_PTR(-EIO);
 
-	resp = kzalloc(resp_size, GFP_KERNEL);
+	resp = kmemdup(cmd.resp_pkt->data, resp_size, GFP_KERNEL);
 	if (!resp)
 		return ERR_PTR(-ENOMEM);
 
-	memcpy(resp, cmd.resp_pkt->data, resp_size);
-
 	iwl_free_resp(&cmd);
 	return resp;
 }
-- 
2.43.0



