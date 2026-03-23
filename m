Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A02370D76;
	Mon, 23 Mar 2026 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277868; cv=none; b=ecX22cMRdfYOJd24B91VhLAwXMA/L4wfnlwrU3PHsif/RdZ86t3PZNWIGmED4ypJt0EkUiof+Cx3ZSZwr8GhFrJTIa71+dxVfMoGBCeCVwZ1xj9pmzRtBxkiZJ87MABs6DJ9AE/Vw3QqNaezaq5g4bk59FYiFlCVoIN3Csarc/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277868; c=relaxed/simple;
	bh=rZtDFOb1ayk2LHEQw+4aEkzaPJUAUZvTA1NC3NA9Mzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlrysizRlgJ7vBwIRHILIq3jgKyYbHLXzxRA5iAhJCwVnZkixAdISN16rv2jIeLYLIUN4UzZSNKsr1G7+Wd2fXMe5YR0zpE0rDS0WjSW6zoAbA5Ws6++yJl3uY+f92/Bv55it21lfK7Qzu1ZvE5pimw3VGEYGUykUj2XGu/9eGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDaZRj5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDaZRj5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C803C4CEF7;
	Mon, 23 Mar 2026 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277868;
	bh=rZtDFOb1ayk2LHEQw+4aEkzaPJUAUZvTA1NC3NA9Mzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDaZRj5D8TyUCzCI1lR8uEwF2XNY1QSLGe7WihOWVAD6B/XTqirhcfl4HDM2OVh5t
	 93lg5dwLASc4h4zQrzaSRIU8fqyJeZfevHKeTvgQOBSWfffZp7rb82s9ExHCzcFRLI
	 173BO3WhU+erwft+fXmq1FDUHA2ZI+58aCCJFpx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/567] pinctrl: cirrus: cs42l43: Fix double-put in cs42l43_pin_probe()
Date: Mon, 23 Mar 2026 14:40:47 +0100
Message-ID: <20260323134536.948739798@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index e1ac89be7c847..1640c5522f0e8 100644
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



