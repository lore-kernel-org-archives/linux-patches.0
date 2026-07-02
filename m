Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B649348C5E;
	Thu,  2 Jul 2026 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009517; cv=none; b=Xt6AczI/grWg2Y8C0MJlaWCUKUirL2rk0ieFdjfqXacce6zCVSNocRa9XmlTJVms6J7YjrLlow/O0K27wPzAAlyzYpdg4We9/Cc9+FfG5UAZcH01prCBNEYNcxpn5KCASuOQ/EhTFmbuPbhsC3Fyg7rEJ9iwAIH/PhwHP1yka/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009517; c=relaxed/simple;
	bh=iCz0B8VRW5lvTea3xEgCskByaVMIwaQBmFwRWcu9Q1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z73dlGKbelxHcF2PqLCuqNJlTVmatFHVP0txu9xxiLEOeLsWLtbLnWYbo5m7rqYZQ2Mn9UfaY1O3GZ9wmP/CpsYS/SFfk7nFz+Z1cXUAIjEvSX+bh6G2bc6dZNHIVXLoMYJthagBT2za759uCbuiyXWXpRtQHYOGK8tp7WKJC2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlUkXaeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlUkXaeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBF21F00A3A;
	Thu,  2 Jul 2026 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009510;
	bh=KNOsXQwrEvmm68J07x+yQhK1co375+5+PmZlmZvlTLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlUkXaeoBs2fxzWoy/4L/8xLEQnj/qBYUN07wyOUPf/8ZZXONJ2c7COTUxEposUfn
	 xvJd5RAQhfNKQMoY2AwwkrXCoeONEBNb6vh3y1h14VArHShkNw29IOMRBNAyEvtDyB
	 JFgRS7xv6FTW/8PirGvR9G0nShgeBh1I+EoVaUrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Persvold <spersvold@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 78/96] fbdev: modedb: Fix misaligned fields in the 1920x1080-60 mode
Date: Thu,  2 Jul 2026 18:20:10 +0200
Message-ID: <20260702155110.622499713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

From: Steffen Persvold <spersvold@gmail.com>

commit d894c48a57d78206e4df9c90d4acfaf39394806a upstream.

The 1920x1080@60 modedb entry has one too many initializers before
its sync field: a stray "0" occupies the sync slot, which shifts the
remaining values by one field. The entry therefore decodes as
sync = 0, vmode = FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT (0x3,
i.e. FB_VMODE_INTERLACED | FB_VMODE_DOUBLE), and flag =
FB_VMODE_NONINTERLACED, instead of the intended sync = positive H/V,
vmode = non-interlaced.

fb_find_mode() then returns a 1920x1080 mode flagged as interlaced +
doublescan with active-low syncs. Drivers that honour var->vmode and
var->sync when programming display timing enable doublescan and the
wrong sync polarity, corrupting the output.

Drop the stray initializer so sync and vmode hold their intended
values (positive H/V sync, non-interlaced), matching the adjacent
1920x1200 entry.

Fixes: c8902258b2b8 ("fbdev: modedb: Add 1920x1080 at 60 Hz video mode")
Cc: stable@vger.kernel.org
Signed-off-by: Steffen Persvold <spersvold@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/modedb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/modedb.c
+++ b/drivers/video/fbdev/core/modedb.c
@@ -258,7 +258,7 @@ static const struct fb_videomode modedb[
 		FB_VMODE_DOUBLE },
 
 	/* 1920x1080 @ 60 Hz, 67.3 kHz hsync */
-	{ NULL, 60, 1920, 1080, 6734, 148, 88, 36, 4, 44, 5, 0,
+	{ NULL, 60, 1920, 1080, 6734, 148, 88, 36, 4, 44, 5,
 		FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 		FB_VMODE_NONINTERLACED },
 


