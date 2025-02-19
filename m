Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974D1CAA65;
	Wed, 19 Feb 2025 09:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956086; cv=none; b=dvd/jeDmIujdaj3nTcT7F+H1lvuZRszDqKegs2UppHkLpM8MRGAyAUR+OSsKgnjdbWvcWlWyj8cwZNai3KabSHSLvdJva/h28xzZUXlmNivFsq5LlK0xjLCEU0rVbhMNoX3XCHGnJnw9yw9U9NwsvsYKuSlEXEw7xguv5qupPbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956086; c=relaxed/simple;
	bh=ivW/Iv8gTwpGWt9C1jHsrpXwTp0UNLc1Nogv1Di1vpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyB+sl4v1z0D4n5gJ1aJyyw2h/i1BUH6FiIaU34/HehdmX10sxADDniHShOddKLVDtZkoTo1ZHSN+PN5GIAj+o+gqrN+HEn7yZbSgmnZq8WqTa4OoJD1+Ck5Hm8Fyo8zD4mFHkl3orUBbhQvZyEp1V/ev6IrfxY5vyfrVWp+p1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jusIWyot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jusIWyot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B1BC4CEE8;
	Wed, 19 Feb 2025 09:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956086;
	bh=ivW/Iv8gTwpGWt9C1jHsrpXwTp0UNLc1Nogv1Di1vpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jusIWyota8QFst3+oBtmizovk2ne/5ZefP7lp2r8snNE2rsx4DjR2RiH8Pa+avqBc
	 gfjd3z5L8H8LL+GXteM5FQ18ChB4TuFiX8WHNrmQ/5BEXPAiCChEtKC2yFy3EglSrG
	 mhjwNMRCBGCuWkuLCGXGo6ywMGnyNyCF1jWJQsB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/578] leds: netxbig: Fix an OF node reference leak in netxbig_leds_get_of_pdata()
Date: Wed, 19 Feb 2025 09:21:03 +0100
Message-ID: <20250219082655.209742621@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 0508316be63bb735f59bdc8fe4527cadb62210ca ]

netxbig_leds_get_of_pdata() does not release the OF node obtained by
of_parse_phandle() when of_find_device_by_node() fails. Add an
of_node_put() call to fix the leak.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 9af512e81964 ("leds: netxbig: Convert to use GPIO descriptors")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/20241216074923.628509-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-netxbig.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index 77213b79f84d9..6692de0af68f1 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -440,6 +440,7 @@ static int netxbig_leds_get_of_pdata(struct device *dev,
 	}
 	gpio_ext_pdev = of_find_device_by_node(gpio_ext_np);
 	if (!gpio_ext_pdev) {
+		of_node_put(gpio_ext_np);
 		dev_err(dev, "Failed to find platform device for gpio-ext\n");
 		return -ENODEV;
 	}
-- 
2.39.5



