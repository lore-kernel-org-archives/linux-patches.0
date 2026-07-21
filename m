Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F22B24A078;
	Tue, 21 Jul 2026 20:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665014; cv=none; b=qk5sgo2FlN/tKHAwxHw0us229lDmRhZ1v5Twsnt141NRwY6Mw/cGLb0bgryDNylOOCr24V9MlAN22zkTAE37ayGS6I/qdT4KRi592Ewu9kLIdYBU4z7n8WtyhH9kQQiMb2ldEGCQHPwBpBbc062riBJ+Kfy7iVBqe/Bf2u97qDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665014; c=relaxed/simple;
	bh=vzHOJYV2qXjBMemqs49sLAIdPOecysrehRsEbEdKhHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz16iycmCDbqkeYPHJxj7qmMC391REB3g0jUyPUueDeF423ccwUG2hxpz8PcIl8+j1PUXT4xieYVzENfkOFzx9hkuG+B2wnp/AJsAV1IQW0XGIzkWreOfc9GB2Gk7D0mDMNSRkin4DRmhSjUZtRr1J16fRObAXmextJu2FgBK5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tReNSlVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tReNSlVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBE51F000E9;
	Tue, 21 Jul 2026 20:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665013;
	bh=GtIKOEVlsi46cpM3axBEqs3dHgJCxY7qerfOz60khnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tReNSlVxKwwIio4sdIzF7h2GzCQltIFLF7gMuXU3LTanAzRR2tdRCwT4A7QatIIPM
	 6cD/oUGZmsNWsyrq4ehldUlORWqOR3n32UMemCkPu+dsve7VOxUy+1pwtB+MrqWMzs
	 DAbpYqbZ2nW8s/nTibng/cgFiryJ/2R7bdrWrN1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.6 0145/1266] staging: media: atomisp: reduce load_primary_binaries() stack usage
Date: Tue, 21 Jul 2026 17:09:42 +0200
Message-ID: <20260721152445.050337217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit f4d51e55dd47ef467fbe37d8575e20eee41b092d upstream.

The load_primary_binaries() function is overly complex and has som large
variables on the stack, which can cause warnings depending on CONFIG_FRAME_WARN
setting:

drivers/staging/media/atomisp/pci/sh_css.c: In function 'load_primary_binaries':
drivers/staging/media/atomisp/pci/sh_css.c:5260:1: error: the frame size of 1560 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

Half of the stack usage is for the prim_descr[] array, but only one
member of the array is used at any given time.

Reduce the stack usage by turning the array into a single structure.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -5224,7 +5224,6 @@ static int load_primary_binaries(
 	struct ia_css_capture_settings *mycs;
 	unsigned int i;
 	bool need_extra_yuv_scaler = false;
-	struct ia_css_binary_descr prim_descr[MAX_NUM_PRIMARY_STAGES];
 
 	IA_CSS_ENTER_PRIVATE("");
 	assert(pipe);
@@ -5394,15 +5393,16 @@ static int load_primary_binaries(
 
 	/* Primary */
 	for (i = 0; i < mycs->num_primary_stage; i++) {
+		struct ia_css_binary_descr prim_descr;
 		struct ia_css_frame_info *local_vf_info = NULL;
 
 		if (pipe->enable_viewfinder[IA_CSS_PIPE_OUTPUT_STAGE_0] &&
 		    (i == mycs->num_primary_stage - 1))
 			local_vf_info = &vf_info;
-		ia_css_pipe_get_primary_binarydesc(pipe, &prim_descr[i],
+		ia_css_pipe_get_primary_binarydesc(pipe, &prim_descr,
 						   &prim_in_info, &prim_out_info,
 						   local_vf_info, i);
-		err = ia_css_binary_find(&prim_descr[i], &mycs->primary_binary[i]);
+		err = ia_css_binary_find(&prim_descr, &mycs->primary_binary[i]);
 		if (err) {
 			IA_CSS_LEAVE_ERR_PRIVATE(err);
 			return err;


