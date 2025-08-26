Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9F227EA8;
	Tue, 26 Aug 2025 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215666; cv=none; b=cw1WBaXZBe+AqN+00MA6tSfIyVpDUQkY9P/K0537dt+EGJ/HekxWc+KChglcYECFE3wN8cS2/Y2XYRvzR5xlG35rMPJ9fB2NuAVWBjuA5+nIdoFmVUWvnoYlu6115CW3Z3Pibly6pcY9OE2OPkpt+3vGT6MYn0qYXXHtDihNXxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215666; c=relaxed/simple;
	bh=RJJefDYsdH7Pyole5s74GXQVB40KKl2OTW0TNI3HFKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtmW+GAgHwSRaFDeEVfmSaswQsrl/5sbFNJP1FhBYKutT4C1J/7MZCIFS9yCqLdWIk/3aP28XbelerbbVap/Q4kFn6UZmUhYDZJtb3F7XgIhbS7fiM5vzLKXUvLXjGoL1hIQYGDgKJIcyBL72O5iMDLB62YJHpvcS6C3oRn/4mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTE1s2am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTE1s2am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A069C4CEF1;
	Tue, 26 Aug 2025 13:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215665;
	bh=RJJefDYsdH7Pyole5s74GXQVB40KKl2OTW0TNI3HFKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTE1s2am9os0FBDrgcV18HTguIfHQcOEvI0fukothJP6VPtmb24Rx3DDxQrbHYF8s
	 3ALQ9dJB8R2JKX2zqd0V0rWWi7z600MnnTzQw1ps72OMAnxuK+aqwh5r3SO42qnFAM
	 hxHYU+F+xK2mwr24cdF440bOZcvwxKW/zbY3R9wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/644] staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()
Date: Tue, 26 Aug 2025 13:03:30 +0200
Message-ID: <20250826110949.470682164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit eb2cb7dab60f9be0b435ac4a674255429a36d72c ]

In the error paths after fb_info structure is successfully allocated,
the memory allocated in fb_deferred_io_init() for info->pagerefs is not
freed. Fix that by adding the cleanup function on the error path.

Fixes: c296d5f9957c ("staging: fbtft: core support")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20250626172412.18355-1-abdun.nihaal@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fbtft-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index 810ed1fca10b..54620ae6919b 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -747,6 +747,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	return info;
 
 release_framebuf:
+	fb_deferred_io_cleanup(info);
 	framebuffer_release(info);
 
 alloc_fail:
-- 
2.39.5



