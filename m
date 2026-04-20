Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04374345752;
	Mon, 20 Apr 2026 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701496; cv=none; b=avrFdBvJZhaR32QVKGCT5EhMxcYce+wyUCn+riYK7N7V8pKFe2WHgpW3emcD8qoh7bp7j1fDd9TKK5+UHJ/OhrTSpXCZ4aEImi4JmE+8adiU+aQCmc32gPMnSP7z96w18qSxkJjraaWHOqwlv7erzXzP1P5eq43nGz3QwEXNtl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701496; c=relaxed/simple;
	bh=BjiLn8sj9FqqoJ/aYseAi4Yst0A6BzL7qhUFP5czsY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfUu9uJAjE56lAC14WQYadABB1yJuU0ZH2+xki8XJ3L7CJFTWwPBRnyzoTlj7emD0cOXCbMU5F6G82NqHy5lNObb+/lAzwNdIoKTElo3fOzFTc7A7G6/BoQ0hBhJjGoBxNt0PuSy+G2nCqZreEd6QqSjn0IUMQzMu6dJJPSmHGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZi1cfOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZi1cfOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911E3C19425;
	Mon, 20 Apr 2026 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701495;
	bh=BjiLn8sj9FqqoJ/aYseAi4Yst0A6BzL7qhUFP5czsY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZi1cfOyuLtGukGLveV12AM+MBVt/wt7ycpHCLw0KFAXeJSI5Z8mAGW0c86deQvMt
	 EoTB+YW0nuDmt3mhg41xAbN5Xxu8Qhn4Vz0LmTW55wApTT2XHJRLa9My5EB+B6Ag98
	 F2hQSL16V+g9jTjmkqeaySheQOceG1Dm5U5E3cKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH 6.12 119/162] staging: sm750fb: fix division by zero in ps_to_hz()
Date: Mon, 20 Apr 2026 17:42:31 +0200
Message-ID: <20260420153931.352468104@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


