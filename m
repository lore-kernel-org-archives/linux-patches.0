Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F052DD5EF;
	Tue,  8 Jul 2025 16:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992912; cv=none; b=h0Hu40Goa2ZwPbJfTCCQCykgUIVZpeDhhyhs7Ocmisu3+OJACyIBksd1jlpqYlUxezhE2757xS12tmXrLNU3z6g9CPDW4ElTxPPyV2yuTxqM7z+eQAsqFQeeG5rmqtk5up4gdCulJbVpA5jjTIvFEmbD7K79dF9j4uwFz51SAqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992912; c=relaxed/simple;
	bh=G59IFL5wwTdWrHwXnbVPU7YT+TT2q3us5AyC/gbzWK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeJfDNArNYD9z2WJj0uDEHax8zsoag5ltB7fTjHN9QOTxebG2rTQmBqlm+L0NVBEcTNUZ62IIi0zKorra8dM+L0BlIcNw96YuNG3olRVBANWKVZC6RwOmqVK+OgW6f0DYcSysBQH9P7sSJ+1eAvqkNzMgrcwSrOEvcMXAcRdneM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3qYPAOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3qYPAOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EB5C4CEED;
	Tue,  8 Jul 2025 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992912;
	bh=G59IFL5wwTdWrHwXnbVPU7YT+TT2q3us5AyC/gbzWK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3qYPAOkCwik7uD19SU0/kKR8M75RRP/vzdUTbRnd+TDSfV4Bef+JzUewhw3Dkg9o
	 rO7cMRGRrul/eWq3W3DkJSld+iJTEjN2pCj/DMBYGtFsBoMSKO5XEMUbquxvL27HK2
	 4QVo7Gkhqa5UhW1t3dyVkr/tIxRzsuISens2TJw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/232] wifi: ath12k: fix skb_ext_desc leak in ath12k_dp_tx() error path
Date: Tue,  8 Jul 2025 18:21:59 +0200
Message-ID: <20250708162244.659417818@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 28a9972e0f0693cd4d08f431c992fa6be39c788c ]

When vlan support was added, we missed that when
ath12k_dp_prepare_htt_metadata() returns an error we also need to free
the skb holding the metadata before going on with the cleanup process.

Compile tested only.

Fixes: 26dd8ccdba4d ("wifi: ath12k: dynamic VLAN support")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250122160112.3234558-1-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Stable-dep-of: 37a068fc9dc4 ("wifi: ath12k: Handle error cases during extended skb allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 734e3da4cbf19..9e63d2d97c095 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -397,6 +397,7 @@ int ath12k_dp_tx(struct ath12k *ar, struct ath12k_vif *arvif,
 			if (ret < 0) {
 				ath12k_dbg(ab, ATH12K_DBG_DP_TX,
 					   "Failed to add HTT meta data, dropping packet\n");
+				kfree_skb(skb_ext_desc);
 				goto fail_unmap_dma;
 			}
 		}
-- 
2.39.5



