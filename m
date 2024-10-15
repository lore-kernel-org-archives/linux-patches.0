Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DF81D5ADB;
	Tue, 15 Oct 2024 11:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992586; cv=none; b=k04TBqHPp4BnGmitTuaQPKnUqzY7kfqGI3FxxbQo7Apxf7e5Q/OZh2IchKltO+VFF4RV8nhtRzbS4/hLItRKZvTfa27fceQq8bBkADQXtiT175jQUywAKbILg1bAMhThAVQlT05i+Lln8yvgWg0l7ZQCOr1X9eGxXrZO7AnNrIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992586; c=relaxed/simple;
	bh=JeAzcy+uuR5dJ8xRH9p4BoSEJ0qgqjCkofrRjIq7TZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDhbezLR4HiAY4VPlvKqSHzIFqU+A6FIzbiw2jwDkA6tN2fTxTjnWfYGPIsPKJX2SZFo3poyR6OGAN0AbGv5so2/UQ+iXYj+cKE4JE8qOYno/+uv2QCjLiYHh67vPt49PROpZwjHxI4YKIKs5VLUUNtm/amgIP4rE6Ua+pS8EFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUdJg0Ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUdJg0Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9E9C4CEC6;
	Tue, 15 Oct 2024 11:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992586;
	bh=JeAzcy+uuR5dJ8xRH9p4BoSEJ0qgqjCkofrRjIq7TZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUdJg0Ku9SVSM9MKToBU2CTEVUwsIi0kPvMSSZZW6/dGe6PINebQbg6/lv8EwmZSt
	 351VliV6gNDDvQYyw5yJOMaKl2X8Zq6j9oh/mN3/qXsPZT4B5RK3m3/9LHJUbE4Tol
	 yPIChf/GJ4GcbYx3MBAUHGwq4Fm4H4r481vHTR8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/691] drm/stm: Fix an error handling path in stm_drm_platform_probe()
Date: Tue, 15 Oct 2024 13:21:48 +0200
Message-ID: <20241015112446.711969329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ce7c90bfda2656418c69ba0dd8f8a7536b8928d4 ]

If drm_dev_register() fails, a call to drv_load() must be undone, as
already done in the remove function.

Fixes: b759012c5fa7 ("drm/stm: Add STM32 LTDC driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20fff7f853f20a48a96db8ff186124470ec4d976.1704560028.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/stm/drv.c b/drivers/gpu/drm/stm/drv.c
index 222869b232ae0..d8f4d1150913b 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -195,12 +195,14 @@ static int stm_drm_platform_probe(struct platform_device *pdev)
 
 	ret = drm_dev_register(ddev, 0);
 	if (ret)
-		goto err_put;
+		goto err_unload;
 
 	drm_fbdev_generic_setup(ddev, 16);
 
 	return 0;
 
+err_unload:
+	drv_unload(ddev);
 err_put:
 	drm_dev_put(ddev);
 
-- 
2.43.0



