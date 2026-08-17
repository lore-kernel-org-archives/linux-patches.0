Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE57340DB22;
	Mon, 17 Aug 2026 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977709; cv=none; b=O9fywXZ6tZ4waVXRtAz2t9siZVSH5Nqn7ItNTETpNG5ButIR1szF6ruDTb/A0tn6NQSQadQlNWrw6/imI5wXgXe+K9Uuc6RsIiMr/6vgCpDhNVpWnr/1ZXXAhK5hDN2Qlnvmq+EKo/B9b95dJXoGJDEiUKjw6Sn0sstducDVsCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977709; c=relaxed/simple;
	bh=rHcv8dYJ6O6Ikf+KPqtt3KtQNb/B21s5JuSBkVHylwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoJE0Vihz8eJw4jtYVbOQR4UDpvuEUd/cVkHMlCwpn6q4ne7bNotUazLNrS+B3++Gm/svyawBwMJl3IfRpGlmN2j9myLkEMH+hwMinPU0V+UiGjgYm3mrK8yyoOu3NliBB5x7/GroNpaWyaB78uKpjf5ZEH2cZTmhDWszFZl2dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNSX+OmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNSX+OmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4C21F00A3A;
	Mon, 17 Aug 2026 14:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977707;
	bh=G3zkwGsIeoSSsZBrLZzDtFNoKWjyu3PCG/CT0LY/iaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNSX+OmFkM21kQ7gebueq4WuxM2/Ay8IKjqWSKgR5jiEo6xoz2S3a/L95NVQgI8Et
	 8yb7P03pVyYEVvV1A4hbTsOW5yZ/dkdrerCABFxinseqg305vdcU3sl+MbaeQUPUFh
	 JpD0uV6wsHCohZm6Xx+O0sbA6Qk7qfB8VMIVHZ4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 422/456] pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP
Date: Mon, 17 Aug 2026 15:33:32 +0200
Message-ID: <20260817132555.699407602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 v5.15 stable]
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index f839bd3d0927a..eceba66ab0336 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -565,7 +565,7 @@ static int rzg2l_pinctrl_pinconf_set(struct pinctrl_dev *pctldev,
 			break;
 		}
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -614,7 +614,7 @@ static int rzg2l_pinctrl_pinconf_group_get(struct pinctrl_dev *pctldev,
 
 		/* Check config matching between to pin  */
 		if (i && prev_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		prev_config = *config;
 	}
-- 
2.53.0



