Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E503446A6;
	Tue, 16 Dec 2025 11:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885492; cv=none; b=FIpp4razXwzT8l0GcfQY3m7JhgzZxfbQNwx55/UhtAUW9GP1Q5xhk/xZI4A+hc3fbuBgDzXohMZGElKEoAq6ynvLzheJNQhvZS/Sa8yBFubFbAsIE6v8wBU/YyC26hGBdTO3ZC1Pnl8qJx7F9OWQqcwTWntBRNsiXL4QwvGkI+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885492; c=relaxed/simple;
	bh=9hoO12CMJ7DxS133hgJ+emRMEkLok5YIZ6XDrWF5dsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC3ab95PyJo7PNP+4euqj2vGW3pUTqSBySRYMWB4ZL2fxf/Qr9mxeKxCVxq5J3qBDjw2xlSkFYtkoVo05/1GqZh81LYT9tTJ3IJVfPztU+8hh2LhOzJaa7mLnsbGqeRFJscaVdhDNuzNK5/5svfvpPdpw/sU0V/mHkZHIS9WbmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtlu+0pK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtlu+0pK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258ECC4CEF1;
	Tue, 16 Dec 2025 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885492;
	bh=9hoO12CMJ7DxS133hgJ+emRMEkLok5YIZ6XDrWF5dsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtlu+0pKv4R3SUIYST9oI5SrKJ+Be9KClTJdMLmDn0EG6Tv4fMfexNtwz2ihITX1Q
	 203SxYcADEQIJ5wia0NK4eUEBJvT0fhycoRH83c7r6WJmd44LhOkfsWEG5+ZgDL0TQ
	 r2wRVUf1dgLtklBlRZAeKNP+YGTOitvSUjmshMro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 155/507] power: supply: rt9467: Return error on failure in rt9467_set_value_from_ranges()
Date: Tue, 16 Dec 2025 12:09:56 +0100
Message-ID: <20251216111351.140208882@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index e9aba9ad393c9..5f3efcac4a1bb 100644
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



