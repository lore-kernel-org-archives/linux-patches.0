Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF0E1D2B36;
	Wed,  2 Oct 2024 14:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877742; cv=none; b=t7vAdSSKOEPYN7UZ2zh2MUKIHpJBjVudpik+14hcZuGLtICtO7EXeV184lTTRLzrwG8ycSirV+JnbxxYyTTf81BTQb+ewbac8YXNp4Uw1izu4sHqOCFlsmjbPzAGvJIdgh2rYFw9DyZIS8o6L2N69tUcTnp/xPqGP+OIeR1EaSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877742; c=relaxed/simple;
	bh=BEzq0/Jz3t+Y8ulH8MMtO09noQZCs2vBsY7jPlyo1B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyqOX9cA2iy3NiIE0WQIdHdCTtUmLesZLG1e6wxeJUKNvSMj5QlhleyiINxQcxzzU/+6gy86IkZk1f9IXG0URJKShvgYAEL/u3bf8D9IYIDjYoLO6+4lkef2yuxpg5LSx0msiEyPHDjxfCfCVxe29dIDDBU5MFZ/uag6BwWI8dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIfLkOvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIfLkOvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7CEC4CEC2;
	Wed,  2 Oct 2024 14:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877741;
	bh=BEzq0/Jz3t+Y8ulH8MMtO09noQZCs2vBsY7jPlyo1B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIfLkOvhv3qN/UV3PVNLpwAC7nPovh2VhKQwqrqted14cn9XeN2zE2TlPwUYLOVvd
	 hx7ZRuim8cXQ/OT+Yeq7P6boqmPL7aj2LAydAP3Gu9n579EsGY7+GNYdjUuSb1MG1R
	 E5hKUqxVz09TMtKbD+3O++T3MjwL3krDRMgO3Ji8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 179/634] drm/stm: Fix an error handling path in stm_drm_platform_probe()
Date: Wed,  2 Oct 2024 14:54:39 +0200
Message-ID: <20241002125818.174455023@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e8523abef27a5..4d2db079ad4ff 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -203,12 +203,14 @@ static int stm_drm_platform_probe(struct platform_device *pdev)
 
 	ret = drm_dev_register(ddev, 0);
 	if (ret)
-		goto err_put;
+		goto err_unload;
 
 	drm_fbdev_dma_setup(ddev, 16);
 
 	return 0;
 
+err_unload:
+	drv_unload(ddev);
 err_put:
 	drm_dev_put(ddev);
 
-- 
2.43.0



