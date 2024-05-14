Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C25320F;
	Tue, 14 May 2024 11:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687615; cv=none; b=YPgyX2v0gxuOQyNimEDeqww8m6s6zHTWHtUUvFQvn0hDBg/UIYC4UwG2EXdHZiRpAhmcrCjSnz06El3xPUULXHIZuvcuDtFX76ugYhko0e0vhfIIfOmYlcXTL879XwKvr7G90QEvG930htRs9i9nszFni+uOr6HuXLZsVIRcI9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687615; c=relaxed/simple;
	bh=J0iE/G8vX00721bkXshss3p+HuuZL8CuTTd/ipctpz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWJaAdg2UuX3RXBnb9uziRE9/u4rR46A3pkbSPj7rg5bmqiiPh3HLc4g1bQuJw+Z10bNosu/iR6ELQA0vKzH1ixsjG9Dxt743aRqRczduWUzjTe5aJlNP4uSpMundtPWDMXw53yah4zzYNZnVM4Z6awzH74Sk2NXJ/9OzrA1em4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWwXpxc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWwXpxc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589A4C2BD10;
	Tue, 14 May 2024 11:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687615;
	bh=J0iE/G8vX00721bkXshss3p+HuuZL8CuTTd/ipctpz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWwXpxc6umichRzAMI8lf3ZHecSBTcRRLdBdOjT6Qn87vd4HUkNGfEgUINwugV8M+
	 9SeLaHAaOfJIXkkRzuu+7bW5S991r7kRkhdX/BIFooMoWksQiyaRxs0k4UWGhZzx5j
	 gRbbbjfgvGXqU5JgUs4DDgQJRR56diTfK0x0oV3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/168] pinctrl: mediatek: paris: Fix PIN_CONFIG_INPUT_SCHMITT_ENABLE readback
Date: Tue, 14 May 2024 12:18:32 +0200
Message-ID: <20240514101007.225382495@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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
index f17325a738eaa..9c2eaf8ce84a4 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -141,6 +141,8 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 		}
 
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_SMT, &ret);
+		if (!ret)
+			err = -EINVAL;
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
 		if (!hw->soc->drive_get)
-- 
2.43.0



