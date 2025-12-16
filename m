Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E55313E13;
	Tue, 16 Dec 2025 11:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884258; cv=none; b=J5mwFPy8/kstJUr97dBKBa9LnO/Is8IQRu8Otx3ZnT+qfufSm0T1fJnfKZhgKJuEtphKtZiR7f8DK6tn4hPtdhQCPUiypPmVlU58NFf7lwKGHhvzWBf3pXsU9xJe/slTy8vwRsvoTNBOPp9f/Gd8ApLVhSax2LjzC0POqWuHgys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884258; c=relaxed/simple;
	bh=sznC+t1XTl/HCul0M1Uw3hbtY7J+vBEJ1vaYEuQOAh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm737EK82gt0/rx7a7Uq4fY1b7tcfNWzW+HrN12wOaWWxh5BxdYHd94yRIi+hZJeKKyyJn2IELQY0L9/PHJLwJmvaCrJWMr1UhYRlzeBqKf6Gd6u56XqxgsjH9UPLsvwCR2e2+5I+VaJzOxSmDtm/0XBq5mMXmtLKIBRu6AuZg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIreHzIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIreHzIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2218C4CEF1;
	Tue, 16 Dec 2025 11:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884258;
	bh=sznC+t1XTl/HCul0M1Uw3hbtY7J+vBEJ1vaYEuQOAh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIreHzIKcKgpnhUS07yt3h45lRqEQLoSdTvSzmPAq4v0uCuLrCcyZTip2RV/PvBnf
	 9GJFi9AFJEoQrqTNO/WsjB2cBc7lyEszq0M+e+YE1CZviChpiq/23gaLlxcW9InDXD
	 Fj9Uwrioo6svWxv6AEYVN5Fss1zhptBQeejqT3mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/354] power: supply: rt9467: Return error on failure in rt9467_set_value_from_ranges()
Date: Tue, 16 Dec 2025 12:11:13 +0100
Message-ID: <20251216111324.760100912@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 8b27fe2d8d2380118c343629175385ff587e2fe4 ]

The return value of rt9467_set_value_from_ranges() when setting AICL VTH is
not checked, even though it may fail.

Log error and return from rt9467_run_aicl() on fail.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6f7f70e3a8dd ("power: supply: rt9467: Add Richtek RT9467 charger driver")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Link: https://patch.msgid.link/20251009144725.562278-1-i.abramov@mt-integration.ru
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9467-charger.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index 235169c85c5d8..faa5de2857ea0 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -588,6 +588,10 @@ static int rt9467_run_aicl(struct rt9467_chg_data *data)
 	aicl_vth = mivr_vth + RT9467_AICLVTH_GAP_uV;
 	ret = rt9467_set_value_from_ranges(data, F_AICL_VTH,
 					   RT9467_RANGE_AICL_VTH, aicl_vth);
+	if (ret) {
+		dev_err(data->dev, "Failed to set AICL VTH\n");
+		return ret;
+	}
 
 	/* Trigger AICL function */
 	ret = regmap_field_write(data->rm_field[F_AICL_MEAS], 1);
-- 
2.51.0



