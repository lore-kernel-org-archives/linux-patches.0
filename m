Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDF1329C6D;
	Mon, 20 Apr 2026 16:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701264; cv=none; b=LpEG3Kvf+4eVbhK1CiWyHZVq4JadFTtDzJthaiZ0qLQmYc7CmTdYf/Tke0g4Ys1hbQOLIFEpXmp0PezTIPkuQ7C/lNF9eU6pNL+ars9jZ+/T9VyKltbQUlWaa5zx+feidPiJO9LoDa0GRND0Qmau6Y4PKE8z5p4faiS3EA9tzs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701264; c=relaxed/simple;
	bh=9QsVKQrbqow6pYIbCJh+IvKhXeufHjQg8JVwpWRHpgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgLb3zZkPwNY+r4wpExfIF78UR4rnAIWKCY6OLOJAGQfJWD46T8IY57cD0v3D7qoJEmvgtJe6C2SiO0gQQzfMX2zJUX0Tp93bYfJJTsMdGG8YeZZQdc+wpXZe+S8uPo0nk/m0mQrd7bW0HTBD9p5EbYPvHp9MSdrdFE6+F+wX1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/zSjDVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/zSjDVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401EBC2BCB4;
	Mon, 20 Apr 2026 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701263;
	bh=9QsVKQrbqow6pYIbCJh+IvKhXeufHjQg8JVwpWRHpgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/zSjDVMoNxQNjYMDweoZkycAp9Fd0HD8QNvykuLZ7Qwj13UhxvTCyYLTfq+zhhMg
	 Tn6cQoHBW3DgOv75AbCaTekMSj6RuU3OazWp+XDay0lXrUyJHKb+IztNEzdeXrFuyd
	 9rP0tH/U/TFP4rhR4x2N43Hsk5FUc6Henx5xqLr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/162] drm/vc4: Release runtime PM reference after binding V3D
Date: Mon, 20 Apr 2026 17:41:16 +0200
Message-ID: <20260420153928.623348811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit aaefbdde9abdc43699e110679c0e10972a5e1c59 ]

The vc4_v3d_bind() function acquires a runtime PM reference via
pm_runtime_resume_and_get() to access V3D registers during setup.
However, this reference is never released after a successful bind.
This prevents the device from ever runtime suspending, since the
reference count never reaches zero.

Release the runtime PM reference by adding pm_runtime_put_autosuspend()
after autosuspend is configured, allowing the device to runtime suspend
after the delay.

Fixes: 266cff37d7fc ("drm/vc4: v3d: Rework the runtime_pm setup")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-1-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_v3d.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index 43f69d74e8761..334d2cfe3433b 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -479,6 +479,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, 40); /* a little over 2 frames. */
+	pm_runtime_put_autosuspend(dev);
 
 	return 0;
 
-- 
2.53.0



