Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCD130C15A;
	Thu,  2 Jul 2026 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011402; cv=none; b=W4ZyZqkacn9CEkqz5wjd1yyRtgGk94kSLT5V3HUzGUtIJKPm4q70Sb7hvCBvuWw58EpbK0E18oBt1QeYNPejqxbCdDosIqdV945OHdoNMe2NG3LBmhMl3p+C6HyILI6t+okiUYT80IkNX7PrxSJm4AU8SqGLGkG6zx7FwdNdCB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011402; c=relaxed/simple;
	bh=gqumo8JNf6ENbRRAFYXJdq/k9cJPrg8EZ1A2ZLQO1eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdJ/uYUnmNl8R2mnHkXac9BXghgDf9ejkL38heE38BmMv0N6fsowfybWOD4jnfMXLh0cwO/VYkmpyg6b8z3sO572/VTPNTL4dZL87Xv32GAWRAEc4vAvgqJbU1nvJ8PS73gDOynVC7J5wCeaCrOJqPDCFZhljVvFJzFtg2oq6gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ue4sxw1/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ue4sxw1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AFE1F000E9;
	Thu,  2 Jul 2026 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011401;
	bh=4CccxJ28rrqyZH+oEUxCOg8XrHHrGpaIEPqvyvNQMuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ue4sxw1/ws7hzQnUc5QZoTEACx4gB0JXG+CrfTCd88jNtv+L2huzv3Mm5xJV11Ld4
	 ny4kDqEzhbZ3lpJk9GJ9IdKMfvG/ATLF+aa4Qtbt9KaAyVusq/BLERRrds1jqZQSaM
	 +EPvfderhSr6xQ/z3fgDvhzMV/6OylgTYcH/RJP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Persvold <spersvold@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 093/108] fbdev: modedb: Fix misaligned fields in the 1920x1080-60 mode
Date: Thu,  2 Jul 2026 18:21:30 +0200
Message-ID: <20260702155114.037501607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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
@@ -259,7 +259,7 @@ static const struct fb_videomode modedb[
 		FB_VMODE_DOUBLE },
 
 	/* 1920x1080 @ 60 Hz, 67.3 kHz hsync */
-	{ NULL, 60, 1920, 1080, 6734, 148, 88, 36, 4, 44, 5, 0,
+	{ NULL, 60, 1920, 1080, 6734, 148, 88, 36, 4, 44, 5,
 		FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 		FB_VMODE_NONINTERLACED },
 


