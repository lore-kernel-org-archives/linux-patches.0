Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CEE35C6B3;
	Tue, 21 Jul 2026 21:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668257; cv=none; b=I/+HJuKorgQv1bHoqMOSIiXazVSCTCFx/dWmzIwhrNxEu3fVxmW0sgMBVKM7zYtPzaBOM2y3hbXAXOWwSN8zfTdblgLrfJxogCqvhBVkyjvqYNJq5FrXWNCK9C8J8qkvsPYF0ZYOUoDmFTJF8ZkLbBPjUUZmz3NahXmz9otSMuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668257; c=relaxed/simple;
	bh=vjLW1I6G25lsgtRR0hpKE/aGj98VthlOGY43ia6wemw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8/3XQ7IXsOk+Pa0Zbgiw/6/Z3K6Rw+S4dg7W7z9y++KHGXHApEUGbj63g1691ZaVekjvr9JvrhaEcH2j7gEP2WB1ZtbMrt35nA7YRXo6QJaQXjDHgumRQr4DYaek5nBsVY7mAPDx2oMP98pSVJAH3AtX48YlA47u0yrCCYQEqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAQjlzfi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAQjlzfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD1B1F000E9;
	Tue, 21 Jul 2026 21:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668256;
	bh=nKVOiVYIgNN3h0P9Q59O7IQZ4iRQxO41tBgD3PO/Sa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAQjlzfikLo9w9zpBeIXrlgNekvT9cA+XO4E9BoJHsAIeUS1Ox43yyTrC+Dv5+b74
	 ozk/D4g9P8ElD4+MpeM7XziBTHE8YdibZYAbo2vDy3oatnaEqFIkh/bpLYaRgp2Pu1
	 0xOJA4PBoyDXHimIfXURGee9L7B7VGnHsechcm/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.1 0108/1067] staging: media: atomisp: reduce load_primary_binaries() stack usage
Date: Tue, 21 Jul 2026 17:11:49 +0200
Message-ID: <20260721152427.004613021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5464,7 +5464,6 @@ static int load_primary_binaries(
 	struct ia_css_capture_settings *mycs;
 	unsigned int i;
 	bool need_extra_yuv_scaler = false;
-	struct ia_css_binary_descr prim_descr[MAX_NUM_PRIMARY_STAGES];
 
 	IA_CSS_ENTER_PRIVATE("");
 	assert(pipe);
@@ -5637,15 +5636,16 @@ static int load_primary_binaries(
 
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


