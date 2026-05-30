Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9790D343D72;
	Sat, 30 May 2026 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158158; cv=none; b=OeG5vGcyW/zgdQvGDE0i56C5AJRlCcQ+3/l5lQK9l6rJzKml0fqg4cOQ69mePDFiZFJ2tPK7wSaeov6vPQlleeRaFYJWXBxZdR9SzwdkoC7yqGka6CIf5weIMhiVzkQSFRJ0KxVmzqu/dD+AxQgjldkMjOqeOVjQBSs/LXNoCZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158158; c=relaxed/simple;
	bh=9MZ6Aa41vRmz4fVlPoktWgX0Z27hp9nBfVTXSXCRWMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I+opezhQxbwngjnPJnRddjyJ/N0aL1sqkN1Zg9L70z6TfdH0QvOYnluZoH8jjplOEGM9bul0WvL4lchrGkxennoS7u7a6jHrGs/+nH60J6jwMCKRGkp1O25ObIs38VmDonIoH2TyQlHz5CLVpYa3td6wWI0ZxBGYq66Qtd7qnE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUT9H8qu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUT9H8qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256311F00898;
	Sat, 30 May 2026 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158157;
	bh=EXimtZA5+wTBLXF13+KFJXmETasWuj+P1M8GxeZe+SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUT9H8qup72AzHyzSD2lOYPPwIZt4+klghRAucTAeRLL8z/DU4wPgA7WeCcITxyiO
	 cAcFmh/79WT/cUgrwfCwyQepgWYUf8MJM2AIe33P8NsmenBJn4HDkDl7oMZQp17acp
	 KzuY66Xcya02p+iRCIDp99y5/BfHaH1uIZO3sME4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/969] drm/vc4: Release runtime PM reference after binding V3D
Date: Sat, 30 May 2026 17:52:31 +0200
Message-ID: <20260530160301.193821183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56abb0d6bc39b..a39e6f8eff0a6 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -497,6 +497,7 @@ static int vc4_v3d_bind(struct device *dev, struct device *master, void *data)
 
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_set_autosuspend_delay(dev, 40); /* a little over 2 frames. */
+	pm_runtime_put_autosuspend(dev);
 
 	return 0;
 
-- 
2.53.0



