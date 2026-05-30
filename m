Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519A133E36A;
	Sat, 30 May 2026 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162782; cv=none; b=OeKJVPt5d6SOXS3SVF0QnUWP3Tk7BgkUBSr1iBjQeJXqLjk3jvSg8ZNwieJUPFsDjanDmZdyLXBi6ZmgTuVHP6+gNnLNWNzyrVLxIzQEWENhTlOgsMGhoOTK+98XA62klST+6pxI+qVwWHWDLY/5vlekb9IqBy9PEYJX1cB8ja8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162782; c=relaxed/simple;
	bh=+6aA6IvtKEjw2WVTCMX89VVJvD1lod3ynl60BDxydGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZyiGEtMBObudCNou8MdueGZUekDcJyeJGqJa9e+ZLrw3HdjKA6wEkXPcoYwitGrSsQJbGuLgelXLBbHBdH3QFSkiQafoVIdEVkbPfkvusjdfKX4WHGoLnB069SiU9ZQ/KOy2XsSF1KLRzpMzPUWMm4e5VjlCl6t1W9lRLhcyC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DG6MLtpU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DG6MLtpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B251F00893;
	Sat, 30 May 2026 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162781;
	bh=70dK1XOOIIT05HNToA+2cxT2zzPgan/4jb26z9gi9/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DG6MLtpUZO6RdI1nklTUPU4NRZ2AVv74Gkqqj31/H/fMEm9GKnGQqVmhZD78PMt75
	 ISD9arJqEw5vckunKZ2PoG+1XQH+QS5DQeB4vwJUJv5hoAkrlTWsAAqPtCnXCYS6dA
	 bhljM9sS2D3Jkjoo4jg/JXJxsmXZ0ZDiZJD8HCiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 061/776] fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Sat, 30 May 2026 17:56:15 +0200
Message-ID: <20260530160241.893729649@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8f98b81fe011e1879e6a7b1247e69e06a5e17af2 upstream.

Much like commit 19f953e74356 ("fbdev: fb_pm2fb: Avoid potential divide
by zero error"), we also need to prevent that same crash from happening
in the udlfb driver as it uses pixclock directly when dividing, which
will crash.

Cc: Helge Deller <deller@gmx.de>
Assisted-by: gregkh_clanker_t1000
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -495,6 +495,9 @@ static int tdfxfb_check_var(struct fb_va
 		}
 	}
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (PICOS2KHZ(var->pixclock) > par->max_pixclock) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


