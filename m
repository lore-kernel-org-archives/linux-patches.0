Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE71A370ADB;
	Sun,  7 Jun 2026 11:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830038; cv=none; b=WVmXQkr/tsFhTRS4fEIp4C5b/qXKL0jw5DjIaGhLWAz7+NGn0xvH1qjYf//6F9u5hctbRhb0bMeFp5rOzR+c/s/Uxc3xjjT8bpGIMIA8fJ65xDZ5Hsqk7uQ6SGvHSc1rTDdbXAfkogANb3cSbxBaox8nIrcFZSGqe7NWwa2jCyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830038; c=relaxed/simple;
	bh=5aivG5OH2v+mhdIRI5wQOThr6p87w9obrXYueBQpAHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zi5VS4gqvtKiLP3rc8XdiZyRgobpgketbwLSGwouQunIJ/iOsEyrgiIguT9va8OPtlMjcou2i+wjod5rQLW7vwmQnYfJA78oXRkDeGDKEMFybrLDtjg4khSkDxse74ZJFDiWka+IVfRHSjuV15nafu4n2kypABABMeGSa8A7HvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPXu3DB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPXu3DB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9961F00898;
	Sun,  7 Jun 2026 11:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830037;
	bh=W/OmaiYTUX0lCNcz+1b2eMc86qNXGZoNFzl/YcyWiTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPXu3DB+tKrTVGAWCpjCiEDniuOd2yg/tVeN7mbPTxrjcfjuOZXy7tpjfqBCgXQh2
	 B49gnAgxfFJYJA9yhrmSbAWiIRHyizEDgFZqsr7LtrGEcteObOyq12eXcY4vRCxkv/
	 IwtrPHJ9tg2eYCc3cvefa07BbhGxmqUpkuW99KTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaomin Chen <eeesssooo020@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/315] xfrm: iptfs: reset runtime state when cloning SAs
Date: Sun,  7 Jun 2026 12:01:29 +0200
Message-ID: <20260607095738.693895072@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaomin Chen <eeesssooo020@gmail.com>

[ Upstream commit 7f83d174073234839aea176f265e517e0d50a1d2 ]

iptfs_clone_state() clones the IPTFS mode data with kmemdup(). This
copies runtime objects which must not be shared with the original SA,
including the embedded sk_buff_head, hrtimers, spinlock, and in-flight
reassembly/reorder state.

If xfrm_state_migrate() fails after clone_state() but before the later
init_state() call has reinitialized those fields, the cloned state can be
destroyed by xfrm_state_gc_task() with list and timer state copied from the
original SA. With queued packets this lets the clone splice and free skbs
owned by the original IPTFS queue, leading to use-after-free and
double-free reports in iptfs_destroy_state() and skb release paths.

Reinitialize the clone's runtime state before publishing it through
x->mode_data. Because clone_state() now publishes a destroyable mode_data
object before init_state(), take the mode callback module reference there.
Avoid taking it again from __iptfs_init_state() for the same object.

Fixes: 0e4fbf013fa5 ("xfrm: iptfs: add user packet (tunnel ingress) handling")
Cc: stable@vger.kernel.org
Signed-off-by: Shaomin Chen <eeesssooo020@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_iptfs.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -2650,7 +2650,8 @@ static void __iptfs_init_state(struct xf
 	x->props.enc_hdr_len = sizeof(struct ip_iptfs_hdr);
 
 	/* Always keep a module reference when x->mode_data is set */
-	__module_get(x->mode_cbs->owner);
+	if (x->mode_data != xtfs)
+		__module_get(x->mode_cbs->owner);
 
 	x->mode_data = xtfs;
 	xtfs->x = x;
@@ -2658,22 +2659,40 @@ static void __iptfs_init_state(struct xf
 
 static int iptfs_clone_state(struct xfrm_state *x, struct xfrm_state *orig)
 {
+	struct skb_wseq *w_saved = NULL;
 	struct xfrm_iptfs_data *xtfs;
 
 	xtfs = kmemdup(orig->mode_data, sizeof(*xtfs), GFP_KERNEL);
 	if (!xtfs)
 		return -ENOMEM;
 
-	xtfs->ra_newskb = NULL;
 	if (xtfs->cfg.reorder_win_size) {
-		xtfs->w_saved = kcalloc(xtfs->cfg.reorder_win_size,
-					sizeof(*xtfs->w_saved), GFP_KERNEL);
-		if (!xtfs->w_saved) {
+		w_saved = kcalloc(xtfs->cfg.reorder_win_size,
+				  sizeof(*w_saved), GFP_KERNEL);
+		if (!w_saved) {
 			kfree_sensitive(xtfs);
 			return -ENOMEM;
 		}
 	}
+	xtfs->w_saved = w_saved;
 
+	__skb_queue_head_init(&xtfs->queue);
+	xtfs->queue_size = 0;
+	hrtimer_setup(&xtfs->iptfs_timer, iptfs_delay_timer, CLOCK_MONOTONIC,
+		      IPTFS_HRTIMER_MODE);
+
+	spin_lock_init(&xtfs->drop_lock);
+	hrtimer_setup(&xtfs->drop_timer, iptfs_drop_timer, CLOCK_MONOTONIC,
+		      IPTFS_HRTIMER_MODE);
+
+	xtfs->w_seq_set = false;
+	xtfs->w_wantseq = 0;
+	xtfs->w_savedlen = 0;
+	xtfs->ra_newskb = NULL;
+	xtfs->ra_wantseq = 0;
+	xtfs->ra_runtlen = 0;
+
+	__module_get(x->mode_cbs->owner);
 	x->mode_data = xtfs;
 	xtfs->x = x;
 


