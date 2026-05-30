Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD4221ADC7;
	Sat, 30 May 2026 18:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165351; cv=none; b=sEtfD3daO/6qcQwEMKCDzqoR+VNvF8yB06xR1tw9kA0pPLeGu+6u5W3tObZWP55gwTmWMrKjL/I8izIG/DUeHSqjVgXex3nwbjXTNNupazI4tii8Fhqe3Zgfr+UIBolud2J3ZE+0REIbMeENJZPcQwAAGtmsGkO5z7u3m60zcx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165351; c=relaxed/simple;
	bh=kMwNDafhdbzO8HjIS0SCXoaKRPWdNrz4qCNnIPx8yfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEIZdOAw6+UyWURSwvZCMkkdL3ZDDTYP+sh4LveRcdXCt9UGJOaQrwWM7u63GUi5qMfL/stQI4x49a/7bPQFW9AOR4DENC3Aal2gQijWkLmT2K/mzWLcBbz2Uf6EwyODFisztMwRf66V2hBiKv7UefW5yHVl9TIZqTzFYl99MLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCC2NZBl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCC2NZBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A406D1F00893;
	Sat, 30 May 2026 18:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165350;
	bh=tHFvfLIzGf//Z+keStRLv+6pAZFPzjNh2Qx3oTdkOUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCC2NZBlZzCfyYrsn+Ck6JF9vs6ZdxPuK2VpMQq9Bu5rlT4OyPYX+6Cv+gzfOJI16
	 BI/Lt8Of01/RiMYUxw/Y3AxwpEKjAfwqtVU/0Zvi1cj7e/nl4pNLBST/GCuAh6Xc5U
	 KtfiznNUfH/6wHatktyLSbCIROYdmzQ4NVU3ubF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 052/589] fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Sat, 30 May 2026 17:58:53 +0200
Message-ID: <20260530160225.959414478@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -497,6 +497,9 @@ static int tdfxfb_check_var(struct fb_va
 		}
 	}
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (PICOS2KHZ(var->pixclock) > par->max_pixclock) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


