Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D80329C6D;
	Mon, 20 Apr 2026 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699968; cv=none; b=u9dLB4Eqy0G18ztXGBeXbHB3WD5e9qKYyP8AXXIuVULSe4nP/Z63P6DJRqvyn6kc1unVfLSWuQuOK4ckmCgA7XVIU5tZ9nGAckAYy9KrRnIOeCTZydLHjRqAC1m/8+NPRitkGBhPACRt7jYkRCxzMEPvGfixUY+huL3F/TPDWZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699968; c=relaxed/simple;
	bh=QCvdH3wWj8SdYExyNYjueMUxThcx2mT9dUL/96ufOXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMTvjZEjq1tnC1fjxB6qtbnfX6dB90rUORIrvAu2a68BREcT+j7A96+GfXqekwkpQhyb9sLytO2jS20Q0ykBCjdvSjf1x47+uX4nx9zkTxIDua9HgwXJExQEEy/xijtz09rqiROHDMNOYAELjJwVf1ytOyX8pxb6+l5PG79IO64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5J3fi1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5J3fi1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D15FC19425;
	Mon, 20 Apr 2026 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699967;
	bh=QCvdH3wWj8SdYExyNYjueMUxThcx2mT9dUL/96ufOXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5J3fi1m2QqmrXtZI0lORqDDxUb0WX/vEaf0+dBqkHER4Uf2wrZFF3ucl7GFdpU0e
	 VSqn5Eti+kz1rKmtIx9z1byu7SkwCxhU8ZuOVlIWqsSBVfkKnDS3Jeiump6jIJLq3u
	 R/86NyUeBgV9rbPrP0PDgHxP2wz6My/NwfQVNwJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH 7.0 35/76] staging: sm750fb: fix division by zero in ps_to_hz()
Date: Mon, 20 Apr 2026 17:41:46 +0200
Message-ID: <20260420153912.100403486@linuxfoundation.org>
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
@@ -481,6 +481,9 @@ static int lynxfb_ops_check_var(struct f
 	struct lynxfb_crtc *crtc;
 	resource_size_t request;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	ret = 0;
 	par = info->par;
 	crtc = &par->crtc;


