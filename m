Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5133B42CB;
	Tue, 21 Jul 2026 22:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674172; cv=none; b=QIEChnGyi7YAcrugpQqyaHcmBuv2NOG5pPudR/43jF85SvWFkHdIF7xLRX/ld2Qrj/9S9tY953PCyyeOjhyMiGkrklBaAKc+g+POGxsVUhMuA+TISapzX0uWwS4mLTR5roLvL03Ph0eFCxll1Wg67MfipupDDTEGHMVjgmrhYmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674172; c=relaxed/simple;
	bh=qzRbo2RC6TjRnpAoA1n02XajH6G+1GAdcLTnO54kGjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch4zWGQFDepDedpYx4O4JsxVzv/0IztQaKspBeIQEzNYI9CAEe1VrCsRAzDFLtOx7tPZR46tt53ukgewxVRYeKE8j58kC0lnTv5HXVw73EaexkkrLZJn5/dgxG8GyW9c4VDyurISv+2asrpPxl5MrCaJaKe3ZCp9M4W8yqkoFW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZEgNMbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZEgNMbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF3D1F000E9;
	Tue, 21 Jul 2026 22:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674170;
	bh=AkYkEACHvhyY9esQ1TLsFtWoWwHimEChP4oBEI4Mfr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZEgNMbLw3UTRy/989aV0Mpl8n74MT/wOmwjrzLSc6M1yj74n0B5Ys+tPcVnBMZR8
	 kjDTnUVK89No3PlQ3FIvdo1R8tBvTES09GULNQchc4c+JoCj9BMF6r9NbwPIxKtaGU
	 e1ubtmVuLVFBOmobIJNxstne4+sSMPAW2DguK9M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 439/699] fbdev: uvesafb: fix potential memory leak in uvesafb_probe()
Date: Tue, 21 Jul 2026 17:23:18 +0200
Message-ID: <20260721152405.600541049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 033e56fed09047ee63072e9f58789f40c1c7079d upstream.

Due to an incorrect goto label, memory allocated for modedb and modelist
in uvesafb_vbe_init() is not freed in some error paths. Fix this by
updating the goto label.

Fixes: 8bdb3a2d7df4 ("uvesafb: the driver core")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/uvesafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1698,14 +1698,14 @@ static int uvesafb_probe(struct platform
 	i = uvesafb_vbe_init_mode(info);
 	if (i < 0) {
 		err = -EINVAL;
-		goto out;
+		goto out_mode;
 	} else {
 		mode = &par->vbe_modes[i];
 	}
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		err = -ENXIO;
-		goto out;
+		goto out_mode;
 	}
 
 	uvesafb_init_info(info, mode);


