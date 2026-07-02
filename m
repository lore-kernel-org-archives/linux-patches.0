Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F9F417350;
	Thu,  2 Jul 2026 16:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009763; cv=none; b=CEOXpIcCuvqAiYQmtXoobXaJzW+0I4x+gbq35oJ5xijRC3duOJel+nIGwBIPTIrxEs3XkuqVfsp9AUjNojo7jR7jn1aEyTfBwLtqd6mj/nSbJCg2zhOn8+eSqmyPexCS1RujBCNBWmqR9UPckUTXFGgUQ+HapwMAL1ICyWiKelk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009763; c=relaxed/simple;
	bh=ww0G4Xis/O98MFl++M2OOm89lS0/4JuxhSCsYCY5TFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HT1267kf5uguPGrEM3eLgcfwLXxKRMpkQSHK6IbhjOdSOGXu/9u2JFjUc45suIISS/vW+yocTPfl6WrWM0njtACuo6xbIDAybaDhG4EmnVWqBU6uayv0geAJLb2tUTE+WjxJ175Wiy+v65AphZnx6elWK00199EsvCxaPMl0Vck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9cEQuY+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9cEQuY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E97A1F00A3D;
	Thu,  2 Jul 2026 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009759;
	bh=ZZIVxnzYcb3cftog1GmBd8IlvlKZmGS2TRHsrK9XKqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9cEQuY+vbFhbHMPm96fttbCYrt2aaXIE9vm0jbaeaur9pxx7NWAiZWwzY9lE7rQQ
	 7Qyxc2kk5hynboyfonsKMEyXMpAXnVFWLBbqb3/l3IObAB2VRyuJ/jlIVPz+d57xsT
	 +cKXIOYQf/53ouLXLohX1ZGWXxbtadjczn01ObIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Persvold <spersvold@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 76/95] fbdev: modedb: Fix misaligned fields in the 1920x1080-60 mode
Date: Thu,  2 Jul 2026 18:20:19 +0200
Message-ID: <20260702155110.811651334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


