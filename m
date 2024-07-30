Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7691A76A5;
	Tue, 30 Jul 2024 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360687; cv=none; b=HFDteBiBbC9Bw9Ku7ZzujMee1gOosEN2Nkutgy4iuefClbpePasR88oP1kZ59b1cVWZNuo/QapxO/dEEJcdUNhcId5qKivxdTDl0OAjpA+Nt1Z0WxNPwYagx5AAXO7xFTFq5drLJdF2ZG0mOxyCFAC1sjcabi086K+pM+s4fcy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360687; c=relaxed/simple;
	bh=qBgbA8r32NE3Cm5M6Ckc/Qoce8+TQjnOfYiPngLtp+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDsKsOFUkAlZPzaRtmX0qbSz7v3BAHF8Pg6oXXnoPewWA34CLgZSwEd/LxTpx/EX+s9gPCYYp+RwwoXYsaNCd4jLxVQgbW41eNyFKmwyJWtGkIrT0ClhukiriMo+7lXxBj8mvQ1O3zIoVi/8PPLxhoMM+oa2DYEXjn+aT+mVf8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnNXraUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnNXraUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23081C32782;
	Tue, 30 Jul 2024 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360687;
	bh=qBgbA8r32NE3Cm5M6Ckc/Qoce8+TQjnOfYiPngLtp+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnNXraUkamP1L1foMSuzJlEuH+ic8OqXu7nPjo+5fIt9UvtGxiSB5H5VbmcaoyRxj
	 g3So3AZy/68aJbfw9/yvlETWjCJNoKqttBlnwtpzNtDSunFige5TVvDWgAOo6gZPAv
	 J9otKydXrEg2JGhSrke9Ptf82t/2IJQJcAeg87Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 777/809] auxdisplay: ht16k33: Drop reference after LED registration
Date: Tue, 30 Jul 2024 17:50:53 +0200
Message-ID: <20240730151755.656903981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 2ccfe94bc3ac980d2d1df9f7a0b2c6d2137abe55 ]

The reference count is bumped by device_get_named_child_node()
and never dropped. Since LED APIs do not require it to be
bumped by the user, drop the reference after LED registration.

[andy: rewritten the commit message and amended the change]

Fixes: c223d9c636ed ("auxdisplay: ht16k33: Add LED support")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/ht16k33.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/auxdisplay/ht16k33.c b/drivers/auxdisplay/ht16k33.c
index ce987944662c8..8a7034b41d50e 100644
--- a/drivers/auxdisplay/ht16k33.c
+++ b/drivers/auxdisplay/ht16k33.c
@@ -483,6 +483,7 @@ static int ht16k33_led_probe(struct device *dev, struct led_classdev *led,
 	led->max_brightness = MAX_BRIGHTNESS;
 
 	err = devm_led_classdev_register_ext(dev, led, &init_data);
+	fwnode_handle_put(init_data.fwnode);
 	if (err)
 		dev_err(dev, "Failed to register LED\n");
 
-- 
2.43.0



