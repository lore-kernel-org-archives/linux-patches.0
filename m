Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1317021B191;
	Sat, 30 May 2026 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162895; cv=none; b=emWFAR77h7tI7wsmU3QYkp10gPAAODbAV3rR6rbfGWgV1AeVrSaPZf/9n29uw3E3otLkluxsgw5II76Z7LQlbUt/vf119FyFpNKDMMPBqIcGvt2S9uvCtWxgT8mcPe8tXuPq2FO5/lA2cY7UV/rJYcELUVWaUPX9hgVlFXwYkO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162895; c=relaxed/simple;
	bh=OOogqwug7Pr53U3omyNeQkCfnPQC5BZ9ZtKldNldaMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdaNr3asMtg7ZFsMs72x5ZP0w2rVATOioxV9bErv/Y5Hfwg/I/PjQkIsTM0dnIbEKYcNLhDss8ADSCVbJZw6OyIQcBUCIKFoMKtPBsPh7JlVr51/MKMbUh8os06w6gyEG+weE9RHdqkd90CqbI2v0POtv8qdFOcmoPc0KtMMoYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTda6BH2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTda6BH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AC31F00893;
	Sat, 30 May 2026 17:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162895;
	bh=iEWfUsA7hst/KQdMNi39yAZhbYVnIl6JAlFoVVqhRLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTda6BH2A1YJ/zbtzjUWxJbFVHmaR2BFU2+35hq7LqC8i8M3EVCoRwNVasnZ4IZiV
	 L3tAux0A+OHYgHsX0o5AFnHBULbFHIEslNpD0tUvvfawyIA3VHEMLM+2vDQ8zFhfM/
	 0pl9J3+etfgOqZx8dmpPzanROf1ImwgHag2CAAQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH 5.15 068/776] staging: sm750fb: fix division by zero in ps_to_hz()
Date: Sat, 30 May 2026 17:56:22 +0200
Message-ID: <20260530160242.076375855@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 75a1621e4f91310673c9acbcbb25c2a7ff821cd3 upstream.

ps_to_hz() is called from hw_sm750_crtc_set_mode() without validating
that pixclock is non-zero. A zero pixclock passed via FBIOPUT_VSCREENINFO
causes a division by zero.

Fix by rejecting zero pixclock in lynxfb_ops_check_var(), consistent
with other framebuffer drivers.

Fixes: 81dee67e215b ("staging: sm750fb: add sm750 to staging")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881AFBFCE28CCF528B35D0CAF4BA@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/sm750fb/sm750.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -482,6 +482,9 @@ static int lynxfb_ops_check_var(struct f
 	struct lynxfb_crtc *crtc;
 	resource_size_t request;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	ret = 0;
 	par = info->par;
 	crtc = &par->crtc;


