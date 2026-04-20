Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4993336885;
	Mon, 20 Apr 2026 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699829; cv=none; b=Guk7xCbQBTBVjtJB/ZsmjCLa2svYiqWWdAZ3b3L++ovobx/D60JXwoZyeSWEsGUtsLyOhUw4AkxOjb24cMhkcQIWFQyRoXPUikw704NvQmRjbFMDx4cCjA8s4QxRXhxy9Z2bRhFKY7KUO2ZbsJOZ3Zkhr2L4nksDkS/azH35ElQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699829; c=relaxed/simple;
	bh=amsu/p3IJNRLTkaHKPz+xqXsUJ1P9CdAeriYjEFJ0iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+W5fnQ15TLrIS5M3YRasmgBjlfQ/tMA+aFF94xs5wPLy8TEHEXXTSWKfqglSiTogMbwkWWA4vdEB+D27Anc/+J9Nj8j86lgzUbQcfAxsgPolzGb+tZB4AKrhFM13LU/B7Q0/I+8z2hT8T34Pf7/zqSfhEi91dsbR7EefXA2YkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AG4RoGkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AG4RoGkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCCAC2BCB8;
	Mon, 20 Apr 2026 15:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699829;
	bh=amsu/p3IJNRLTkaHKPz+xqXsUJ1P9CdAeriYjEFJ0iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AG4RoGkMmaqgjk7FyxLjXiOt8/Cim+wEWtk0mbB7WuhKf/moXMEcI32T+9E5+bpmz
	 URA9DmM0WVI5svt1ADqO5wTFtV4S4hghlwvVEYrg/hKNGuBcpwFhTHgGFAmeqHXo3p
	 NKTzyW1UbRGxQ+PZBMta1VVdLTnb2JU57YzcP6MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 14/76] fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Mon, 20 Apr 2026 17:41:25 +0200
Message-ID: <20260420153911.340968729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -496,6 +496,9 @@ static int tdfxfb_check_var(struct fb_va
 		}
 	}
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (PICOS2KHZ(var->pixclock) > par->max_pixclock) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


