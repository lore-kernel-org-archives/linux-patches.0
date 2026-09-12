Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17CD25B083;
	Sat, 12 Sep 2026 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201354; cv=none; b=atlU9+ij+jPZDGv+qzeJGqyCaAESozW9vWsg93YVsumlvChQRY6ME9aGY/vLKxXVv2jt1vxLOu5Apw9ICB1/c/7yFkhcgWmoOpBcoFm5i//cj+Ac0MD6Vszu4eche/SKH3uv83aRgBbriZ24NaSz10+FhGsk2JquFy1qx9kE9o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201354; c=relaxed/simple;
	bh=NtJocqtpn4loB/d1l05RyZw+34mKuyB6Yu++4qzt+OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCnPmjRyDST4fo7m1uyTww/nLOKmz33wCeurxUcXD1jLnp/3r21ZymDMgJQ0g6DLVn0DUjndnFZ5jk9RVjjmIHGOyJBYepQu6Zyry2J8CoR6UV8nWbM6EBer9jdmtnUuErM2qNXdCusEsbM6WzJ/rjr/eD+AaIN4GjmzhxvEV8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMDGiVDW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMDGiVDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774CF1F000FF;
	Sat, 12 Sep 2026 08:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201353;
	bh=JbLjqPKYsCKskE5k55gEBvxB8ynHZej6d+GAZmFiVDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMDGiVDWmlTnLrSCO8c/oFXWIJK5uybxUm4mqHPz+mzEYHJLUeNSeStGVjpsCqV4f
	 HiC9sINM+PSGdlaAg+EP10fN/A/VpwG+AOGoOqBFaWlOLqxFLoqzRq0mK5xqtaoir1
	 cgHsTCXuncdK0zeyjWCcpr9tmHGxe6NjZD2BW+rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yulin Lu <luyulin@eswincomputing.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0979/1815] pinctrl: eswin: Fix Handling of PIN_CONFIG_PERSIST_STATE
Date: Sat, 12 Sep 2026 08:45:29 +0200
Message-ID: <20260912065711.975204619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yulin Lu <luyulin@eswincomputing.com>

[ Upstream commit f9af1329b98a478f4bba605ec6db429ef0e38d54 ]

The EIC7700 pinctrl driver does not handle PIN_CONFIG_PERSIST_STATE
specifically, and returns -EOPNOTSUPP from the default case.

Since all pins on the EIC7700 SoC are persistent over suspend, the
correct behaviour is to accept this parameter and return success.

Add an explicit case for PIN_CONFIG_PERSIST_STATE that returns 0 to
prevent errors when this parameter is set.

Signed-off-by: Yulin Lu <luyulin@eswincomputing.com>
Fixes: 5b797bcc00ef ("pinctrl: eswin: Add EIC7700 pinctrl driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-eic7700.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-eic7700.c b/drivers/pinctrl/pinctrl-eic7700.c
index d553ec20c6191..09a3b097383cb 100644
--- a/drivers/pinctrl/pinctrl-eic7700.c
+++ b/drivers/pinctrl/pinctrl-eic7700.c
@@ -422,6 +422,9 @@ static int eic7700_pin_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			else
 				value &= ~EIC7700_ST;
 			break;
+		/* All pins are persistent over suspend */
+		case PIN_CONFIG_PERSIST_STATE:
+			return 0;
 		default:
 			return -EOPNOTSUPP;
 		}
-- 
2.53.0



