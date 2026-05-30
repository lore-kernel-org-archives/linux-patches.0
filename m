Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CB0157A5A;
	Sat, 30 May 2026 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158740; cv=none; b=EGA3nQzn/0bte59sMLg9nqUEm8mvp7Wfvsa+dN1L4Q1uBP82UbPiD5u6ANxKt8MKzVIeLHldvZrP/hr0CF7UZZ6Vy9/h71YcF1C4zdM8Kn4Gisg4PqeD0XKrv2uz+TANnKQtPb3gi4trwuo3l7dntWv/yhlRJs3AQyjKrsdwOIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158740; c=relaxed/simple;
	bh=zU2ff5lzH+/seuFutKfOe83tmUI3RV3p4+0bT2ITKSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyIaeRIbZ0R7j0M5MScZE75m2bFp0uk53MvZcvpF2tAPJFXxLPPAWAJ0KVwVAzBwBllm8VQtY8BbfXRpPn8xD6WK9+piaWULMAyNFGoYO7yB2LGdbj4q7QAqrsRLDDcaAf+bTUWdKkUlPKsBxqv2A8V7c2ndHGhasbk6yXGYylY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RcejEqr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RcejEqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF71D1F00893;
	Sat, 30 May 2026 16:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158739;
	bh=Ws4HbMOSKD+jmFtn0rNHJN5AWN9yFtrr4DH9wijBz6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RcejEqravEpAEclcPGe6xwLqOJd3M0vfU580y2vKwTKV6IN9VgUx3+GBkDh3co0Z
	 zn7bkDO0gFsm70mhfGYHWgGpwJpYAoY3MsTPZ2RwgieGWCOTuu0DZ75s2YE1fGIB1O
	 KResMe+YMKIEov9sqdY0xttV31OBbGGeRR3YoksQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH 6.1 078/969] staging: sm750fb: fix division by zero in ps_to_hz()
Date: Sat, 30 May 2026 17:53:22 +0200
Message-ID: <20260530160302.505596204@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -484,6 +484,9 @@ static int lynxfb_ops_check_var(struct f
 	struct lynxfb_crtc *crtc;
 	resource_size_t request;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	ret = 0;
 	par = info->par;
 	crtc = &par->crtc;


