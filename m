Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032F72AD32;
	Tue, 26 Aug 2025 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218636; cv=none; b=tOx50LFCea3eYUh+lLbjLdXFsrOhYThZCPekbTlWsKNlefpVfPfbxuip1CNT+a7/i7Xwif0UGyGR3cTjiuq1mCLrv0QjJzRwn/6x/Q1u/ffLh3XdlROv3yU3OnOjxKrjsE1abe1JFuHnsRvU5tRUe2Jqyq7U/NNl0E0XLT4u87A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218636; c=relaxed/simple;
	bh=rp0Kr6If0JP6AEX7X4TqkiKi8qrFKmU8csqYygBzBBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isvZpLGoua84RC68QTFaErOP5H58KWvVJakLqyXK8WVEbARbdcwUiXnRrJ0A1S2UvTEpqlOPJOJNVaqK6Frwa/O+hhRI41YZEZrVsJo2JaeynLHc4XgeU9C0RUR7X/5KTAu3cAlgaIDP5e2sxuc5BXPTh9iQ1a0A1CC2RYL3weQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pT7I4N5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pT7I4N5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6AEC4CEF1;
	Tue, 26 Aug 2025 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218635;
	bh=rp0Kr6If0JP6AEX7X4TqkiKi8qrFKmU8csqYygBzBBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pT7I4N5x6UdjLTUuwqNmeQUanFrAvztU0yrmug6I2HhHM2Bb1Wb2NlVvPSfzTVqt0
	 JkOKZMpklWiq4evDsOuBO+yrmvUZTo+RI0PX4oYZUSxRvrRGt+ZGQCLbgY2IWeuT4H
	 2CQXuV8ThazlhnxuazY33J6gfOJVly3anY/wMFD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/403] staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()
Date: Tue, 26 Aug 2025 13:06:41 +0200
Message-ID: <20250826110908.468975690@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 771697508cec..a524cacd89cd 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -752,6 +752,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	return info;
 
 release_framebuf:
+	fb_deferred_io_cleanup(info);
 	framebuffer_release(info);
 
 alloc_fail:
-- 
2.39.5



