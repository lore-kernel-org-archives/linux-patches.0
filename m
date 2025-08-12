Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB80E23182D;
	Tue, 12 Aug 2025 19:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025510; cv=none; b=CvIH/iSM+1lC6B9LZ1rzsiai6NNYGaYvgLBUF58X19/NdzrJ9u5bPrD+BxnCzVI80LrXuWUKsL8j+NFTBmeIKCIEdKY+mo9JK+bFD4P2AhK6AW0Ix11W22NNTZfC4sRd1hksJFsPLj0WnEgtwT8YRjpViglJ8UvkCBstzs3Qo6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025510; c=relaxed/simple;
	bh=+ON4tCS5yk+3YOy59AhGUGuxJP5eE6ig3oNG+wBP+AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQrwwFykjjG7MoJU0ewMn3JX6kWqY++GFPn6PPa17zw0seiqdrQLmby3uvyC5rRDub3KZt8WpmXdiTn+qjg9kHhO0oVhNqf/M9ONW9RjjDtSpRYm8ruBR0PcjNKkE0DBtzq5FCK7AgKeQmnDvFqAuRbYaA5KKvyV3loJxvPLEVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoTedoQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoTedoQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1789DC4CEF0;
	Tue, 12 Aug 2025 19:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025510;
	bh=+ON4tCS5yk+3YOy59AhGUGuxJP5eE6ig3oNG+wBP+AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoTedoQy/6GqgxkwK46WmUMrRWAjYkB6ZPOvYjxFgdfRwYBgE2LPONyaci+N1GVzM
	 hA7CFFJG+3+eHlOrrN68kxKqjrF1AkiI0TEANuDNeAu6LL32+MTd2uoWAMgnA9wQk5
	 VSc//osWQtsH24klRCnGpeOB6e/t1ZZTyyvbaq7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 062/480] staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()
Date: Tue, 12 Aug 2025 19:44:30 +0200
Message-ID: <20250812174359.977435391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index da9c64152a60..39bced400065 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -692,6 +692,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	return info;
 
 release_framebuf:
+	fb_deferred_io_cleanup(info);
 	framebuffer_release(info);
 
 alloc_fail:
-- 
2.39.5



