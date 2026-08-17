Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D12175A99;
	Mon, 17 Aug 2026 14:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978617; cv=none; b=l67sbjTJfYtyoeKjgP11I44eUyRJzoM2cRzMW4tp2QH2bNG4HdsP3tnZEAO7pmn0drk1w+BFB9BgPtHICbnbcghdTvyP28gRHDiUoOkQDABarhRK4L0AkN5L1YiDQWU2oTxEdYaC5luMHdF9YhRatBd5ecld5bEDJH/jQN2LHjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978617; c=relaxed/simple;
	bh=BJftT3y1+J7rG9aZXa2LeKuLj9cuE6o4HbDgmxdQw6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3GD3n6un9eQQoE5h6UxdzGCLWDa1Y+QnJEcdQIrpMofdXdcCtBMOTJr2aQIreGhqfnEy3Uq7mit6zXQLen+4eg4J1AdJ55BCmCBLDOT2aEEXIJr5pwBYnOboHE7EQjNptK2hokKwsIR6irDIT2ICj3aCK5MHdVA7lUcDJexcIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKn0/W5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKn0/W5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980651F000E9;
	Mon, 17 Aug 2026 14:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978616;
	bh=Q3vuXkLZTf/mVbP71RE6j2i2D91OiRvWfUtu2S6ilvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKn0/W5gljJX0nvcZokMcwbUHwP0zi89qwsuR6Vb5ehq9HBPgiE9+G1ioSOk+Y2pD
	 N4ee42eQZX8rBcuTv952ugHvyyF6Nk19nzPvZsj9k92H72FI8+CpSzAPyvvKS7tFMB
	 H/zbWepRBsxqzjSHr2Ls68CIYdJ3FnNukPzkqJe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/156] pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP
Date: Mon, 17 Aug 2026 15:33:52 +0200
Message-ID: <20260817132538.456137177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit c1492da3939c89372929e062d731f328f7693f1e upstream.

The pinctrl and GPIO core code make exceptions for the -ENOTSUPP error
code.  One such example is gpio_set_config_with_argument_optional(),
which returns success when gpio_set_config_with_argument() returns
-ENOTSUPP, but reports failure for all other error codes.

Returning -EOPNOTSUPP from the pinctrl driver on the unsupported pinctrl
operation may lead to boot failures when pinctrl drivers implements
struct gpio_chip::set_config, the system uses GPIO hogs, and the
struct gpio_chip::set_config implementation returns -EOPNOTSUPP for the
unsupported operations.

Return -ENOTSUPP for the unsupported pinctrl operation.

Fixes: 560c633d378a ("pinctrl: renesas: rzg2l: Drop oen_read and oen_write callbacks")
Fixes: c4c4637eb57f ("pinctrl: renesas: Add RZ/G2L pin and gpio controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260515124008.2947838-2-claudiu.beznea@kernel.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
[claudiu.beznea: fixed conflict by dropping the code not present in
 v6.6 stable]
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index ac629c72d5927..b713cc8e0fde8 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -710,7 +710,7 @@ static int rzg2l_pinctrl_pinconf_set(struct pinctrl_dev *pctldev,
 		}
 
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -759,7 +759,7 @@ static int rzg2l_pinctrl_pinconf_group_get(struct pinctrl_dev *pctldev,
 
 		/* Check config matching between to pin  */
 		if (i && prev_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		prev_config = *config;
 	}
-- 
2.53.0



