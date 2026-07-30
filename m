Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6105644211B;
	Thu, 30 Jul 2026 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422574; cv=none; b=FYKQxq37d9ls88ehys9b0Y4kEAI5T7iv1X+3XeoTXAfwcDOGAH4GUaXWRL1MbxVczvCz0DTa68Mzhq1VN475e0P0YdgnCkLnFgO6RmIgBelXJ8yGxEmCFonwwjP7q02E4eCMYB8eS/n5a7mRXJc6jDSOIC2Vdj27/i9dzXp3yok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422574; c=relaxed/simple;
	bh=OOX2MA8+h4BIOh327GMzCqDZlNvJdyoMgrLujInuysQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gK8LfBmy0Lt5ir+/FhHDXi6Td2hK/vdl/Qd4ZdrSx8LV4PuPpNFNjH45G2c9L0+jh3fwTWwrKyCUOnZqQcqO8jXhltKlRGORhyWcKElEn+x0RlgZMM5kvCLwFdNVUuB8CKEN/b3uyVIeiRYl8yFXPGL+R1YmXsUuL7EuF88REi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxvDp9f6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxvDp9f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A840D1F000E9;
	Thu, 30 Jul 2026 14:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422573;
	bh=vo8Zm1d9Wh5yKLAHOd86N9v/+5w7SgQ+hMPwqftBWMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxvDp9f69j/nHpEDketQaIHXKwNT8/npT+4JvRaMtxC8vKBAexejLhLUxSbyRcUAw
	 qojO3H5JfJ8lASKGtSO3t+YEzLwL1WSnwLzVArvCiHspJjeTIQEOc5hn1l6R80X7oC
	 8ld/N8E7O/du2/5bgF7bEwGHaxu036LntaMV4iMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hecht <mhecht73@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.1 485/744] media: i2c: alvium: fix critical pointer access in alvium_ctrl_init
Date: Thu, 30 Jul 2026 16:12:38 +0200
Message-ID: <20260730141454.604551232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


