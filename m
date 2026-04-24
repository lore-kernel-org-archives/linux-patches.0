Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E9723645D;
	Fri, 24 Apr 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037844; cv=none; b=VY7r+SCaS2sunQvORRbI6YN0d9rMbvxfb/0HhaLWw7Sz00rpBRFDjKcdhNez+JwQumjIhgZ2cASex4rjNFudHdUR+KeKm48gBaffmwaoHbnD3nEUMdCWabIUdFtHmDiPg5VhDJL9sj0oF8iiOkYNdDYQrONYQiH96vdIX2/CzKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037844; c=relaxed/simple;
	bh=uaeoTksckU5DnBonlmsG5eBQVTDCVrbWttkm+W5ESsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuTgcLre+aKMnv7zGFbEFGqSZOvkRssYynaNeZT7a3Vmi+1QIgfyEI525UgJQ9MAfV1U8b7VxzCN1XK6iH+HYriS6O/DSzgl76zvlKf/nH3rVg8b3q/ZtEA/6Hh7kl7VCmX8jEY3N2ReHis/fQ/gyXxhntav8jodKWKWeuJI/Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0D3q1jL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0D3q1jL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166DCC2BCB5;
	Fri, 24 Apr 2026 13:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037844;
	bh=uaeoTksckU5DnBonlmsG5eBQVTDCVrbWttkm+W5ESsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0D3q1jLNY0Ov8Xd0WmDM1EVK8oWRZzQ43w/In1NSDgHXJbaimxstDlOdYXVcIVrK
	 H2URFz7BLb9rOV7D4ch4EO3rLwc3sgPly8F1Dd8qGcy4SL0EJrJaWE2zdN2c83IUvc
	 GFwhrHQW34egc/kUDeaFSg2bcmCBNYAW0ptNcqd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH 6.6 092/166] staging: sm750fb: fix division by zero in ps_to_hz()
Date: Fri, 24 Apr 2026 15:30:06 +0200
Message-ID: <20260424132551.928846952@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -483,6 +483,9 @@ static int lynxfb_ops_check_var(struct f
 	struct lynxfb_crtc *crtc;
 	resource_size_t request;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	ret = 0;
 	par = info->par;
 	crtc = &par->crtc;


