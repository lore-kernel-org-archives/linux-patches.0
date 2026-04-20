Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396102E093A;
	Mon, 20 Apr 2026 15:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700443; cv=none; b=sab1a2+OUJJZa7UrqEDgahDlXhsxqeGf/I0CMGGl2nPONHOUvF3gvwjE/SZBTzOwkmBkXDb0qoFewOGKVmGCicflup5BMER6rbiIWHrg6jREwuGpUjpYavTftfQHd6Ns7w2IXV6EY/8rBATw7Eq48yHVPKWoohWebxPEEJCbbHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700443; c=relaxed/simple;
	bh=6DUR/xdYLl5+m1L1FZk1aGUs4f9grH2err0zOOBTW+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwoMPHCuA+SRJ+JKBYGdDjOhR5B+3PR07swvos8gcHdFWLu4TScGh5NDUGlr0QmhBQ25lJwn983UGjhzpH0M06yvna+Wa7W+kP0B4hWfwc6/GPv4eKjuaUscYtof5dguJgktCfrK12l1S/jFjAq6pPVM4snm5j0XxvQKW8Lcq5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1UIDX2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1UIDX2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C493DC19425;
	Mon, 20 Apr 2026 15:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700443;
	bh=6DUR/xdYLl5+m1L1FZk1aGUs4f9grH2err0zOOBTW+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1UIDX2CsuWcPnBbA5XMAomsEq/lKFse/5Kzrvx46VHXjzrASWBu5etQiBcpd02Nq
	 zsVu9r6xDiAhKcMjkezH1nAC9VPEZA5IsEPqf37qWDO0GCChVAC/uL7uc8XzJa1B9+
	 H+5Jy5xv9lWUlU5izt3L8DGyZNjdJwXV+9jKzLXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH 6.19 173/220] staging: sm750fb: fix division by zero in ps_to_hz()
Date: Mon, 20 Apr 2026 17:41:54 +0200
Message-ID: <20260420153940.255103126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


