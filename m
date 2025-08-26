Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F35A1ACEDE;
	Tue, 26 Aug 2025 12:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213119; cv=none; b=tUDR+MO1V6Ex6OdvCqo+EKzCZIhJDLRi/x1Iu4w6jzGDeaGcb91f1T8feKp5KmDw0MG9wMuZPVnP5PKt2pKZSC1Izt3RShOGitMoIeEDpea+EqW1CfQ5C3joOP4pLTq3wSgS3l9sX7uUSl1TIhaG/YzTa6pdchD/yAe8lGHAKhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213119; c=relaxed/simple;
	bh=KpVQWMBhVzHad28DTvpVFL0Dlcsdefw3ENmVwzyGE7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4of43srgF7YYIGUTD3VSVoSEGrs0OAMFkY9sfIOeHIAPkR+LUkUNIHGaE8s+0qM9Q5eD09A3I1avWJ+2HigUna2swpgFQgTSn1QST2FXi/y9Z+ROzLgZu2sCCRJheH3l/4TUl91oL8GVsR/fwFihuZn1eOyaQTnZMV2ge7+hyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wk1Nv11o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wk1Nv11o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F6DC4CEF1;
	Tue, 26 Aug 2025 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213119;
	bh=KpVQWMBhVzHad28DTvpVFL0Dlcsdefw3ENmVwzyGE7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wk1Nv11oyA8Cshe9lS1VYCGeIS242tofmnZyDuE1NhLsS5qKc0I3uW4yb7QkhnxMo
	 Sh56yPAXc3prY4UyOwlAE25GYgNCmmu8ZrEOBZkraq9P/cPXzuP6dT+DnLuwMP3/HY
	 50B+m8ixhzC/2oyEq8ToI7dfOwhOhUIZbmwMWL54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/587] wifi: ath12k: Decrement TID on RX peer frag setup error handling
Date: Tue, 26 Aug 2025 13:05:36 +0200
Message-ID: <20250826110957.698858818@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>

[ Upstream commit 7c0884fcd2ddde0544d2e77f297ae461e1f53f58 ]

Currently, TID is not decremented before peer cleanup, during error
handling path of ath12k_dp_rx_peer_frag_setup(). This could lead to
out-of-bounds access in peer->rx_tid[].

Hence, add a decrement operation for TID, before peer cleanup to
ensures proper cleanup and prevents out-of-bounds access issues when
the RX peer frag setup fails.

Found during code review. Compile tested only.

Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250526034713.712592-1-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index c8777ee2079f..c918f5d12975 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -74,6 +74,7 @@ int ath12k_dp_peer_setup(struct ath12k *ar, int vdev_id, const u8 *addr)
 	ret = ath12k_dp_rx_peer_frag_setup(ar, addr, vdev_id);
 	if (ret) {
 		ath12k_warn(ab, "failed to setup rx defrag context\n");
+		tid--;
 		goto peer_clean;
 	}
 
-- 
2.39.5



