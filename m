Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BAA261B99;
	Mon, 18 Aug 2025 13:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525295; cv=none; b=fDM+6hKIp4AQsv6iFgo2xxNM3JnrvNnGi20ISjiLrQvX40/EBXZ3ORZvHWVyBuklZ7MQDeMl6ciLnwtxIiMcVhR+I84Sk3zGmXD5gL/KnJLw2yiXaTsVFwjeF90cBhLiY9ikUaNe8ihhvFNP5wP2pNDqhp/C/z8RIRja9v5HnlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525295; c=relaxed/simple;
	bh=66DnAOw2HrHqiZTmJQqy/QwmwxEX/6+2d6JgMdSFcFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcOC2tnHycMXkxaur0HTDoeZ7edRa9HpYeFVEC8yb/92S7TsXV/zdaFV2VI0P3BYrMTyVF5TM0czSLDlc/wWRGbd8DAvH4GKU8oFJMHyv14pEp0xNFGyj4k9R51OTvMWdN8er9gY/wlGnUldW0chrFQEm4UaTbS+M1JqFjL3PxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XglxfI0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XglxfI0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640A9C4CEEB;
	Mon, 18 Aug 2025 13:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525294;
	bh=66DnAOw2HrHqiZTmJQqy/QwmwxEX/6+2d6JgMdSFcFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XglxfI0KMvndOyqcRZHH8gVa91hWMBa/8agw7vJ3e2ZlEL3cAXPIZMO4vJFrmgjLp
	 lJM2LUGLzG6UqYqOIaVAbgXWd1wx1/LIO5IM5LWWoUYd+uN6VPvjQmmd3lFuyRf9wb
	 26ZEKpHHEXymAM6IIY/IUQovcpyD/6KxC+qT9j2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 219/570] wifi: ath12k: Correct tid cleanup when tid setup fails
Date: Mon, 18 Aug 2025 14:43:26 +0200
Message-ID: <20250818124514.241945510@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit 4a2bf707270f897ab8077baee8ed5842a5321686 ]

Currently, if any error occurs during ath12k_dp_rx_peer_tid_setup(),
the tid value is already incremented, even though the corresponding
TID is not actually allocated. Proceed to
ath12k_dp_rx_peer_tid_delete() starting from unallocated tid,
which might leads to freeing unallocated TID and cause potential
crash or out-of-bounds access.

Hence, fix by correctly decrementing tid before cleanup to match only
the successfully allocated TIDs.

Also, remove tid-- from failure case of ath12k_dp_rx_peer_frag_setup(),
as decrementing the tid before cleanup in loop will take care of this.

Compile tested only.

Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250721061749.886732-1-quic_sarishar@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 6317c6d4c043..dd26ed8d7d96 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -101,7 +101,7 @@ int ath12k_dp_peer_setup(struct ath12k *ar, int vdev_id, const u8 *addr)
 		return -ENOENT;
 	}
 
-	for (; tid >= 0; tid--)
+	for (tid--; tid >= 0; tid--)
 		ath12k_dp_rx_peer_tid_delete(ar, peer, tid);
 
 	spin_unlock_bh(&ab->base_lock);
-- 
2.39.5



