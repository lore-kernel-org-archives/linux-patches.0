Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83633B2FE4;
	Mon, 20 Apr 2026 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691403; cv=none; b=WTT7lHqt6KgxhHqfAopdE7clbUMJvfePVg9Y6mD+eRaCot+2eI989m18WGQuIdZBklu7PBc3jwcAxR8R1acDPWBDnDtHTltOpps1b9H2MxRE6bN7okjCjiqq5O7InwOPBuFar1FBYd69+Tb3WReYvTpH24qOv1yDqizVEAgrPKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691403; c=relaxed/simple;
	bh=kJp0f3Qe7jghhdutSl0szZVzMtl5wM/wNl1r+wM57XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dmY5o59rsZ0l+p63qktNCt9vL/4iK1vRq23Mf6pRwNWUPtCYDOjN7e9qftRLW5sCdyhgk7KBzd+RTc4OzorAy5BnzlMVj/IaqXakIy4O7FUCrAk86O72xLRGfO/f/cljHfVUxAiaAoUlHsDyCQ8YAtX03H4rtJnmdZ2JdrGzQuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YXbfS3GW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YXbfS3GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A62FC2BCB6;
	Mon, 20 Apr 2026 13:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691403;
	bh=kJp0f3Qe7jghhdutSl0szZVzMtl5wM/wNl1r+wM57XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXbfS3GWWxqXsHyVgUt8jc2SQJ1ODwZdiChgJm3tzk2eFBYAYSVl1Dc2Lq0FGqWgh
	 c3/JZFtNZOnJFW2aEr1TjIpn4zCA44KNe9oMEnBExV7oiqWhcag0tAkUJYRgq0WwGY
	 vyQCY+2qozKgmZ0oLMqQYZHX58V70RuVU3BCP+kc2QRlZZmprVYWlmt4FUmP1bKXzh
	 /ubSmhYZSf78xL8lK4kEePWuB45yO6ZPqqomWztZeC9MK77avav/2Ci0/QqCjB6D2E
	 7pLB14lGofzN+2XFTCxhWHniY9FsWhA4rh5/kOrglrFdGltGgga6dYrMu1BRNPoDkE
	 ljxErm/JUdTzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Melissa Wen <mwen@igalia.com>,
	Sasha Levin <sashal@kernel.org>,
	mripard@kernel.org,
	dave.stevenson@raspberrypi.com,
	maarten.lankhorst@linux.intel.com,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/vc4: Release runtime PM reference after binding V3D
Date: Mon, 20 Apr 2026 09:16:39 -0400
Message-ID: <20260420132314.1023554-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/gpu/drm/vc4/vc4_v3d.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index bb09df5000bda..e470412851cc8 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -479,6 +479,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, 40); /* a little over 2 frames. */
+	pm_runtime_put_autosuspend(dev);
 
 	return 0;
 
-- 
2.53.0

