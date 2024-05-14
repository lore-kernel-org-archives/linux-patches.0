Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B792B9B3;
	Tue, 14 May 2024 11:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687158; cv=none; b=hGMOqd2ZbUTvvTctn77yn/uwrbI0w9wYBihfcXFSQxWprVPSxDf3Hdc0VcvtdyhpxPIN4ZcdDBimaZacFQKKqhGVFX5dfLbIe1cw+k+LrHcHQL05or5OA7IL+Z+r4gyCCgLXQdmD+laxdJ58M6efytW1dMdSNeWzFZLOIlaBYMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687158; c=relaxed/simple;
	bh=P0Ozd7aubesMZZCoF1W7sp3YWwPWCErlp6qtzxB71sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZUqquFu+bcXwE/VmrEDBY1Cwtm2dysy8Cd5eFavfUn4JrvDdmwVSlaO9t4Lh14feUZKDrXWexuit7v8YkojG5B3sDiigAUL4iZ2LAYZUeH3/Ty3zGCsBRWPW+sBKvI9iVlykrmRCbw/X1z5D3euzPQS5fk5sejm0EHHFSjpo/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImdA4U3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImdA4U3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48A1C2BD10;
	Tue, 14 May 2024 11:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687158;
	bh=P0Ozd7aubesMZZCoF1W7sp3YWwPWCErlp6qtzxB71sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImdA4U3x8loL8ihwvvXG/pjyn8knBtWyOY/bxyr6VGPLPXe/IuPprHFCfVUK+uccN
	 2j4jNI9Jp+poFXS/XvaBH9+tgMhF9QfcJcniAMIXcbfpOag3KN1kkyAq/ul9mIOIhi
	 Rksv7OEEhB9yemxkAtucBA7SvhXJTWkblytIYOas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.4 84/84] pinctrl: mediatek: paris: Fix PIN_CONFIG_INPUT_SCHMITT_ENABLE readback
Date: Tue, 14 May 2024 12:20:35 +0200
Message-ID: <20240514100954.841860394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit 08f66a8edd08f6f7cfa769c81634b29a2b123908 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -141,6 +141,8 @@ static int mtk_pinconf_get(struct pinctr
 		}
 
 		err = mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_SMT, &ret);
+		if (!ret)
+			err = -EINVAL;
 		break;
 	case PIN_CONFIG_DRIVE_STRENGTH:
 		if (!hw->soc->drive_get)


