Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B991C4F93DA;
	Tue, 13 Oct 2026 12:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893266; cv=none; b=ublLnasM2kVFLKdc+9ZHr0r0WVJA6qb76DMK2izHC3jNLvqYt++SkE7kV5fr1cpI8v+w1FXcRr6n5JNBp1QJoNgTN2rvnUJnPr2HK9qrzBT0IS8DWD3xQI47920Bts9WqkzzUuUxOfPnlgdhcHMT0ZDdfPliOttf5IbBFY30EN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893266; c=relaxed/simple;
	bh=KlDM/I1X3ajRoryr0l520aTEFzmqo52RjYZo0vZMjpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3BLeA1mYSQXey0TJzwFB2/aAVqUL54fyoRGotmA6fOOnOb8rO/KVJtHNwHCEj7uyz7+YhWdIbaoWdZ1pmWcN8SUMRLluJIe+sY3tdj6B26n30FMEBC1F43+7IAvQjSVCNflTak+L7e2yPPvdAqwb/mXaauqJL9OdzLJ4CZ7Lz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cpb7V2TG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cpb7V2TG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF77B1F000FF;
	Tue, 13 Oct 2026 12:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893264;
	bh=vNDcYzJ0Hy152y1TGCzOY8WomtO0RmTKhsaSjcatn+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cpb7V2TGOAd5vzghnUAVYQ3XylJFXHrn5GGs5CDKaaaaq9wrGnUOYZTVb5AVjmXaW
	 XxQkyV0k7Z0xuwvJMkmgJymwKTZZnlWyv3s57jGbZ7Hc1wTydtmMYrSA3KvnvA53L/
	 US77nCt3kW95SNblkc2Z77/8jUwJQb1Xm8+pXEJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/621] ALSA: ctxfi: Refactor resource alloc for sparse mappings
Date: Tue, 13 Oct 2026 13:32:44 +0200
Message-ID: <20261013112924.873376569@linuxfoundation.org>
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

[ Upstream commit a2dbaeb5c61ef110ceefe0d48fe94d428d3bcf16 ]

Refactor atc_get_resources(), atc_connect_resources(), and
atc_release_resources() to allocate resources based on maximum type
definitions.

This allows specific resources to be conditionally skipped based on
capabilities. This is necessary for hardware variants where resource
allocations do not follow a sequential order.

