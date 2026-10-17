Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADC7377A92;
	Sat, 17 Oct 2026 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253813; cv=none; b=iu0Q7TYBspTA+pg2MTt4EACeqHurciBRMdG08YPAS1oiEfy3FOSbO6bofLnPVhwWYegfJsE1cDYFGLRrKycX4qMsnodf6mBNNjZ/vtLwK8ez8CezbDyxkonGuVwlATND4ROX6sVXCLOnfnevcrXDYRm9Kvv4Tb7qtdZmRCbL6K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253813; c=relaxed/simple;
	bh=fbEehDjnpR42XxVkRmE+bEFfx55NqoR6grMZl5JJ6Vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDDC+YdqMP4EAyjtUn4Ng+e9pQCRxdWtUv71DvOc59kaKbiGd/Db9BavxbhNsLMALKl0n0Wu07xC7B296ympu7/Wc0zmR8ybjZUgRuTeBrMuNJ7vSJmHW79N4cxgdGQZmI+2n+P06TYEJ34ROYU0FEE0lkt9CzYe0lUtos2w5eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkiLJauA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkiLJauA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04D21F000C4;
	Sat, 17 Oct 2026 16:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253812;
	bh=Dts8UbYzCICPB/FfbBBBWPZWDOkWaRCVy5gAR74YY5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkiLJauAuvSrryMe3mv7d5Jyac+hFFmq7xO4uPHIYvKILaOk6eRr8H9HWc2q7mrU9
	 z8y5xeFT2PT+/WkbTlMGsU/z3EW3Jft6m+OdI8Io+WK0Qgr3XAWM/xmb7zGZ1tjTPp
	 UQFJfyGS8RP5ZsRicQQQujdWO4VKaK/KcHMJDMAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/869] ALSA: ctxfi: Use explicit output flag for DAIO resources
Date: Sat, 17 Oct 2026 17:50:45 +0200
Message-ID: <20261017160042.285878268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harin Lee <me@harin.net>

[ Upstream commit 9bb003a1f98b11b80238d522778115ad07355149 ]

Replace the index-based type check with an explicit output flag in
struct daio and struct daio_desc.

This allows handling DAIO resource types correctly regardless of their
index. This is necessary for hardware variants where resource types do
not follow a sequential order.

Signed-off-by: Harin Lee <me@harin.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251124180501.2760421-4-me@harin.net
Stable-dep-of: 277c6960d4dd ("ALSA: ctxfi: Check the error for index mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ctxfi/ctatc.c  |  3 ++-
 sound/pci/ctxfi/ctdaio.c | 14 +++++++-------
 sound/pci/ctxfi/ctdaio.h |  2 ++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 74eecc9ebd846..fa70c4504db5f 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1166,7 +1166,7 @@ static int atc_release_resources(struct ct_atc *atc)
 		daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
 		for (i = 0; i < atc->n_daio; i++) {
 			daio = atc->daios[i];
-			if (daio->type < LINEIM) {
+			if (daio->output) {
 				dao = container_of(daio, struct dao, daio);
 				dao->ops->clear_left_input(dao);
 				dao->ops->clear_right_input(dao);
@@ -1396,6 +1396,7 @@ static int atc_get_resources(struct ct_atc *atc)
 	for (i = 0, atc->n_daio = 0; i < num_daios; i++) {
 		da_desc.type = (atc->model != CTSB073X) ? i :
 			     ((i == SPDIFIO) ? SPDIFI1 : i);
+		da_desc.output = i < LINEIM;
 		err = daio_mgr->get_daio(daio_mgr, &da_desc,
 					(struct daio **)&atc->daios[i]);
 		if (err) {
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index b20c10196579d..143dd0979cc9a 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -18,8 +18,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 
-#define DAIO_OUT_MAX		SPDIFOO
-
 struct daio_usage {
 	unsigned short data;
 };
@@ -352,7 +350,7 @@ static int daio_rsc_init(struct daio *daio,
 		goto error1;
 
 	/* Set daio->rscl/r->ops to daio specific ones */
-	if (desc->type <= DAIO_OUT_MAX) {
+	if (desc->output) {
 		daio->rscl.ops = daio->rscr.ops = &daio_out_rsc_ops;
 	} else {
 		switch (hw->chip_type) {
@@ -367,6 +365,7 @@ static int daio_rsc_init(struct daio *daio,
 		}
 	}
 	daio->type = desc->type;
+	daio->output = desc->output;
 
 	return 0;
 
@@ -456,6 +455,7 @@ static int dao_rsc_reinit(struct dao *dao, const struct dao_desc *desc)
 	dsc.type = dao->daio.type;
 	dsc.msr = desc->msr;
 	dsc.passthru = desc->passthru;
+	dsc.output = dao->daio.output;
 	dao_rsc_uninit(dao);
 	return dao_rsc_init(dao, &dsc, mgr);
 }
@@ -542,7 +542,7 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 
 	err = -ENOMEM;
 	/* Allocate mem for daio resource */
-	if (desc->type <= DAIO_OUT_MAX) {
+	if (desc->output) {
 		struct dao *dao = kzalloc(sizeof(*dao), GFP_KERNEL);
 		if (!dao)
 			goto error;
@@ -591,7 +591,7 @@ static int put_daio_rsc(struct daio_mgr *mgr, struct daio *daio)
 	daio_mgr_put_rsc(&mgr->mgr, daio->type);
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 
-	if (daio->type <= DAIO_OUT_MAX) {
+	if (daio->output) {
 		dao_rsc_uninit(container_of(daio, struct dao, daio));
 		kfree(container_of(daio, struct dao, daio));
 	} else {
@@ -606,7 +606,7 @@ static int daio_mgr_enb_daio(struct daio_mgr *mgr, struct daio *daio)
 {
 	struct hw *hw = mgr->mgr.hw;
 
-	if (DAIO_OUT_MAX >= daio->type) {
+	if (daio->output) {
 		hw->daio_mgr_enb_dao(mgr->mgr.ctrl_blk,
 				daio_device_index(daio->type, hw));
 	} else {
@@ -620,7 +620,7 @@ static int daio_mgr_dsb_daio(struct daio_mgr *mgr, struct daio *daio)
 {
 	struct hw *hw = mgr->mgr.hw;
 
-	if (DAIO_OUT_MAX >= daio->type) {
+	if (daio->output) {
 		hw->daio_mgr_dsb_dao(mgr->mgr.ctrl_blk,
 				daio_device_index(daio->type, hw));
 	} else {
diff --git a/sound/pci/ctxfi/ctdaio.h b/sound/pci/ctxfi/ctdaio.h
index 15147fe5f74a0..b337da2de8b50 100644
--- a/sound/pci/ctxfi/ctdaio.h
+++ b/sound/pci/ctxfi/ctdaio.h
@@ -43,6 +43,7 @@ struct daio {
 	struct rsc rscl;	/* Basic resource info for left TX/RX */
 	struct rsc rscr;	/* Basic resource info for right TX/RX */
 	enum DAIOTYP type;
+	unsigned char output;
 };
 
 struct dao {
@@ -91,6 +92,7 @@ struct daio_desc {
 	unsigned int type:4;
 	unsigned int msr:4;
 	unsigned int passthru:1;
+	unsigned int output:1;
 };
 
 struct daio_mgr {
-- 
2.53.0



