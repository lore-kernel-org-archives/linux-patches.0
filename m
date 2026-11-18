Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054846;
	b=IiQoekoHyqqZMUpkWGXy6aZ2sbxr4tWXFrEu5GaDNKiCdfSsPqqzIVCLuRI5188HWXI7
	 O+uZ8boHWETgTFq8eKJhKFceRtfnTlYGOuhGITV4x7hCYfjkzEZjR0oPCPDX0KQQjQWO/
	 AZxakO0JwpeDXo63dk2bFmUMMTwtXLG/iFx/339lk6ZVFCP4t024pL3dx+mP6vXPpG/JD
	 47xlrv97alm6NNBuOg6alyhORuaSl9NUz1zpfFnUSob6NxwQQnSyqPunlBAajTGpN8ZKP
	 OXhD778vAUltnR5GCdfEQpErRuPH/zT7fXjqRoAF3Va3F3YPgAuxFJhYALSZeA/s05Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yzMfmtcPCdKSZYqdrNNofMGSNtQKBcu1agJTwk/WcOs=;
	b=yYoIheRfOc5jULa04RXB7a9ciM1LF+gcfKu/va4MyJoU8bx965iN9mjIiZbZDbhMlC/h
	 0KzvTYH7eNHXUVLbm1kD7WONlT6ClaoWVtYkyTpr4Pb9+ZS6AdJYuMZrhFpsphechAoMR
	 PtqXwQDDXMF3W5Y9IetLyCO8RYyL7ge1+b0BtZOouJToC9dPdn9RtqOIbCRy8D83LSglR
	 Epi53RDJyJ0HSEnhenQdMVghiiT+mCU67V41pxPi8JnEo5Xyj1mrK8tivTDzBo1jCsfUi
	 eoKRHk0tCjt+GEgkPqO78rYTOT7p5e2Xv1f8oKfhruRX39lvbbW+Q/BiHa2KN7R/S4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mJ4xjY+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525F606A320;
	Thu, 19 Nov 2026 02:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mJ4xjY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713F81F000C4;
	Thu, 19 Nov 2026 02:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054846;
	bh=yzMfmtcPCdKSZYqdrNNofMGSNtQKBcu1agJTwk/WcOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mJ4xjY+x7Um5FGgyEXfNcyjzEx8vGgf9M9bp4i3Zj5XiqND1987zpPMRAuPKCT8b
	 Ns+Y+kLLFom9aGPU5Jy+xLYEqzSoc70k2elqrkcIqgos71KW4cYSASgJzwn0jEjevt
	 ZbO3pmCg47Zq5L3b+pe4UwtV1fFT1vA5hrA759R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1379/2214] dmaengine: fsl_raid: dont invoke client callback under desc_lock
Date: Wed, 18 Nov 2026 15:50:55 +0100
Message-ID: <20261118150106.542016768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 62c267ce97444f8a381f2bb3cd5d534eb362c540 ]

fsl_re_dequeue() holds re_chan->desc_lock while calling
fsl_re_desc_done(), which synchronously invokes the DMA client completion
callback via dmaengine_desc_get_callback_invoke(). If that callback
submits new work (e.g. fsl_re_tx_submit()), it tries to reacquire the
same desc_lock and deadlocks on the spinlock.

Collect completed descriptors into a local list under the lock, then
release the lock and invoke the callbacks before moving the descriptors
to the ack queue.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260718053010.3074329-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index fdf3500d96a9e..562a3a3f75f16 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -161,6 +161,7 @@ static void fsl_re_dequeue(struct tasklet_struct *t)
 	struct fsl_re_hw_desc *hwdesc;
 	unsigned long flags;
 	unsigned int count, oub_count;
+	LIST_HEAD(completed);
 	int found;
 
 	fsl_re_cleanup_descs(re_chan);
@@ -181,8 +182,7 @@ static void fsl_re_dequeue(struct tasklet_struct *t)
 		}
 
 		if (found) {
-			fsl_re_desc_done(desc);
-			list_move_tail(&desc->node, &re_chan->ack_q);
+			list_move_tail(&desc->node, &completed);
 		} else {
 			dev_err(re_chan->dev,
 				"found hwdesc not in sw queue, discard it\n");
@@ -195,6 +195,17 @@ static void fsl_re_dequeue(struct tasklet_struct *t)
 			 FSL_RE_RMVD_JOB(1));
 	}
 	spin_unlock_irqrestore(&re_chan->desc_lock, flags);
+
+	/* Invoke the client callbacks outside the channel lock. The callback
+	 * may submit new work which re-acquires desc_lock, so holding it here
+	 * would deadlock.
+	 */
+	list_for_each_entry_safe(desc, _desc, &completed, node) {
+		fsl_re_desc_done(desc);
+		spin_lock_irqsave(&re_chan->desc_lock, flags);
+		list_move_tail(&desc->node, &re_chan->ack_q);
+		spin_unlock_irqrestore(&re_chan->desc_lock, flags);
+	}
 }
 
 /* Per Job Ring interrupt handler */
-- 
2.53.0