Signed-off-by: Harin Lee <me@harin.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251124180501.2760421-5-me@harin.net
Stable-dep-of: 277c6960d4dd ("ALSA: ctxfi: Check the error for index mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ctxfi/ctatc.c | 60 ++++++++++++++++++++++++-----------------
 sound/pci/ctxfi/ctatc.h |  4 ---
 2 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 9f7d577701717..7cb33d7c43d2f 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -25,6 +25,9 @@
 #include <sound/control.h>
 #include <sound/asoundef.h>
 
+#define NUM_ATC_SRCS	6
+#define NUM_ATC_PCM		(2 * 4)
+
 #define MONO_SUM_SCALE	0x19a8	/* 2^(-0.5) in 14-bit floating format */
 #define MAX_MULTI_CHN	8
 
@@ -1162,8 +1165,10 @@ static int atc_release_resources(struct ct_atc *atc)
 
 	if (atc->daios) {
 		daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
-		for (i = 0; i < atc->n_daio; i++) {
+		for (i = 0; i < NUM_DAIOTYP; i++) {
 			daio = atc->daios[i];
+			if (!daio)
+				continue;
 			if (daio->output) {
 				dao = container_of(daio, struct dao, daio);
 				dao->ops->clear_left_input(dao);
@@ -1177,8 +1182,9 @@ static int atc_release_resources(struct ct_atc *atc)
 
 	if (atc->pcm) {
 		sum_mgr = atc->rsc_mgrs[SUM];
-		for (i = 0; i < atc->n_pcm; i++)
-			sum_mgr->put_sum(sum_mgr, atc->pcm[i]);
+		for (i = 0; i < NUM_ATC_PCM; i++)
+			if (atc->pcm[i])
+				sum_mgr->put_sum(sum_mgr, atc->pcm[i]);
 
 		kfree(atc->pcm);
 		atc->pcm = NULL;
@@ -1186,8 +1192,9 @@ static int atc_release_resources(struct ct_atc *atc)
 
 	if (atc->srcs) {
 		src_mgr = atc->rsc_mgrs[SRC];
-		for (i = 0; i < atc->n_src; i++)
-			src_mgr->put_src(src_mgr, atc->srcs[i]);
+		for (i = 0; i < NUM_ATC_SRCS; i++)
+			if (atc->srcs[i])
+				src_mgr->put_src(src_mgr, atc->srcs[i]);
 
 		kfree(atc->srcs);
 		atc->srcs = NULL;
@@ -1195,7 +1202,9 @@ static int atc_release_resources(struct ct_atc *atc)
 
 	if (atc->srcimps) {
 		srcimp_mgr = atc->rsc_mgrs[SRCIMP];
-		for (i = 0; i < atc->n_srcimp; i++) {
+		for (i = 0; i < NUM_ATC_SRCS; i++) {
+			if (!atc->srcimps[i])
+				continue;
 			srcimp = atc->srcimps[i];
 			srcimp->ops->unmap(srcimp);
 			srcimp_mgr->put_srcimp(srcimp_mgr, atc->srcimps[i]);
@@ -1368,30 +1377,32 @@ static int atc_get_resources(struct ct_atc *atc)
 	struct srcimp_mgr *srcimp_mgr;
 	struct sum_desc sum_dsc = {0};
 	struct sum_mgr *sum_mgr;
-	int err, i, num_srcs, num_daios;
+	struct capabilities cap;
+	int err, i;
 
-	num_daios = ((atc->model == CTSB1270) ? 8 : 7);
-	num_srcs = ((atc->model == CTSB1270) ? 6 : 4);
+	cap = atc->capabilities(atc);
 
-	atc->daios = kcalloc(num_daios, sizeof(void *), GFP_KERNEL);
+	atc->daios = kcalloc(NUM_DAIOTYP, sizeof(void *), GFP_KERNEL);
 	if (!atc->daios)
 		return -ENOMEM;
 
-	atc->srcs = kcalloc(num_srcs, sizeof(void *), GFP_KERNEL);
+	atc->srcs = kcalloc(NUM_ATC_SRCS, sizeof(void *), GFP_KERNEL);
 	if (!atc->srcs)
 		return -ENOMEM;
 
-	atc->srcimps = kcalloc(num_srcs, sizeof(void *), GFP_KERNEL);
+	atc->srcimps = kcalloc(NUM_ATC_SRCS, sizeof(void *), GFP_KERNEL);
 	if (!atc->srcimps)
 		return -ENOMEM;
 
-	atc->pcm = kcalloc(2 * 4, sizeof(void *), GFP_KERNEL);
+	atc->pcm = kcalloc(NUM_ATC_PCM, sizeof(void *), GFP_KERNEL);
 	if (!atc->pcm)
 		return -ENOMEM;
 
 	daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
 	da_desc.msr = atc->msr;
-	for (i = 0, atc->n_daio = 0; i < num_daios; i++) {
+	for (i = 0; i < NUM_DAIOTYP; i++) {
+		if ((i == MIC) && !cap.dedicated_mic)
+			continue;
 		da_desc.type = (atc->model != CTSB073X) ? i :
 			     ((i == SPDIFIO) ? SPDIFI1 : i);
 		da_desc.output = i < LINEIM;
@@ -1403,42 +1414,39 @@ static int atc_get_resources(struct ct_atc *atc)
 				i);
 			return err;
 		}
-		atc->n_daio++;
 	}
 
 	src_mgr = atc->rsc_mgrs[SRC];
 	src_dsc.multi = 1;
 	src_dsc.msr = atc->msr;
 	src_dsc.mode = ARCRW;
-	for (i = 0, atc->n_src = 0; i < num_srcs; i++) {
+	for (i = 0; i < NUM_ATC_SRCS; i++) {
+		if (((i > 3) && !cap.dedicated_mic))
+			continue;
 		err = src_mgr->get_src(src_mgr, &src_dsc,
 					(struct src **)&atc->srcs[i]);
 		if (err)
 			return err;
-
-		atc->n_src++;
 	}
 
 	srcimp_mgr = atc->rsc_mgrs[SRCIMP];
 	srcimp_dsc.msr = 8;
-	for (i = 0, atc->n_srcimp = 0; i < num_srcs; i++) {
+	for (i = 0; i < NUM_ATC_SRCS; i++) {
+		if (((i > 3) && !cap.dedicated_mic))
+			continue;
 		err = srcimp_mgr->get_srcimp(srcimp_mgr, &srcimp_dsc,
 					(struct srcimp **)&atc->srcimps[i]);
 		if (err)
 			return err;
-
-		atc->n_srcimp++;
 	}
 
 	sum_mgr = atc->rsc_mgrs[SUM];
 	sum_dsc.msr = atc->msr;
-	for (i = 0, atc->n_pcm = 0; i < (2*4); i++) {
+	for (i = 0; i < NUM_ATC_PCM; i++) {
 		err = sum_mgr->get_sum(sum_mgr, &sum_dsc,
 					(struct sum **)&atc->pcm[i]);
 		if (err)
 			return err;
-
-		atc->n_pcm++;
 	}
 
 	return 0;
@@ -1491,9 +1499,11 @@ static void atc_connect_resources(struct ct_atc *atc)
 	struct sum *sum;
 	struct ct_mixer *mixer;
 	struct rsc *rscs[2] = {NULL};
+	struct capabilities cap;
 	int i, j;
 
 	mixer = atc->mixer;
+	cap = atc->capabilities(atc);
 
 	for (i = MIX_WAVE_FRONT, j = LINEO1; i <= MIX_SPDIF_OUT; i++, j++) {
 		mixer->get_output_ports(mixer, i, &rscs[0], &rscs[1]);
@@ -1511,7 +1521,7 @@ static void atc_connect_resources(struct ct_atc *atc)
 	src = atc->srcs[3];
 	mixer->set_input_right(mixer, MIX_LINE_IN, &src->rsc);
 
-	if (atc->model == CTSB1270) {
+	if (cap.dedicated_mic) {
 		/* Titanium HD has a dedicated ADC for the Mic. */
 		dai = container_of(atc->daios[MIC], struct dai, daio);
 		atc_connect_dai(atc->rsc_mgrs[SRC], dai,
diff --git a/sound/pci/ctxfi/ctatc.h b/sound/pci/ctxfi/ctatc.h
index 0bc7b71d910b0..671edc46bd503 100644
--- a/sound/pci/ctxfi/ctatc.h
+++ b/sound/pci/ctxfi/ctatc.h
@@ -132,10 +132,6 @@ struct ct_atc {
 	void **pcm;		/* SUMs for collecting all pcm stream */
 	void **srcs;		/* Sample Rate Converters for input signal */
 	void **srcimps;		/* input mappers for SRCs */
-	unsigned char n_daio;
-	unsigned char n_src;
-	unsigned char n_srcimp;
-	unsigned char n_pcm;
 
 	struct ct_timer *timer;
 
-- 
2.53.0



