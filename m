Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117C31DE8B4;
	Wed,  6 Nov 2024 12:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895404; cv=none; b=ZvMdUfFRsM5hcgWvA83f11l20wPB0SPziAgfS+Kl5Bc8nubWBS80X/9KPrt3iKX8fxPFwHVieTCOHTSwus0IO/UEKEcECm8J9R5wVB0vJACOSzRs9Vht0tVBG5pFhP0l0WZ3K2jcbxpVI51HOBvIqPAKjMq085gocVKJ8+OdmS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895404; c=relaxed/simple;
	bh=GR1vuRM/a33M+N2ke4QagxaNpKKXmbiA+vJm2N7/TXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpBeQa9nL38ZQa/l7wPJhSG6tVbH2t9AB7MP8bCQWVS1tBFq572DDxp+qELoGFGmIF6pMr2V31OrZ/v5GNXPqSzsobAQ9LHdOWfQJfm4GOtkh7yED+2VXA/bzubgzJWUf0iGc+Ak4sCeIN9mItT8Si0HhMLW4FdmbQrQFmBpAlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTCBekxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTCBekxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F55C4CECD;
	Wed,  6 Nov 2024 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895403;
	bh=GR1vuRM/a33M+N2ke4QagxaNpKKXmbiA+vJm2N7/TXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTCBekxDmK4sdnOrbFqREpvrvqYZS0SMs0z+FtQxdcxBdkbbU9uxyfNsBzNFRtFJn
	 ZL5kTHMo+2Ko7OIR67tYxL18BY91VUiR2wdEGw5cWJHFgh+ITOH8y0ewfQOltlaopV
	 aA81I96EdGgw65S1PcvH18bpOEiyJJunRd5XNCVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Stange <nstange@suse.com>,
	Chun-Yi Lee <jlee@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 205/350] aoe: fix the potential use-after-free problem in more places
Date: Wed,  6 Nov 2024 13:02:13 +0100
Message-ID: <20241106120326.047555956@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chun-Yi Lee <joeyli.kernel@gmail.com>

commit 6d6e54fc71ad1ab0a87047fd9c211e75d86084a3 upstream.

For fixing CVE-2023-6270, f98364e92662 ("aoe: fix the potential
use-after-free problem in aoecmd_cfg_pkts") makes tx() calling dev_put()
instead of doing in aoecmd_cfg_pkts(). It avoids that the tx() runs
into use-after-free.

Then Nicolai Stange found more places in aoe have potential use-after-free
problem with tx(). e.g. revalidate(), aoecmd_ata_rw(), resend(), probe()
and aoecmd_cfg_rsp(). Those functions also use aoenet_xmit() to push
packet to tx queue. So they should also use dev_hold() to increase the
refcnt of skb->dev.

On the other hand, moving dev_put() to tx() causes that the refcnt of
skb->dev be reduced to a negative value, because corresponding
dev_hold() are not called in revalidate(), aoecmd_ata_rw(), resend(),
probe(), and aoecmd_cfg_rsp(). This patch fixed this issue.

Cc: stable@vger.kernel.org
Link: https://nvd.nist.gov/vuln/detail/CVE-2023-6270
Fixes: f98364e92662 ("aoe: fix the potential use-after-free problem in aoecmd_cfg_pkts")
Reported-by: Nicolai Stange <nstange@suse.com>
Signed-off-by: Chun-Yi Lee <jlee@suse.com>
Link: https://lore.kernel.org/stable/20240624064418.27043-1-jlee%40suse.com
Link: https://lore.kernel.org/r/20241002035458.24401-1-jlee@suse.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/aoe/aoecmd.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -362,6 +362,7 @@ ata_rw_frameinit(struct frame *f)
 	}
 
 	ah->cmdstat = ATA_CMD_PIO_READ | writebit | extbit;
+	dev_hold(t->ifp->nd);
 	skb->dev = t->ifp->nd;
 }
 
@@ -402,6 +403,8 @@ aoecmd_ata_rw(struct aoedev *d)
 		__skb_queue_head_init(&queue);
 		__skb_queue_tail(&queue, skb);
 		aoenet_xmit(&queue);
+	} else {
+		dev_put(f->t->ifp->nd);
 	}
 	return 1;
 }
@@ -484,10 +487,13 @@ resend(struct aoedev *d, struct frame *f
 	memcpy(h->dst, t->addr, sizeof h->dst);
 	memcpy(h->src, t->ifp->nd->dev_addr, sizeof h->src);
 
+	dev_hold(t->ifp->nd);
 	skb->dev = t->ifp->nd;
 	skb = skb_clone(skb, GFP_ATOMIC);
-	if (skb == NULL)
+	if (skb == NULL) {
+		dev_put(t->ifp->nd);
 		return;
+	}
 	f->sent = ktime_get();
 	__skb_queue_head_init(&queue);
 	__skb_queue_tail(&queue, skb);
@@ -618,6 +624,8 @@ probe(struct aoetgt *t)
 		__skb_queue_head_init(&queue);
 		__skb_queue_tail(&queue, skb);
 		aoenet_xmit(&queue);
+	} else {
+		dev_put(f->t->ifp->nd);
 	}
 }
 
@@ -1407,6 +1415,7 @@ aoecmd_ata_id(struct aoedev *d)
 	ah->cmdstat = ATA_CMD_ID_ATA;
 	ah->lba3 = 0xa0;
 
+	dev_hold(t->ifp->nd);
 	skb->dev = t->ifp->nd;
 
 	d->rttavg = RTTAVG_INIT;
@@ -1416,6 +1425,8 @@ aoecmd_ata_id(struct aoedev *d)
 	skb = skb_clone(skb, GFP_ATOMIC);
 	if (skb)
 		f->sent = ktime_get();
+	else
+		dev_put(t->ifp->nd);
 
 	return skb;
 }


