Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1241C3F19;
	Tue, 27 Aug 2024 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771395; cv=none; b=aYYMsXqK3ty8D2UA0VRSvmaG8rSeebWbJPxlX3AiXsUQPkt1z2T2N1HsaQSQ8TwsUvy5VxWft7wVg6n2T7Xo3DxinzTNIWenE1USklspzQAx/POBBChk23ntKVhsn4tR6TQN9/RUa2B6XPUcqtdiMuOOo/1UM3bFkP2QuqQPk+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771395; c=relaxed/simple;
	bh=GwUJq2w93gigsGsLHekhkUnoad3FehYLa9Kt71opdto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9RFLHb88RfkBG8lMnoU28McFzePpn87AfNI91z8o6Jy+lOs/B90HAy6FyytiPiuykT8lK5hpd7jiHjpeIUDE3bt3l5qvYZ0YKOUVsKuxjDuKLU58uAfe+nzGzHZXYgBhlprpokr2TFxyRiwYMkqSa1uSbkN2hhEL7ouO+9z4Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0bANJiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0bANJiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B37EC4AF52;
	Tue, 27 Aug 2024 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771395;
	bh=GwUJq2w93gigsGsLHekhkUnoad3FehYLa9Kt71opdto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0bANJiOzxdPI5ytmk0YGWfM4Ee18qlG1W4Gy3+/q8hz7kzl5UPfclUQFW2s1qS1Z
	 e5kIDZK5Smr1i2hp72PCCRvD2ljrnb5u48f4QhFJeFxvjRWSSoGDr5k39j7DvsRHxj
	 wj7heAp8ffOUNtYgSbutuj2nmf0RvDxUdw7t0A5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 176/273] dpaa2-switch: Fix error checking in dpaa2_switch_seed_bp()
Date: Tue, 27 Aug 2024 16:38:20 +0200
Message-ID: <20240827143840.109413257@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c50e7475961c36ec4d21d60af055b32f9436b431 ]

The dpaa2_switch_add_bufs() function returns the number of bufs that it
was able to add.  It returns BUFS_PER_CMD (7) for complete success or a
smaller number if there are not enough pages available.  However, the
error checking is looking at the total number of bufs instead of the
number which were added on this iteration.  Thus the error checking
only works correctly for the first iteration through the loop and
subsequent iterations are always counted as a success.

Fix this by checking only the bufs added in the current iteration.

Fixes: 0b1b71370458 ("staging: dpaa2-switch: handle Rx path on control interface")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/eec27f30-b43f-42b6-b8ee-04a6f83423b6@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index a71f848adc054..a293b08f36d46 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2638,13 +2638,14 @@ static int dpaa2_switch_refill_bp(struct ethsw_core *ethsw)
 
 static int dpaa2_switch_seed_bp(struct ethsw_core *ethsw)
 {
-	int *count, i;
+	int *count, ret, i;
 
 	for (i = 0; i < DPAA2_ETHSW_NUM_BUFS; i += BUFS_PER_CMD) {
+		ret = dpaa2_switch_add_bufs(ethsw, ethsw->bpid);
 		count = &ethsw->buf_count;
-		*count += dpaa2_switch_add_bufs(ethsw, ethsw->bpid);
+		*count += ret;
 
-		if (unlikely(*count < BUFS_PER_CMD))
+		if (unlikely(ret < BUFS_PER_CMD))
 			return -ENOMEM;
 	}
 
-- 
2.43.0



