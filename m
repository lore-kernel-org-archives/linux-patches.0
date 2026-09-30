Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1131C3D47C0;
	Wed, 30 Sep 2026 18:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794218; cv=none; b=teT0wnwJ5nk3jgjSH5rXFy0tqVu7StKcLCuFTWuQsWdwPLjWsEL30Kyn2xcEZNVupUHDit631K/JlKq9VFYGiT7v1uzSNGq0WJx2xaCLFxeM86gqaoazlUlTDMmkUGtFefA5xeeZICLuFXzJikUk4HJrgSWbPoS9HAFWgQT5Vbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794218; c=relaxed/simple;
	bh=54WbmKv761tT6KMvDKZLztUk7nA3euBo5LzUB6gMbm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBE7Et/y8yJXELl1jG7Mb2XdcG+sFWAiztTFeuNi/g4YB7t16a9Gi8W70okhn6zpPzCq3MkqNMxcLDlnZ9UbRxHKOdxxekmjWrYttjouCH1x7BkMFNupXy4TF8yiG5GoWwFWqPBXsxAMUN2SVYHAvbNfa2ClLkXATouZomAEuYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHi3Lcau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHi3Lcau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696E91F00898;
	Wed, 30 Sep 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794217;
	bh=jvDaUdizGzDLNgTxX3dDpAGx7GsCI1jS6jVQLjg3iUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHi3Lcau57+Lr1kA1X9i2zqBClaoBHKTR86A7g7GeOzZSjbkpzUo9J6UpqlYurPxr
	 WgUtnz4mDTJxT3IBDJfzljaq3wrWGE6UgC2WcUKnnWIUnh/js//71+IiQjPinsj83m
	 7PQShgNHN8LiNNdR9nsNIblEKKU5sE1aC8+UycFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0132/1193] pinctrl: renesas: rzv2m: Use -ENOTSUPP instead of -EOPNOTSUPP
Date: Wed, 30 Sep 2026 17:13:36 +0200
Message-ID: <20260930152437.145218220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

[ Upstream commit 01f94d53947df35ba77cdb3992a4e3ef9d9dc1ad ]

The pinctrl and GPIO core code make exceptions for the -ENOTSUPP error
code. One such example is gpio_set_config_with_argument_optional(), which
returns success when gpio_set_config_with_argument() returns -ENOTSUPP, but
reports failure for all other error codes.

Returning -EOPNOTSUPP from the pinctrl driver on the unsupported pinctrl
operation may lead to boot failures when pinctrl drivers implements
struct gpio_chip::set_config, the system uses GPIO hogs, and the
struct gpio_chip::set_config implementation returns -EOPNOTSUPP for the
unsupported operations.

Currently, the driver does not implement struct gpio_chip::set_config().
To avoid future failures, return -ENOTSUPP from
rzv2m_pinctrl_pinconf_set().

rzv2m_pinctrl_pinconf_group_get() is used when dumping pinctrl
configuration. pinconf_generic_dump_one(), which calls it, makes
exceptions for the -EINVAL and -ENOTSUPP error codes. The documentation
for struct pinconf_ops::pin_config_group_get states that it "should
return -ENOTSUPP and -EINVAL using the same rules as pin_config_get()".
The documentation for struct pinconf_ops::pin_config_get states:

"get the config of a certain pin, if the requested config is not available
on this controller this should return -ENOTSUPP and if it is available but
disabled it should return -EINVAL".

Return -ENOTSUPP for the unsupported pinctrl operation.

Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260522105717.1727837-1-claudiu.beznea@kernel.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzv2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzv2m.c b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
index b89ae65e71b0e..0b1f6ce522d9e 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -665,7 +665,7 @@ static int rzv2m_pinctrl_pinconf_set(struct pinctrl_dev *pctldev,
 		}
 
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -714,7 +714,7 @@ static int rzv2m_pinctrl_pinconf_group_get(struct pinctrl_dev *pctldev,
 
 		/* Check config matches previous pins */
 		if (i && prev_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		prev_config = *config;
 	}
-- 
2.53.0



