Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3BE3271F2;
	Tue, 16 Dec 2025 12:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887279; cv=none; b=NCWtaueJFxeQJsHOYFm1DpPNS2pgpNJ4feUKtxGTYim0q3lsA8PFcSirS8RFKPbZ+9JFihtsvzwXaL775kn7Kh7gdfn1kzgYF8HH32Zl8UERe1gOWJeMs70Lcs7ly8CQyPPBi4mz2Y/T4AniOg2PMU/Usv7KlAubcAh/2JdzVWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887279; c=relaxed/simple;
	bh=n+l/fY09RAauq6eaN/WHkmCLiJfjsgh3UZSES7ghFww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5W/d20QTESLeOCpTkvd9/+8k2wnu42ixGAW9UjKFZy6Gw7fUjsu6xU3uAx7bXi/Kkyu30JaJB2S8v7W/Eyxgh7SOBbYux84E94QBgX0SwxSgVfN3OBNuqhFOkN3RBn30Sx/KOpZN1jo2nU+IPW2b1Nq2LC7lYmerG8MjxlzjLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNdcwa4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNdcwa4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7747EC4CEF5;
	Tue, 16 Dec 2025 12:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887278;
	bh=n+l/fY09RAauq6eaN/WHkmCLiJfjsgh3UZSES7ghFww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNdcwa4zIrzooBbax3LA2BkcZVRUMegA0DgQ7xbMSvqBTrSy897o8BaCVJEX47beo
	 hHi+5H6lyx2j76R/hOUshNLBbsUanWF3M608lnE3ZDh0hU98Ah4Clj6VLhLhpxrkaE
	 a8jfmfimzYbaBOdHAulVsrTZ5XJuFAU9CULNUX/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 182/614] power: supply: rt9467: Prevent using uninitialized local variable in rt9467_set_value_from_ranges()
Date: Tue, 16 Dec 2025 12:09:09 +0100
Message-ID: <20251216111407.967470854@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 15aca30cc6c69806054b896a2ccf7577239cb878 ]

There is a typo in rt9467_set_value_from_ranges() that can cause leaving local
variable sel with an undefined value which is then used in regmap_field_write().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6f7f70e3a8dd ("power: supply: rt9467: Add Richtek RT9467 charger driver")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20251009145308.1830893-1-m.masimov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9467-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index b4917514bd701..44c26fb37a775 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -376,7 +376,7 @@ static int rt9467_set_value_from_ranges(struct rt9467_chg_data *data,
 	if (rsel == RT9467_RANGE_VMIVR) {
 		ret = linear_range_get_selector_high(range, value, &sel, &found);
 		if (ret)
-			value = range->max_sel;
+			sel = range->max_sel;
 	} else {
 		linear_range_get_selector_within(range, value, &sel);
 	}
-- 
2.51.0



