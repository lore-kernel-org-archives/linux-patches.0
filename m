Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C193515D4;
	Fri,  9 Oct 2026 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555495; cv=none; b=YDz+m5NakKJaq1ip44HAHjQnYubAhHb9Ji5JhR+2VnYeuw9SqB/pgvNJfBAYNBuexEXrzrZtlGzhkSDdEdfF7/GwbeT4GTOuP57C1+uUsfcKLI+R5bnY5YsiyW6wSP8gOFXMcfbre1Ms552mEidEbMX8v4iWucA/Q/79/CW1yyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555495; c=relaxed/simple;
	bh=B9Sm/v87K63vrT5poEj8m5qUFoLi/VnrPnctza06yf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaAkoPknbvO5fxzYqIDcHs87s810cXYUrKzSpoc8Q9MXflEtQh1IqRhmfOLVwI0Swih0piLxTp9/fxdj7uGXVnXGKNjBsiANaZpam1X3kOi/+6aZg+dvp1tzJGYYG14tB+XKDwOvBAWWMrOk4y1zvN5bAELMV+YxDcnpJD1c5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPINX5jC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPINX5jC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD321F000FF;
	Fri,  9 Oct 2026 14:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555488;
	bh=Rn5+7PrlRjbpaL1CVmVQkznjwD65a/tKjpVRHwyzPQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPINX5jCEYp8bl6gtfDtc/iGWBYL1k4Bm7WC6AWqePaSudQBh22R9qoTlWjDM6bVS
	 Ec05BUwyD1EpZ8D2q2XkfUKAkmOlP4yXOoM4ZQdA2o5PJP92CPiuwpl3VWqM6LaJaU
	 izPbhL3qEFejC0OZoZg+qxsFGlK2HNprNUHKGqzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/403] wifi: wfx: validate MIB read length before copying to caller
Date: Fri,  9 Oct 2026 16:07:07 +0200
Message-ID: <20261009140953.641425565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit ce67ebe9d8629776ce38e6995ae72fb903c828db ]

wfx_hif_read_mib() copies reply->length bytes from the firmware
response into the caller-provided buffer without checking that
reply->length does not exceed val_len. A firmware response with
a length field larger than expected overruns the caller buffer and
reads past the end of the reply allocation.

Replace the dead -ENOMEM check with an active validation that
reply->length fits within val_len before the memcpy.

Fixes: f95a29d40782 ("staging: wfx: add HIF commands helpers")
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Link: https://patch.msgid.link/AS8P251MB000155034FC391A2A54B9803C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/hif_tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/silabs/wfx/hif_tx.c b/drivers/net/wireless/silabs/wfx/hif_tx.c
index 9f403d275cb13..9efb108bd877d 100644
--- a/drivers/net/wireless/silabs/wfx/hif_tx.c
+++ b/drivers/net/wireless/silabs/wfx/hif_tx.c
@@ -207,9 +207,11 @@ int wfx_hif_read_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id, void *val, si
 		dev_warn(wdev->dev, "%s: confirmation mismatch request\n", __func__);
 		ret = -EIO;
 	}
-	if (ret == -ENOMEM)
+	if (!ret && le16_to_cpu(reply->length) > val_len) {
 		dev_err(wdev->dev, "buffer is too small to receive %s (%zu < %d)\n",
 			wfx_get_mib_name(mib_id), val_len, le16_to_cpu(reply->length));
+		ret = -EIO;
+	}
 	if (!ret)
 		memcpy(val, &reply->mib_data, le16_to_cpu(reply->length));
 	else
-- 
2.53.0



