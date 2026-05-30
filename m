Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA46274FDC;
	Sat, 30 May 2026 18:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165379; cv=none; b=RNRYWDEfogq+CMteK4RvMGrKcTCvrKPF0v96nsVpGRPqnxWGELrAxOdQ/S07LmUe7NVRxuLRl76rSoAY1IswlkH/stVANfT02ENAu0G19kSvMRnoFLGHhe8HqDm6gss73WKrAM5AMy4xpSSIyh37MWtgtlydOoQSSz96lsdg3rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165379; c=relaxed/simple;
	bh=AosorFOD55V6XPVVldSvVeqC4b6gzvDDNrVBRXGCUCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kgmlb3VXshYxzI2QMZ91V3ziAUIQhaatcyeITmo8kL6691M1lQC6AXpMOaqHWkFisvPyes0RerrR/h6g8yqVjlPJqi7mE+VoIVptsx/rSulDHRU5zZqe4xO6YLYbV62MB1vMyEv9OUeqiCv6QSyfN06VUYhIXNKXcJ11Jw+pEUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yt2mQb12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yt2mQb12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB93A1F00893;
	Sat, 30 May 2026 18:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165378;
	bh=iN4aCzoxIHU8Qh7ErLCOuerzb9lI3d3yQxSeYIRdK/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yt2mQb125//DYxv9zt2ld7tP+HWnaRsZAYJmeEaW9ZaOUZVeEs4yPhLPD9LlNl8ml
	 5UKoNTd3PL8sIXpHM+NszCNidU/W9lo0tCxA34gY2ppdH/hozGP1QO7l1WP+OJXzuo
	 c9gu6XEdEByVzJAhgUs7MR+WIqhmL9DyKmXXRSec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH 5.10 059/589] staging: sm750fb: fix division by zero in ps_to_hz()
Date: Sat, 30 May 2026 17:59:00 +0200
Message-ID: <20260530160226.147701556@linuxfoundation.org>
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


