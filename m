Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062751;
	b=o49t55PI9jgfFCOOBRIgcri4lYsyWdpQNhGNOTETLAeLxvfRVcZiPI7Bt2vxqqeXiyZB
	 bjf70cpAJsb1KAp/vjJ5468Wovhvj7z5pFYJtugYn/rThEOWvGTqayU278deQDJIERRya
	 alfF7ZtR906jRyf2Jxyd4B5JSC2RvSaV10z6yb9nlUiLmca1/aqC0/IU+F6loHiGM6L3i
	 pIwQfY8H9iSv+3Am/n2qt0sBPTwSEa+ix34CXwZFGrQt+KxvuVy6ncswMK/LkZukf5HVo
	 DbyauGYUPFCjuTTG2jfJAfgkhTv5iFhSX2J7S97A6C049nsnihY/NbGdDSpexQM1FGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyAXXOA87VRmh5a8BYaQfJ6s2Xlq/veDA2wBHcAZ9dA=;
	b=t4sHnEr3vZPItGPglJ2MXwYud1CuWzvmQ+5Tuulmki3F0JwFkFBX6w4y0xGy+xFkMs45
	 11w/kTWFovRcWRp1uQhQtqT9SedOg/iZ2LScoM2pgxoFcUqWXfpJv3M0SOWukNEnK22vW
	 grZB+IekRZAgQWOhlVGEtAE1imVR+2OO5w4uphBTdXFLgtuJdSl/apyFK08AA/mwlABFM
	 KSe3WV+dmm9W2crufg/c1UJ+V7TaDXQYHEjrWdyZl4vbq/Vw00/v2J456oqkbccz4FzYC
	 gVm+yUbrqQve04qSY1vPVm2lzHO/2SX6taUq6Uyi6ubBeaSYeHw9md7MGJ6dsScysVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oC+d+h8s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E297F606A32C;
	Sat,  7 Nov 2026 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oC+d+h8s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7E41F0089F;
	Sat,  7 Nov 2026 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062750;
	bh=xyAXXOA87VRmh5a8BYaQfJ6s2Xlq/veDA2wBHcAZ9dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oC+d+h8sWB2WyD6kohdQjOusTQUAo/vlZZ3Nhm3XMy4ilB92t4Bf3xV3WaIONf1w6
	 nBryKGbfylLUxCEWh3qVviOnkW442+9PmqseERna+5Sp+82aiGq56HHJxNNGOCIluP
	 sJM9Pkqgi5k5ckHLir7e0Q/lpWj8VCvVwNg0NBAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/869] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Sat,  7 Nov 2026 08:45:46 -0500
Message-ID: <20261107134854.477505635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 6132d70d0890c03546f6970893fd71938efb2a2f ]

In ath11k_dp_srng_setup(), the memory allocated for
ring->vaddr_unaligned is not freed in the error paths that follow.
Fix that by calling ath11k_dp_srng_cleanup() in those error paths.

Compile tested only. Issue found using a prototype static analysis tool
built on the LLVM compiler infrastructure.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260801114911.91483-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 68c7ef190780a..5e67f088962e5 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -316,6 +316,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 	case HAL_RXDMA_DIR_BUF:
 		break;
 	default:
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "Not a valid ring type in dp :%d\n", type);
 		return -EINVAL;
 	}
@@ -327,6 +328,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 
 	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
 	if (ret < 0) {
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
 			    ret, ring_num);
 		return ret;
-- 
2.53.0



