Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8CB63D;
	Tue,  2 Jul 2024 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941573; cv=none; b=duOr2ONSbUYdAhafIL2B1//I9P2UOB7TEztYEEWu4u4ccmghbbbqZG5o/SjmLyw/Q8LQ09ZYs2CgbdUKVY6EF9joIs3YKPen9MSKlHsAmn6IDNvokTLeNDVD4Nzdmd5yr1pd9b/rAbd/oLEHuEc3DfQN8MMVnU9+O2KnHw+9Ev4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941573; c=relaxed/simple;
	bh=vD1AP3Q01HJb/MfmRQNx7dg5e155gEyZij2zq6jzbX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAnLNOjp8qdg/SEJFpgNW8UkzqMqH09TZYStMWZCPEq+fxqy+PAtAe2RhQZefoIb0TwqZLeIPi+LgLBiGtudreSazWHal9bHX6mqQlQN0NH4pNC2HlIWBm/072JFGKGwuZ1M240+b2d2ftmtlfqTJn5a9QKVc40JhYt42K3vy5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bu72h5RB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bu72h5RB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A998FC116B1;
	Tue,  2 Jul 2024 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941573;
	bh=vD1AP3Q01HJb/MfmRQNx7dg5e155gEyZij2zq6jzbX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bu72h5RBgHfcDPyMgwGSq1j2DnjyMVLCTdB6GFDDZQISW5K8Jy07E1oEMlQ0+azkl
	 fmHOtyMf1bzPO+ET3IQG8CUVPY2So9i9q9lytg37ftgOnCn5DTJiCWURMZmXPwlwsC
	 5RNIb3eGY/V14zUmWReHaOSpRVYcTIWBNfNh5KmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.1 105/128] drm/nouveau/dispnv04: fix null pointer dereference in nv17_tv_get_ld_modes
Date: Tue,  2 Jul 2024 19:05:06 +0200
Message-ID: <20240702170230.193122098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 66edf3fb331b6c55439b10f9862987b0916b3726 upstream.

In nv17_tv_get_ld_modes(), the return value of drm_mode_duplicate() is
assigned to mode, which will lead to a possible NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240625081828.2620794-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv04/tvnv17.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/tvnv17.c
@@ -208,6 +208,8 @@ static int nv17_tv_get_ld_modes(struct d
 		struct drm_display_mode *mode;
 
 		mode = drm_mode_duplicate(encoder->dev, tv_mode);
+		if (!mode)
+			continue;
 
 		mode->clock = tv_norm->tv_enc_mode.vrefresh *
 			mode->htotal / 1000 *


