Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD1163D5;
	Thu, 15 Aug 2024 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732236; cv=none; b=Dd1+0GlpEgnUvZK4N9KCTLhbVjaMYWQQDfwOoJSjxwCYXejrW/J3kAslxV2TcPiqGycx2/CeblDzzgbb35lKlbXfngpSiusBVnu3XaKebl8GJLxRG370Uh+L1EVMOu9QhNlLmF2ELthjV9l7lQuDNyrH7Pir5mudEHqNVP2U4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732236; c=relaxed/simple;
	bh=gx1mF23XqB4PKu8LwsJOOThiPsX/A+eY+ztgA+uFqpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cih0+3anAvdjHvz4/KekkCA820kvRlqvmOYxpWU2yue0wA9mKR7Ks2JyAwbJrpDd9H9KUAohEOXQ4yxiSDdsyAOEgKNOIPT3F26O4cW5LaMXM6jI/sdzCIsuGcrliqhfd9zPBmaqm7xTGuXU9WKwy1GlJKwQ6eKA8Q3+x4FRVCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdwHWR1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdwHWR1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152FFC32786;
	Thu, 15 Aug 2024 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732236;
	bh=gx1mF23XqB4PKu8LwsJOOThiPsX/A+eY+ztgA+uFqpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdwHWR1n+vu357CIjNnxOC3N2tBEdaU0fnFXBKi/boaVdAf9p5Fp71npzDEXP5Bm8
	 yipUt6OHkkZGnszyS09nTlpune1d06tHVpctitO5M6mWAvKZD5owv66eeUiXqOhqKt
	 cItXlUUNYZ1u9F1Dw3njy6m86hVUJv6uqvTv3kmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/352] drm/qxl: Add check for drm_cvt_mode
Date: Thu, 15 Aug 2024 15:22:31 +0200
Message-ID: <20240815131922.532501749@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 7bd09a2db0f617377027a2bb0b9179e6959edff3 ]

Add check for the return value of drm_cvt_mode() and return the error if
it fails in order to avoid NULL pointer dereference.

Fixes: 1b043677d4be ("drm/qxl: add qxl_add_mode helper function")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621071031.1987974-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index f22a1b776f4ba..3ffa721d777bf 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -232,6 +232,9 @@ static int qxl_add_mode(struct drm_connector *connector,
 		return 0;
 
 	mode = drm_cvt_mode(dev, width, height, 60, false, false, false);
+	if (!mode)
+		return 0;
+
 	if (preferred)
 		mode->type |= DRM_MODE_TYPE_PREFERRED;
 	mode->hdisplay = width;
-- 
2.43.0



