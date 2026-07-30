Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72477449B0F;
	Thu, 30 Jul 2026 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425098; cv=none; b=rcV839DfcagtD2pLS6KZA3Y8ZJ0+XZGl47G2cft5V1G4OL8yXGEgsabx6DTond2U2FBF/UnlzkWcgfoYTXsmXpPdlOWUJhXCp+4US9/keKxX9d1pODpnRWDAqwoVczFRqxHIVwRZCSzcZLVfZXnL7Wbm9aPh6llg2o0v2E8H3n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425098; c=relaxed/simple;
	bh=iYYgSdzn+zJipE1qd2dAlcn9V6iLcpQlWOqSuht7A+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BedayyKNrccwyWqHvL1tc0UR6YobMSFYCzfsTyAxIu7hsd/VvQrdB5VZSX7nffU0VuG/G5VqzcM8N2CrTw+F4BN0R/v7r5rm8t5mNrymlLqthlfHdUeOhNVqnlrvcZQuWAShJ6o9cqgcIocMUo11OyqLckDm3wmt5Ol2tj5JUYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YdeKBUx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YdeKBUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6291F00A3A;
	Thu, 30 Jul 2026 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425097;
	bh=bUnZLsvJfcQKahncNDVnCdNlecA1I2vIzdZgf+K+GdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YdeKBUxBlE1ACDalrVakrc3uL3h3vrF9tt1ntsSwMYDjuwrr/0Mz/+OxrvJj4kjH
	 iUhv/AxTjoTokNNlVUsI2JTubbjNTLsHzVN0+LK/vzAGjFDv2MIEGianEUnmIoV4d0
	 /J+f+xgBUDl0Hg+xbnpeHcClQSO3snRgGexHaaOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 624/675] pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP
Date: Thu, 30 Jul 2026 16:15:54 +0200
Message-ID: <20260730141458.386689393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit c1492da3939c89372929e062d731f328f7693f1e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -1097,7 +1097,7 @@ static int rzg2l_read_oen(struct rzg2l_p
 	int bit;
 
 	if (!pctrl->data->pin_to_oen_bit)
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 
 	bit = pctrl->data->pin_to_oen_bit(pctrl, _pin);
 	if (bit < 0)
@@ -1115,7 +1115,7 @@ static int rzg2l_write_oen(struct rzg2l_
 	int bit;
 
 	if (!pctrl->data->pin_to_oen_bit)
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 
 	bit = pctrl->data->pin_to_oen_bit(pctrl, _pin);
 	if (bit < 0)
@@ -1552,7 +1552,7 @@ static int rzg2l_pinctrl_pinconf_set(str
 			break;
 
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -1634,7 +1634,7 @@ static int rzg2l_pinctrl_pinconf_group_g
 
 		/* Check config matching between to pin  */
 		if (i && prev_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		prev_config = *config;
 	}


