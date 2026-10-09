Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18B33B3BE6;
	Fri,  9 Oct 2026 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557241; cv=none; b=RXme+YoZDeg71nzVfWVoIKuse6enLobrWpeckqjhLYOEiDGLNTMDnC70uAPGP8bWmiV5fkjza10gEy//m7MRdvyfmXaxzAlC2SFChhWdXyD6za97fVnHxRTeQdTuqNEzEPRsSX6m2BkVUgMVtXOCf4EQMKG5jx1qxBQXja/uoqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557241; c=relaxed/simple;
	bh=4sS3pytmzsPkWsM40rAXvGSujduhgA4oufv97avlh2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGrZ0vGgUqp6aJp0dzl898gNk2t5StNDMMOqYox3gQUhkhBy4h+4z0DTcai/grY5e3LioDC0/HaQdcmSLWRd2c0g/3dnC0KgEbN7jsJs4QH+y4WQn990MUEMFl/o11JZm+W4DySL7nWAvwq2PigTIKBRZW4Vb/9WON9AoJBEYeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCng2SXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCng2SXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D64E1F000FF;
	Fri,  9 Oct 2026 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557240;
	bh=m1QGSD32YGIuIE8RnExzwxQ7o25A32YhZ3O03h+k72k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCng2SXICEEF3sjexd8l0Bn/3dJzIaMTS2ov1YwTHDmurYr25PiM0scPN7K0yF8W/
	 trNtHok8Nfd26cBOr8fN8+gYuDf8hZnYlOgDlZDSam+LSHBo8QfsjV/kbIFmwX62DY
	 LcAB+fjGROnYnMR00qs37dpz9DecWQg/DgpmAG4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 324/428] wifi: cfg80211: fix RTS threshold setting for single-radio PHY
Date: Fri,  9 Oct 2026 16:11:01 +0200
Message-ID: <20261009140953.251373288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit 9eda41e32263806a66835e275efdcc0c5f46bbc4 upstream.

Due to an incorrect old_radio_rts_threshold check, we do not set
rdev->wiphy.rts_threshold for a single-radio PHY, and the threshold
value is not propagated to lower layers.

Cc: stable@vger.kernel.org
Fixes: 264637941cf4 ("wifi: cfg80211: Add Support to Set RTS Threshold for each Radio")
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260919092454.50266-1-stf_xl@wp.pl
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4562,12 +4562,13 @@ static int nl80211_set_wiphy(struct sk_b
 			rdev->wiphy.retry_long = retry_long;
 		if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
 			rdev->wiphy.frag_threshold = frag_threshold;
-		if ((changed & WIPHY_PARAM_RTS_THRESHOLD) &&
-		    old_radio_rts_threshold) {
+		if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
 			rdev->wiphy.rts_threshold = rts_threshold;
-			for (i = 0 ; i < rdev->wiphy.n_radio; i++)
-				rdev->wiphy.radio_cfg[i].rts_threshold =
-					rdev->wiphy.rts_threshold;
+			if (old_radio_rts_threshold) {
+				for (i = 0; i < rdev->wiphy.n_radio; i++)
+					rdev->wiphy.radio_cfg[i].rts_threshold =
+						rdev->wiphy.rts_threshold;
+			}
 		}
 		if (changed & WIPHY_PARAM_COVERAGE_CLASS)
 			rdev->wiphy.coverage_class = coverage_class;


