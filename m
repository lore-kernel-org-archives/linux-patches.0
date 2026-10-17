Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C113A7F41;
	Sat, 17 Oct 2026 16:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256310; cv=none; b=mrI2r3p1THzveSPhTsGix4F5eEKnr11/fvYL/fZdQwJK9szd4Ud/2AFHm78uBK/sSp/NI76Xd/n2psytADQT0B08z8DWgC/kkevgE2ONqUIk0nzQas0A859VwKPpgQs3mj4NzAQAYqnrztWeotrsIzChFx47vjFprqfJyn8jod8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256310; c=relaxed/simple;
	bh=ptdxzQ4cmoD3k55P+OOwmJR84iwGNbNXrKY88zYao3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QinluL/0AJqtq4zF3x0jni3lhCymAbqcZMDuPdoB9u6kEGFX+LUL6tYGxmesZWngmL+Y3Sbja/Su+bW5GAy0Jw2bNoK4ChUkZfCz8uyjLIU+1t3kdsZ69NpJ6asEOjYrpeG2jSaa15sMSFOtHkTIGYTWGJ4E6IdXt2Us1R3cus8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c618/WNn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c618/WNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C14C1F000C4;
	Sat, 17 Oct 2026 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256309;
	bh=X7OQXZUdIAE0IIu5l0zXfiif9TBgx9qdFZe8TyGRDh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c618/WNnVEc+pXhPFZ7DaulC3OlynZim2RFbhozKcZCR15Nj8p2j+MLxyea6zjjBa
	 h6lL3w8eueixb21CLELTZTBiIuvt5NL4Ul76XiT85uY6odr9edv1NdkRbOT1jQ6eI6
	 djmvDRuIBYXZnGW+iv2zxVT+YM47ZNXY7TCHpVUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0193/1674] wifi: wfx: validate MIB read length before copying to caller
Date: Sat, 17 Oct 2026 17:41:05 +0200
Message-ID: <20261017160436.107221406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 9402503fbde3c..852406fc7f3c6 100644
--- a/drivers/net/wireless/silabs/wfx/hif_tx.c
+++ b/drivers/net/wireless/silabs/wfx/hif_tx.c
@@ -189,9 +189,11 @@ int wfx_hif_read_mib(struct wfx_dev *wdev, int vif_id, u16 mib_id, void *val, si
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



