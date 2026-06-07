Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA38257855;
	Sun,  7 Jun 2026 10:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829028; cv=none; b=t2AImTr7EmbAO5vYc+h0lQ/CCdmr/i3WjmfcKyYmKQjtbhjR3X+gQzvay9aDQYHH8BtiDEzOwI6wDNSODMs/IZlecBuCwQ5ZVsFcnmQsDRrvWiiT/Y+MhAZVjit4l+t0y49DAIiqOaAbt6tM4nPD0G7oMmvjQlpSoRGaYI0F+Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829028; c=relaxed/simple;
	bh=MkgXAJeJzeVi+JAy4D/3HzFesXzPjZQ9kZiDma/kVs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDdtntRP/8R6FrRxvo/OuDkGclLiwlx4O6SgOhcI/5Bv8ehkpi90A+eIwnnj1hMfSzfzBsQ8gJG3zRvKLHPZOPksb1rXo7Dl5OU+2kKe2xRscBAW8C+rsFzNC490uVLO1MEZS6MsRqAFEGUFkidjZlxz2DdhN5347G/edgBc5Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNrmH13F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNrmH13F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E967F1F00893;
	Sun,  7 Jun 2026 10:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829026;
	bh=1dvdQ9j4uRZFSELeCOxaNVN0qvCxHJ48dxp3LG9527k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNrmH13FAce/7eeK2sJddWnOolCMqHqRpW4gfn81tennZ2PXI/097LI/mcPpFHiGX
	 nqOolkxgZJp0bS/fEbBww75VRDn2LFv9lYNoKbbvIWFd4ItwMVVrfsY/GFKJG5ZA0m
	 10YFan3J/cOkmvqNf4kQROfCJ4Hkl5e+8inaOL+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaomin Chen <eeesssooo020@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.0 235/332] xfrm: iptfs: reset runtime state when cloning SAs
Date: Sun,  7 Jun 2026 12:00:04 +0200
Message-ID: <20260607095736.683793230@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaomin Chen <eeesssooo020@gmail.com>

commit 7f83d174073234839aea176f265e517e0d50a1d2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_iptfs.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

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
@@ -2658,22 +2659,39 @@ static void __iptfs_init_state(struct xf
 
 static int iptfs_clone_state(struct xfrm_state *x, struct xfrm_state *orig)
 {
+	struct skb_wseq *w_saved = NULL;
 	struct xfrm_iptfs_data *xtfs;
 
 	xtfs = kmemdup(orig->mode_data, sizeof(*xtfs), GFP_KERNEL);
 	if (!xtfs)
 		return -ENOMEM;
 
-	xtfs->ra_newskb = NULL;
 	if (xtfs->cfg.reorder_win_size) {
-		xtfs->w_saved = kzalloc_objs(*xtfs->w_saved,
-					     xtfs->cfg.reorder_win_size);
-		if (!xtfs->w_saved) {
+		w_saved = kzalloc_objs(*w_saved, xtfs->cfg.reorder_win_size);
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
 


