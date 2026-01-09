Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4387B2DEA6F;
	Fri,  9 Jan 2026 11:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959704; cv=none; b=iqZV0CJEnP/ZTWgevQn4Zm4hNIVLZQOj48IxpUVdKAitg4ddnVxT3A9M27PVndEq6kKtfUkcvaSmQJREEU306P4gq+v81O5mJbsdm9LVvXg3/bZgtSFNlaNoWRWcHI0d16zRrKnHLV4klMiyGQriolkKxcRgIOJCXknyl2APHk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959704; c=relaxed/simple;
	bh=9MIT1mgdkbqtKVWWru9hgIpli0r05AZMNN6zMyI8IT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7o6PNKxJvjRlBU9LCF4MVLJcocHgRo4PGKkYpRSELUMy5QQ/Fhfdjd9FHPxZjnprCsKa8Rdw8hFtrmsjKo+x0haejUqW9WhWFEaQr9x5evPO6CaEa2D7O5ae1XF3oOuYMQRCrPftCTK5UBiQkfmhStSgj2rrnYDiXMSv2tOooo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SugNrlN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SugNrlN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3793C4CEF1;
	Fri,  9 Jan 2026 11:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959704;
	bh=9MIT1mgdkbqtKVWWru9hgIpli0r05AZMNN6zMyI8IT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SugNrlN5K0AAK6hJdz0JPhNL1h/6hzvdMQt8kkUI7PXTGXEomktM5+YScJq7uQ2sE
	 bTCyTY6Hz637W7/7l1dmm9VgyVadtzuUu8zDzVOAxA0nQ6Aru834VirhcXjbVHFOwC
	 ecaAbofmLAgXMuMUPkBdME1pgiexBJBYoggy4B3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/737] power: supply: rt9467: Return error on failure in rt9467_set_value_from_ranges()
Date: Fri,  9 Jan 2026 12:34:12 +0100
Message-ID: <20260109112138.256461957@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index fdfdc83ab0458..1462d630e399c 100644
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



