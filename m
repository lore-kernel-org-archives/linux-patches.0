Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF267482;
	Mon, 23 Jun 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713665; cv=none; b=Xvg8t5k+13MlrS+B2U35x+zmdDpZGir3DrcVy88e5b/II3sxZQgL9FHouPbn4P75ZMLiixzWbAhAoci16KTruYvZhB0OysOesYfN+9HTwPnSL4hCPyCbyNq5QWEzQySvwp7U79oiVellrWwm2ig4odroELSC5qnSTNE2bDfuZP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713665; c=relaxed/simple;
	bh=KVnQYg4Bqwo5e157pBVvAup1OvS6FcqwXGYYkJAovk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxaxVX9RJFItqINogw465vQiU9cmVTbeYzCU205d6wGEVINME55WjLSKhPTwaQxB9iVWTbLYd3Y5ttb+hjeNMmYSgoy8315RWyvbr9/ou4LmIzevx1XldlHxdckzis8GDOTdPPcsY7h+4g69DpEoSbdJyrTUsn/2Rl87jWRFc0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vghMGVpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vghMGVpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C00EC4CEEA;
	Mon, 23 Jun 2025 21:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713665;
	bh=KVnQYg4Bqwo5e157pBVvAup1OvS6FcqwXGYYkJAovk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vghMGVpWZK9lE+IIq32KkSbzptsm6Iree5Rq0cVyR+QjRsyjsmy2gHvg9mBCkcoBy
	 swzREXYcPLoid1Uwm0RedNCbcDTHaYBRbnOpOVxz1bvHNkPvN7cPd/Z2evoYtokxTQ
	 GFdToC+bumui/rGBsVEFg9UZHvKdIkxArIsFGbyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 340/592] wifi: ath12k: fix a possible dead lock caused by ab->base_lock
Date: Mon, 23 Jun 2025 15:04:58 +0200
Message-ID: <20250623130708.539642560@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit ef115c265a21e3c11deee7f73bd1061775a7bf20 ]

spin_lock/spin_unlock are used in ath12k_reg_chan_list_event
to acquire/release ab->base_lock. For now this is safe because
that function is only called in soft IRQ context.

But ath12k_reg_chan_list_event() will be called from process
context in an upcoming patch, and this can result in a deadlock
if ab->base_lock is acquired in process context and then soft
IRQ occurs on the same CPU and tries to acquire that lock.

Fix it by using spin_lock_bh and spin_unlock_bh instead.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250418-ath12k-6g-lp-vlp-v1-1-c869c86cad60@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index fe50c3d3cb820..22f21ecc8f235 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -6019,7 +6019,7 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 		goto fallback;
 	}
 
-	spin_lock(&ab->base_lock);
+	spin_lock_bh(&ab->base_lock);
 	if (test_bit(ATH12K_FLAG_REGISTERED, &ab->dev_flags)) {
 		/* Once mac is registered, ar is valid and all CC events from
 		 * fw is considered to be received due to user requests
@@ -6043,7 +6043,7 @@ static int ath12k_reg_chan_list_event(struct ath12k_base *ab, struct sk_buff *sk
 		ab->default_regd[pdev_idx] = regd;
 	}
 	ab->dfs_region = reg_info->dfs_region;
-	spin_unlock(&ab->base_lock);
+	spin_unlock_bh(&ab->base_lock);
 
 	goto mem_free;
 
-- 
2.39.5



