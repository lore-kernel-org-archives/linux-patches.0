Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A09306D3F;
	Tue, 26 Aug 2025 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217274; cv=none; b=AoRVTsWlw45n+emv0tkwc9PiQIyeizdy8JhVt8bNCAHq5iPPmhkELHXxSHm+KlRnwWIQ8YeQg+hWJFk0Tvi7JmDBmCF4/frz3wl2iBBuwuq9FvvOEAJYRJCABqPUCatI6olhL7cFZviNHrDSztyXlxTkYrFjBey4YnaDMvYCW1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217274; c=relaxed/simple;
	bh=AoRDQm+hgcmu7KpEstdm+wIDk8/+8RJ4J3QF2YT5Iug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxC8512IPK+voGgdDK8ZaCSn16YoQ9QxG+O8WfiahTqFRSi5pTVCWhU6Se7xiWwH0GCH+cKp01gv+np5oBulP0Pmojpb383oMnHC1xH2kyhejEQcjghUD1Ya8MOwj9anFGuIGRgO7+NUctgf2qNm4BL+VPqKJEtI+jAzc1OzLsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjxwW6f/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjxwW6f/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DE5C4CEF1;
	Tue, 26 Aug 2025 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217274;
	bh=AoRDQm+hgcmu7KpEstdm+wIDk8/+8RJ4J3QF2YT5Iug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjxwW6f/D2Ta/tK9Vh7r/3AB1iif95onSpgqCE7gnWH8/ACB1/eOUplckTxrzaRjY
	 9BR+tFfPf5IXiG7admcQNm7eY5+p6Gnfrcc0sxg3IigefvlPVkDBcj4xpxzI2Sf8MJ
	 uMDATFxOnW67pVICWunF1K7DM3Tv9rjgCZKklZDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/523] staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()
Date: Tue, 26 Aug 2025 13:04:52 +0200
Message-ID: <20250826110926.585361864@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d0c8d85f3db0..2c04fcff0e1c 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -745,6 +745,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	return info;
 
 release_framebuf:
+	fb_deferred_io_cleanup(info);
 	framebuffer_release(info);
 
 alloc_fail:
-- 
2.39.5



