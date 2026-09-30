Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED66511E90;
	Wed, 30 Sep 2026 16:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784490; cv=none; b=VAcR3JDWf7Bu0FOW8NjH+/KtCqF81delRud78dMfABlo4R3IB3uKk+khykHyduFYB3ifH344IdNKsbWxq39KUulPGxcbZBrxE6p4yWCV9maQFRojKfHYaUzvusI3CNP4QzNbDNiK5weQb2RPOJ0b9KY7MlpCz6AsLFuFS7oc3x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784490; c=relaxed/simple;
	bh=GR8wnLLl9frWMYtRy5opJkYEU66lXiHhSOU/e1WBxeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmKHzr9ULqkV+KAKLWVoULQ1RQvOAYWdcYji1mANilYqabQmL/XQCVXfeWkRKWbNy1dGxS3lsTeB5GkiR50tIUtiT6jJiQgQy+kBKRwUG5BtRG/lb+aIR9KAUBFku4EE00YhbU7CBqKxba6EKkgMKO8s70YcLmsct0ueZ+ASSMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKh0pfcR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKh0pfcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54B41F00898;
	Wed, 30 Sep 2026 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784479;
	bh=1FBWJ1Vnt9WsCk25a5fD9Li95i/xNJpUeGolx5okWRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKh0pfcRe76w5j3NgOK2G3mK8DodiXkSGA8X6dQOsCKqwcmqS+zjptHctXjMkbgD+
	 k4whlROYa4jks3NsboHYaCjcArkxUatwuHK94TrZp8yv517OEHcRKz6iXvSVemdjNR
	 tdbweE/XbNeM5QYYXA3YNe2PsXiVRcyhjPPXWKME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/982] pinctrl: renesas: rzv2m: Use -ENOTSUPP instead of -EOPNOTSUPP
Date: Wed, 30 Sep 2026 17:14:11 +0200
Message-ID: <20260930152419.288320372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index dc4299c03b990..2ac91512f0c61 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -664,7 +664,7 @@ static int rzv2m_pinctrl_pinconf_set(struct pinctrl_dev *pctldev,
 		}
 
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -713,7 +713,7 @@ static int rzv2m_pinctrl_pinconf_group_get(struct pinctrl_dev *pctldev,
 
 		/* Check config matches previous pins */
 		if (i && prev_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		prev_config = *config;
 	}
-- 
2.53.0



