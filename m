Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B004429802;
	Thu, 30 Jul 2026 15:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424473; cv=none; b=JdTIx2C2cJ5xLTKloM7+RgEOuAnsVpDjr6896o0Iq3v9Or7ggI/2eVYpBKuT1LNimSQ5yI6JxLO/u1p6dlSLAgUlEz9an4AKowpcfIV+KyeKuwkh0E3+C87TG1KzTrMjwUn1+/DH6c1f50HRnidvVzdyDnQPTqRzQJK+a5y7cis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424473; c=relaxed/simple;
	bh=Nt73zHkCQhHUVaLh3TayL+IIdBkFs0yOKFTMKmFJd80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+rsdVhzE8fgxABmTK31VsBTeCBgE/3bQXzr57+dmS3eGtE9GZFchlklrTRlOY7LUE+nMMPxD7RTjH5wV5HseP6lvkfSCKQDSiBmqdmQ0COGwnlj64O2VHWc4ghRkizoMU3W2OWLiEsAbQTxGcUFwh1SzJ7Ofvb/HABodsk9moI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHmIzgUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHmIzgUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C6E1F000E9;
	Thu, 30 Jul 2026 15:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424472;
	bh=euB02EQRTlZ9itod0HvGdaZKk/nZTRC4SDdxKEgDr6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHmIzgUnvUNRPrUAxB9y4QtVdr3n0NRyJyevCXkjc6tp1khSbWRRpJB4wC1NlMcoI
	 fp+c/d6GalEcnHOuyo+EBbef3bXdyMGO1uwk84w7zv3BLAb8uiuOb5HFFsdpWpBK7S
	 WVcqdi6hVX84+xvFqqxkbufnXN6H1Malk/9cQNf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hecht <mhecht73@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 404/675] media: i2c: alvium: fix critical pointer access in alvium_ctrl_init
Date: Thu, 30 Jul 2026 16:12:14 +0200
Message-ID: <20260730141453.722186337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Martin Hecht <mhecht73@gmail.com>

commit 4f6f28ff24709710c08557c127b3e4c3fb1b4159 upstream.

The current implementation of alvium_ctrl_init creates several controls in
function alvium_ctrl_init and uses the returned pointer without check. That
can cause write access over NULL-pointer for several controls. The reworked
code checks the pointers before adding flags.

Fixes: 0a7af872915e ("media: i2c: Add support for alvium camera")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Hecht <mhecht73@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/alvium-csi2.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/media/i2c/alvium-csi2.c
+++ b/drivers/media/i2c/alvium-csi2.c
@@ -2100,20 +2100,21 @@ static int alvium_ctrl_init(struct alviu
 					      V4L2_CID_PIXEL_RATE, 0,
 					      ALVIUM_DEFAULT_PIXEL_RATE_MHZ, 1,
 					      ALVIUM_DEFAULT_PIXEL_RATE_MHZ);
-	ctrls->pixel_rate->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	/* Link freq is fixed */
 	ctrls->link_freq = v4l2_ctrl_new_int_menu(hdl, ops,
 						  V4L2_CID_LINK_FREQ,
 						  0, 0, &alvium->link_freq);
-	ctrls->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	if (ctrls->link_freq)
+		ctrls->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	/* Auto/manual white balance */
 	if (alvium->avail_ft.auto_whiteb) {
 		ctrls->auto_wb = v4l2_ctrl_new_std(hdl, ops,
 						   V4L2_CID_AUTO_WHITE_BALANCE,
 						   0, 1, 1, 1);
-		v4l2_ctrl_auto_cluster(3, &ctrls->auto_wb, 0, false);
+		if (ctrls->auto_wb)
+			v4l2_ctrl_auto_cluster(3, &ctrls->auto_wb, 0, false);
 	}
 
 	ctrls->blue_balance = v4l2_ctrl_new_std(hdl, ops,
@@ -2122,6 +2123,7 @@ static int alvium_ctrl_init(struct alviu
 						alvium->max_bbalance,
 						alvium->inc_bbalance,
 						alvium->dft_bbalance);
+
 	ctrls->red_balance = v4l2_ctrl_new_std(hdl, ops,
 					       V4L2_CID_RED_BALANCE,
 					       alvium->min_rbalance,
@@ -2136,7 +2138,9 @@ static int alvium_ctrl_init(struct alviu
 					       V4L2_CID_EXPOSURE_AUTO,
 					       V4L2_EXPOSURE_MANUAL, 0,
 					       V4L2_EXPOSURE_AUTO);
-		v4l2_ctrl_auto_cluster(2, &ctrls->auto_exp, 1, true);
+		if (ctrls->auto_exp)
+			v4l2_ctrl_auto_cluster(2, &ctrls->auto_exp,
+					       V4L2_EXPOSURE_MANUAL, true);
 	}
 
 	ctrls->exposure = v4l2_ctrl_new_std(hdl, ops,
@@ -2145,14 +2149,16 @@ static int alvium_ctrl_init(struct alviu
 					    alvium->max_exp,
 					    alvium->inc_exp,
 					    alvium->dft_exp);
-	ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	if (ctrls->exposure)
+		ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
 	/* Auto/manual gain */
 	if (alvium->avail_ft.auto_gain) {
 		ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops,
 						     V4L2_CID_AUTOGAIN,
 						     0, 1, 1, 1);
-		v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 0, true);
+		if (ctrls->auto_gain)
+			v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 0, true);
 	}
 
 	if (alvium->avail_ft.gain) {
@@ -2162,7 +2168,8 @@ static int alvium_ctrl_init(struct alviu
 						alvium->max_gain,
 						alvium->inc_gain,
 						alvium->dft_gain);
-		ctrls->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
+		if (ctrls->gain)
+			ctrls->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
 	}
 
 	if (alvium->avail_ft.sat)


