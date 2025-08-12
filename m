Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396392FDC36;
	Tue, 12 Aug 2025 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020425; cv=none; b=fIM1K2A7f0nDCF3CAxncmqDH9uMJqQTmHJOe5qO7UFMVwXsvhLo+XHv3QM7dF5VU3CfxpejD4PRKZUrPJYEe+tmKDAcmjZwEWPu5WNGke3pjF1rh/5MkBc/ql5nWXPX7P+6xQ7ATWp1Ht1V6zpuEae1Vr8wW+DRIlcBypLjGmD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020425; c=relaxed/simple;
	bh=C9pm4k79csd4kuvjIO6MIZyiJyfNjyPY0y+CyIktdso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMqnIGOIXcjdzmVP2ASbYbnCqzfOmAMbb/ZReTudfYA2ef0f0/Ec8rZd+MQ845VX9xwJsCfgjKwXKvg5NsUastKHSMdxAC8UNMeFRIFzbiyF91t2jomgoXpOAAFSFIbq/wBi5MZ2BEShNqu8TK8M19DJbU3bLa5WMHWB+iYsFoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6gyZZ3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6gyZZ3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF08C4CEF0;
	Tue, 12 Aug 2025 17:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020425;
	bh=C9pm4k79csd4kuvjIO6MIZyiJyfNjyPY0y+CyIktdso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6gyZZ3uMYQ2QIFaVPZo2bQaej3uXfVkDGcAXxt+7+kvbS4rnYZA8P2O1Lm6pVGT2
	 Gzp4nwniDe960G3YA75Fm2WfDml3dDWOxkoBE3MvUvYZOBlNelufXbxIBoHS693F/F
	 L9UBM81noY2YONaQAXMvVeBG7XJtINlCnFOYg1aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/253] staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()
Date: Tue, 12 Aug 2025 19:27:45 +0200
Message-ID: <20250812172952.007054821@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index afaba94d1d1c..7b802b022627 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -744,6 +744,7 @@ struct fb_info *fbtft_framebuffer_alloc(struct fbtft_display *display,
 	return info;
 
 release_framebuf:
+	fb_deferred_io_cleanup(info);
 	framebuffer_release(info);
 
 alloc_fail:
-- 
2.39.5



