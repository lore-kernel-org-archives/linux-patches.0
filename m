Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB02C26AC5;
	Tue, 14 May 2024 10:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684259; cv=none; b=aKp8i4g6Gf6NGNqxANIDqOzlcpVNo/T7Vu7T945V/qlC9hgWQcOYYr/U24vqoH70Byd806VPy6eczv1kkWmFdKqZdDGbVfjDAxDAkFXWG1beAbKDuu0w6YaXzBwLNC74wCrXmbQeXIQFGhISgtpWlqIvwB/EwamOmA8ANfiUyTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684259; c=relaxed/simple;
	bh=YYW+If0QfUqpKD3tNnF6gW9ok0HtNGyWD6JRw8vw8Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMfnQhdB7Fy6cqY3Iq1qc8o7bX9vAiQG5y7f+AiDpzKJNIgm5YYYXKrbr2Q1ysXO5JlMB9RnxGtiul26oRDyAc5AHBiUH1WOEBU7OitZ3yIGbvV+6KyRwojso47UACSWNV0V+UhjJVDXCbZOsApYHDfw8CHQBZpX969rPOOYVbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KgZkgghO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KgZkgghO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E68C2BD10;
	Tue, 14 May 2024 10:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684259;
	bh=YYW+If0QfUqpKD3tNnF6gW9ok0HtNGyWD6JRw8vw8Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KgZkgghOS5CmzrUvVoVSgwtT3Nk5o6i5LK8fNpGC4EcV5toREMYUDnHA4wuN9yz75
	 Nr6H/gK5Y5dZu0BZUsfPgG7HyYd8RDLlXXtZCvoSygIeusQ+SWNtF+WMtFbSyBhmhI
	 FKmk3bThcN8/JG/kHApVFlDIg2zgfHeSiLG1UznY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/301] pinctrl: mediatek: paris: Fix PIN_CONFIG_INPUT_SCHMITT_ENABLE readback
Date: Tue, 14 May 2024 12:14:46 +0200
Message-ID: <20240514101032.818799708@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 08f66a8edd08f6f7cfa769c81634b29a2b123908 ]

In the generic pin config library, readback of some options are handled
differently compared to the setting of those options: the argument value
is used to convey enable/disable of an option in the set path, but
success or -EINVAL is used to convey if an option is enabled or disabled
in the debugfs readback path.

PIN_CONFIG_INPUT_SCHMITT_ENABLE is one such option. Fix the readback of
the option in the mediatek-paris library, so that the debugfs dump is
not showing "input schmitt enabled" for pins that don't have it enabled.

Fixes: 1bea6afbc842 ("pinctrl: mediatek: Refine mtk_pinconf_get()")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Message-ID: <20240327091336.3434141-2-wenst@chromium.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 33d6c3fb79080..ea60de040e0a0 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -193,6 +193,8 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 		}
 
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_SMT, &ret);
+		if (!ret)
+			err = -EINVAL;
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
 		if (!hw->soc->drive_get)
-- 
2.43.0



