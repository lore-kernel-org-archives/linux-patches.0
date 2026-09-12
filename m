Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C620C36654F;
	Sat, 12 Sep 2026 07:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199888; cv=none; b=oKzpklzV1hNDWHhF9gn0D3cbUoYv+tF11nDTHwRVKBnbXUJe3EIpCXgLzqblZMdY1/1Q9kcyTJdtpc2nCavmJXxJZKJuKvWSfff/c1Vjx98GolgxUMdlvDxQdyd9lQRoBqAeWGfriWOM/GLyWjS/qdxedeq3ucac/UaArfuGk6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199888; c=relaxed/simple;
	bh=RFkbCGzJLn7CUf4+lwShu+VvlED5y5A8crDJ6hFnXyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFM/UMmlyfcP7AuvvY0HqQ6hi7z69F2P45v+duFMDmE/xXjk5nxG2Y1QtsJIrLA7lhxhAzyeGJ2wi83c2fBCB+dj7HIx6UfUUwA2V59hAIvl3XwIuv1UfjvUbuje1agJpcjwzRQT/MNxiRlnvw8HSZt0zzaG89DBbg2hg/WJnIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbWV+Ppo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbWV+Ppo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34181F000FF;
	Sat, 12 Sep 2026 07:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199887;
	bh=+J9OO0518Qa/dm0rfjqQS06s2RUKcr1vgyBcFNf6jE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KbWV+Ppo32zcWn+dYfNh8YRqa5f/eySNjgBbilR/+5DNcmpFIuGFdy9aCJFIrPpbD
	 Q9GkynssftCNquH8emkCVX39qBoxAmQ6jU3i3+Gqvw8MPMyq3/3uGqtspjR78lsIpp
	 6LIvEUqv8WQUrcsaDKt47qrAyVYk5IwT5B1dBO40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0640/1815] drm/panthor: return PTR_ERR() from devm_drm_dev_alloc()
Date: Sat, 12 Sep 2026 08:39:50 +0200
Message-ID: <20260912065703.905262247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit abc1e559f8e5996eee506dfdc8e3781c2a1e04f9 ]

devm_drm_dev_alloc() returns an ERR_PTR() on failure, but panthor_probe()
always converts that failure to -ENOMEM. Preserve the actual error code
returned by the DRM core instead.

Fixes: 4bdca1150792 ("drm/panthor: Add the driver frontend block")
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260716140337.10679-1-osama.abdelkader@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index e8dc4096c1d25..74ec417115a3d 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -1814,7 +1814,7 @@ static int panthor_probe(struct platform_device *pdev)
 	ptdev = devm_drm_dev_alloc(&pdev->dev, &panthor_drm_driver,
 				   struct panthor_device, base);
 	if (IS_ERR(ptdev))
-		return -ENOMEM;
+		return PTR_ERR(ptdev);
 
 	platform_set_drvdata(pdev, ptdev);
 
-- 
2.53.0



