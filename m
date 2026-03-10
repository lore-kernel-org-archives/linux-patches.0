Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD842352C4F;
	Tue, 10 Mar 2026 11:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141188; cv=none; b=aSwZ7znMXbSUO+HGc5CQd753a/PG7kNxPyKAs3sRkIus66ySWdUKgsB2HAiKfGUJMwMSo6OmE6ae7v70PN4+20Fv0yKAa+z8VDWWl7xlonv9EV1g9ADVxLzzwuiUQrttV1dpFpIzY3PfxUE1JZA+Q4rBtt7y7dt4sqGaSnr8uGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141188; c=relaxed/simple;
	bh=VwYEPu7gqsKAwklOkLRT46Ju2ASNwgfSE8LTq8gzW/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXCnP5JAxeOfK2G7JCwNIasNH39UQCKSVEjPbF5t1flNl2qvxvVYYX25hcLLigc5wzdLMQCgtCjTNbaHjIwZNysaCDAitcpZVpQwZWO6iMM9uMUQ+ZLgnBdi4M2Ezu0JhyKTZDQjnB3660CSUa0jrTsmU07bzVpu6mtX4B5c+J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHXU1n8Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHXU1n8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51C6C2BC86;
	Tue, 10 Mar 2026 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141188;
	bh=VwYEPu7gqsKAwklOkLRT46Ju2ASNwgfSE8LTq8gzW/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHXU1n8Q1JaiIXpea922YrhkudKUqEhOW2qWAUySf/cO8NbsReaRYiCAARczlmm5D
	 bkpg2cAiwCsKCa/5dy4+uVMeQCfxVqURuGozJRkRfrglT8R//h9TLxWBkjXaFz3tOk
	 pdlXPbROR/ZRCK0HmV6xllvEcI4pNuuOiLy8k/wJVFN9atVUHJe9RipAV2I2yDWMo4
	 bPC4uJFGULnd6RC5ioIt7UahXZ1aA1FQnMbHU4a0ne7VXk15eb1T57Ke4NhVlBXLob
	 RFNCw71rtbpn0DDDrZJByXd1YejzZpcBydarJNPUKX5Lic3mPSJbSBe9CrTETe7pUZ
	 HhbpEteHcxaRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <ustc.gu@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 190/311] pinctrl: cirrus: cs42l43: Fix double-put in cs42l43_pin_probe()
Date: Tue, 10 Mar 2026 07:03:57 -0400
Message-ID: <ab9f8437f867799113d5f8af1c7a2b349d3a7adb.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit fd5bed798f45eb3a178ad527b43ab92705faaf8a ]

devm_add_action_or_reset() already invokes the action on failure,
so the explicit put causes a double-put.

Fixes: 9b07cdf86a0b ("pinctrl: cirrus: Fix fwnode leak in cs42l43_pin_probe()")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
index a8f82104a3842..227c37c360e19 100644
--- a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
+++ b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
@@ -574,10 +574,9 @@ static int cs42l43_pin_probe(struct platform_device *pdev)
 		if (child) {
 			ret = devm_add_action_or_reset(&pdev->dev,
 				cs42l43_fwnode_put, child);
-			if (ret) {
-				fwnode_handle_put(child);
+			if (ret)
 				return ret;
-			}
+
 			if (!child->dev)
 				child->dev = priv->dev;
 			fwnode = child;
-- 
2.51.0

