Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28E14E2F1B;
	Fri,  9 Oct 2026 14:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555835; cv=none; b=HLiMTtx2ZDSMOuF+Gl30i+4aObawgaDuaJ1akDrHGWHh9fK3e0X0lylJmTLzYo/QCQedgBYPM0iAUGZvelsjpyb3t5lF2MCGNEVwdBPet/LOLEheGUm98oPEOLbNvi6s+bH09QKFEdisL5xpdKBPJN8cKAF41P6IF0X2cnWw04M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555835; c=relaxed/simple;
	bh=F4kq/XypGeZw614KLTmlrLUCO1eXO/64KNvnpVvRNWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcOJ0oiibE4Pxdg1RamsBvkgVgSlYlT/+00q7t7bhOuy+WhhRHMrIulLod/pzl4PVX8b44xRwEfEG7PKZRvYDVie8a1PzF7cJ3Aq2iMDhnORzMYZOJVaGa7NWCxn477JKRNZwGbscNoFiWohj1YBDURlm5y58T6oBicZ8Vh2ByM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8H/8Rzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8H/8Rzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468921F000FF;
	Fri,  9 Oct 2026 14:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555833;
	bh=KOleVCEZcWPKADNYf+2J8N0H2IXc58wSday43n76q8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8H/8Rzw2l65y18XWt4S2QVBWvPf3z2vXdfTZSIKatCG/XOy535bY/B8vC75kwIPk
	 CiKV4Nx3ljfAkZnT3CF9BEjUSR9t/WjF5LHQjl9DhqKeRgz3rMmiwoVOIPjC7yPmmj
	 RN4ZYArTTWbQuy7bd5NcsbAva0Be1RfUTkh6ZwMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 077/428] wifi: wfx: validate MIB read length before copying to caller
Date: Fri,  9 Oct 2026 16:06:54 +0200
Message-ID: <20261009140947.858321811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



