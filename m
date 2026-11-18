Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060441;
	b=TcQd8mkD5/f0y8f/1bUA5n7ADJk3DQdhtEw/TKBHXwZcoevKONifhF+s4WI3Aq3gTOWE
	 l2wCOs71FCDZL1n3xd8dpjeJOf56ZJi9yseVRPTvGqlBm4052z4I9KGWJJkuOSCAX8J/P
	 yG2kgChM3B+DwIIkXR+SbmAADGCylst90DcFcOoSWT0kNiO9faa5RLO8UgS5DdeCi98B6
	 7KFnsZ16pbATZAGayZhjwIT3xCMtgwdPzI3RH45ALDVlGXe7rSfhxRPaomcQ/i6AQSvxT
	 /H7jryqfzarq7N078w46b1sVTb6vLVQHcdzotBjyLepbwBb/LaiZ/AcSDeNKxsMXijg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XmAb06mXgrOY1OaHfsLGo9fed+WA4vKqwgtwGgts0Fw=;
	b=m55R1wHY3wp9/KOpp0/qN+ZsSNGOaPfL/eeklY9Yup5/FEDwk8MzBfy1Ik8yWRNcNc1m
	 4EDkV45LVBo61ipaZdG9BVQ9G4gctZidqzRs3NNwH/8cZWSQBhLgb7jgEUl/FixQvHC3o
	 N25YqKpUyd/hhsnc4i2vvzX6MXZraBViSYcDzSK4iz4Shr8d3LL32zRru9Ps/f1XtR0R2
	 l+EPf6BOOVK99IeQv/DHMeIrVEk/usvOgifg71CKyJ8Ag6IMvRm2QnS0RvsBpL095kPtY
	 BAc21KvgxL25ufdX7xkrEKp/v6yj2Tj8OpCNjWC3uyPby85SIxXiB/myLDGH301DkNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKWDOrHJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A61606A320;
	Thu, 19 Nov 2026 03:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qKWDOrHJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D47D1F000C4;
	Thu, 19 Nov 2026 03:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060441;
	bh=XmAb06mXgrOY1OaHfsLGo9fed+WA4vKqwgtwGgts0Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKWDOrHJqPKX+Zg9IbEyWToZeVU2QSbutHtljiZ6V4hzCfNrWm8uiwRaQcYr8quDm
	 4zLmFhLQ/BROJ80E1ZO76WV2uOUpGvRtDrRRrz5EV8D4Jv4nyzbv6OH0BqlkoWzmGu
	 wzzJdjPFUe2/7LmNtW+Bxr6lbpbjpVPnbE6aDfjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1159/1848] dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources
Date: Wed, 18 Nov 2026 15:53:17 +0100
Message-ID: <20261118150008.223253452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit d805aa5b6088b193debabaa80cc0991bfa2bd057 ]

fsl_re_free_chan_resources() loops alloc_count times calling
list_first_entry() on free_q without checking whether the list still
has entries. If descriptors remain un-acked or pending in submit_q /
active_q / ack_q when the channel resources are freed, free_q becomes
smaller than alloc_count and list_first_entry() returns the list head,
causing list_del() to corrupt the list head and dereference a bogus
pointer.

Walk free_q with list_for_each_entry_safe() until it is empty,
decrementing alloc_count per freed descriptor, instead of relying on
the alloc_count count.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260718235227.385108-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index 562a3a3f75f16..facd8b0f48f47 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -612,18 +612,15 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
 static void fsl_re_free_chan_resources(struct dma_chan *chan)
 {
 	struct fsl_re_chan *re_chan;
-	struct fsl_re_desc *desc;
+	struct fsl_re_desc *desc, *_desc;
 
 	re_chan = container_of(chan, struct fsl_re_chan, chan);
-	while (re_chan->alloc_count--) {
-		desc = list_first_entry(&re_chan->free_q,
-					struct fsl_re_desc,
-					node);
-
+	list_for_each_entry_safe(desc, _desc, &re_chan->free_q, node) {
 		list_del(&desc->node);
 		dma_pool_free(re_chan->re_dev->cf_desc_pool, desc->cf_addr,
 			      desc->cf_paddr);
 		kfree(desc);
+		re_chan->alloc_count--;
 	}
 
 	if (!list_empty(&re_chan->free_q))
-- 
2.53.0



