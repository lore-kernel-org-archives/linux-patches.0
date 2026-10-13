Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BF54F55B5;
	Tue, 13 Oct 2026 12:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893262; cv=none; b=XOx3SRYPSdUTU1DhU4qcVN6wxUGlFE3u9XS+VjzDB65a52r9szCM4hHAP8DU2ue9e4u9de1Iv43YiyX+AH28359Q4pTMGM3f58ACBxGt2Avc1VFB860hJe8LcOOoAYNujSKKVx/+JuQ76REfeZUO9vloK5CwcCIaXw1F1V/ReFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893262; c=relaxed/simple;
	bh=P6Zivs3kc6+DhWwlBbLbV0hb1OC4NaLiltn7PxTBcmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7nfuRmtqtoteyDH8glX0Plg8lbIlyF0P3ZQTBZtBE5fo+4fLewZZR6s9ixGjHr/WMWwP/XFNQLPeWwGdQ0p8y2QL1s9Lv3jadlC4i9WXbG7ao0jT1Y36NddOEUqw9StFuAUVVm+vVt8WQGE/EiMRp5LFy4+olXgNk2Oe9n1jOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvnMG2AO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvnMG2AO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B471F000FF;
	Tue, 13 Oct 2026 12:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893261;
	bh=LQAQ/MH0ZiLeArWrtz3ZkGDsltDLt2LbJV+d+3WqIsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvnMG2AOwGi1Q/B1gmXdYv/9/g1H7xZ2L9QzyiT2J2zS1Kwso9R9BEfT/rbL8mzlo
	 /m6Qp0xPMv6atCoDR7QKpkdfNBp4e6q8FpvgshRISpjtcjTcgN8KHpk+64Yv0TNZ+K
	 iBi3Rac/qlBjB3JKwk5pLF/VpUnXc2gSEocKaHyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/621] ALSA: ctxfi: Use explicit output flag for DAIO resources
Date: Tue, 13 Oct 2026 13:32:43 +0200
Message-ID: <20261013112924.849068377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index d65c7dd738069..9f7d577701717 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1164,7 +1164,7 @@ static int atc_release_resources(struct ct_atc *atc)
 		daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
 		for (i = 0; i < atc->n_daio; i++) {
 			daio = atc->daios[i];
-			if (daio->type < LINEIM) {
+			if (daio->output) {
 				dao = container_of(daio, struct dao, daio);
 				dao->ops->clear_left_input(dao);
 				dao->ops->clear_right_input(dao);
@@ -1394,6 +1394,7 @@ static int atc_get_resources(struct ct_atc *atc)
 	for (i = 0, atc->n_daio = 0; i < num_daios; i++) {
 		da_desc.type = (atc->model != CTSB073X) ? i :
 			     ((i == SPDIFIO) ? SPDIFI1 : i);
+		da_desc.output = i < LINEIM;
 		err = daio_mgr->get_daio(daio_mgr, &da_desc,
 					(struct daio **)&atc->daios[i]);
 		if (err) {
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index 9fd4f18a867e4..c439411fb1fe1 100644
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
@@ -334,7 +332,7 @@ static int daio_rsc_init(struct daio *daio,
 		goto error1;
 
 	/* Set daio->rscl/r->ops to daio specific ones */
-	if (desc->type <= DAIO_OUT_MAX) {
+	if (desc->output) {
 		daio->rscl.ops = daio->rscr.ops = &daio_out_rsc_ops;
 	} else {
 		switch (hw->chip_type) {
@@ -349,6 +347,7 @@ static int daio_rsc_init(struct daio *daio,
 		}
 	}
 	daio->type = desc->type;
+	daio->output = desc->output;
 
 	return 0;
 
@@ -438,6 +437,7 @@ static int dao_rsc_reinit(struct dao *dao, const struct dao_desc *desc)
 	dsc.type = dao->daio.type;
 	dsc.msr = desc->msr;
 	dsc.passthru = desc->passthru;
+	dsc.output = dao->daio.output;
 	dao_rsc_uninit(dao);
 	return dao_rsc_init(dao, &dsc, mgr);
 }
@@ -523,7 +523,7 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 
 	err = -ENOMEM;
 	/* Allocate mem for daio resource */
-	if (desc->type <= DAIO_OUT_MAX) {
+	if (desc->output) {
 		struct dao *dao = kzalloc(sizeof(*dao), GFP_KERNEL);
 		if (!dao)
 			goto error;
@@ -570,7 +570,7 @@ static int put_daio_rsc(struct daio_mgr *mgr, struct daio *daio)
 		daio_mgr_put_rsc(&mgr->mgr, daio->type);
 	}
 
-	if (daio->type <= DAIO_OUT_MAX) {
+	if (daio->output) {
 		dao_rsc_uninit(container_of(daio, struct dao, daio));
 		kfree(container_of(daio, struct dao, daio));
 	} else {
@@ -585,7 +585,7 @@ static int daio_mgr_enb_daio(struct daio_mgr *mgr, struct daio *daio)
 {
 	struct hw *hw = mgr->mgr.hw;
 
-	if (DAIO_OUT_MAX >= daio->type) {
+	if (daio->output) {
 		hw->daio_mgr_enb_dao(mgr->mgr.ctrl_blk,
 				daio_device_index(daio->type, hw));
 	} else {
@@ -599,7 +599,7 @@ static int daio_mgr_dsb_daio(struct daio_mgr *mgr, struct daio *daio)
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



