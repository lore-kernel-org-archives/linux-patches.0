Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B37F3563D4;
	Fri, 24 Apr 2026 13:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037683; cv=none; b=fUzV66w5v39cogIsMUqiNhjPbpv8/YD6NxxboFZJMkHO5otQ9Ja3rbVlocT2W+iaTNkNssW9/xo9nsBEWUNpgaoMhSieq+CW50O7IARiuCZojnxwxU+6dUDXZ3NlHm1DeaRNj6XIFhvJLfH+3aDVb7opEDZvrXjLWMx7hF/AUUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037683; c=relaxed/simple;
	bh=nWNIQNqPieWRmKfOvNVNNGwDe6RwvlDJMobQp7VtEpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COqYjhOD/ge2xAuyTiTtOUfOohaVFoyWH7ROWeAz7jmFpFhxaQJBVCe52Le+S8OdX9x5d2afMeOPzREYuCnvQLe8Hf9bRlycqaJP1KHA8QzbvgppuIvMgM2Vk+dPQuC6xAWxeaAAXcovcRRCHb3noXY2pL95aTuUGkJxKl4CHzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g319zjjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g319zjjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53D8C19425;
	Fri, 24 Apr 2026 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037683;
	bh=nWNIQNqPieWRmKfOvNVNNGwDe6RwvlDJMobQp7VtEpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g319zjjrUFS6rp0EApkF/4hKKO2FMItNUEcv5fZFOq5wRTPsxnqo1VlLrOnc50Q96
	 eDEL0JyF6Um+Ev4r4k9/QMkv4Dw+QDrctBT5rH+/BRJDYdxBt5dnTBbLHoSlt4EMO2
	 otFY86AOtxaWlw8g1pddSQ9sNiljjh2XfGDr20zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/166] drm/vc4: Release runtime PM reference after binding V3D
Date: Fri, 24 Apr 2026 15:29:04 +0200
Message-ID: <20260424132539.164757442@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 04ac7805e6d5f..b1de828e2f90e 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -491,6 +491,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, 40); /* a little over 2 frames. */
+	pm_runtime_put_autosuspend(dev);
 
 	return 0;
 
-- 
2.53.0



