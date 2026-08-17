Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46213D9545;
	Mon, 17 Aug 2026 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980411; cv=none; b=br+OAIDWEJJreD/mCbPXuVC18pIxgDMg6Q67LRNJFxlD1NWiQBL0086gvUdw+fLOTeetn6+sW587FWzY55xn3A1x08QuLBeZWhXIIFkfE3fOscpewqLYZW9m55BxhUq58+YHb2urerNauMfprREhDDg2Xv816S0W+ZQjyBAy8FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980411; c=relaxed/simple;
	bh=8iyv+1/HiNMsC7WedV7x1uFhM5iYmkaHqE02MDsbFd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tch/8JoBn6vtDbM6cM7yKABVNDSrNPWn9y3jLDPvshESxVewy+S9xSRGmfwwU2+90lUUjPuGmkWd2ugQLXNTKjF65mEu90yzF8eTIaWXSYFsxdpA+W9Seob6Y36UuE4DNlgXQJu1XyhAdXJSa+5wC4lL5Ts2fqYw//o0dZ32AQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9FeQ0AM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9FeQ0AM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C447B1F000E9;
	Mon, 17 Aug 2026 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980409;
	bh=x/J88PW4LE/GaK+8elgO9RqMn21LFv40kSuP0Xd1RkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9FeQ0AMYBgXLNPp+5GBJzWXPtU1WUTXlSJl/nHnfLYD5ngGcCnjsZ6E5Nb9EyxKz
	 jPhwa+vzz3NHbQoo393mV71j7Q6fUFKpcFqG1ApaQ8Odo0xc06CRsVeqUhEiuSC7pb
	 gxKuWJQh9fDLkgXmEmLGuQ4FBkKlLnmP6gLRPA4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 562/609] pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP
Date: Mon, 17 Aug 2026 15:34:18 +0200
Message-ID: <20260817132602.526052670@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 v6.1 stable]
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 1304ab0bcac1e..85bcc9bbe6770 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -708,7 +708,7 @@ static int rzg2l_pinctrl_pinconf_set(struct pinctrl_dev *pctldev,
 		}
 
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -757,7 +757,7 @@ static int rzg2l_pinctrl_pinconf_group_get(struct pinctrl_dev *pctldev,
 
 		/* Check config matching between to pin  */
 		if (i && prev_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		prev_config = *config;
 	}
-- 
2.53.0



