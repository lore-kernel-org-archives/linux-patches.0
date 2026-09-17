Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1595F4DEC2E;
	Thu, 17 Sep 2026 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668334; cv=none; b=IO6dILIxecfYY3C0YmzoAiffYncNEXLCyZHs63hP8yioXgJ+Oguvo/GoCClHF8b6J2BcSL/vXq32TQcATnJ+HpjkCeP7/ZOuknfIvxVhEh+egZyyNS1Bb0E4MKO0WVB9mCqxf7aQjmFlMVlU/QSo2S0vMs+vOSb/ATc5AnA8Csc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668334; c=relaxed/simple;
	bh=lto3RVY8/KigEnhuP3abFGYRbcq9ESmtQ4nyHrio1yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/+lMO6PRSSskSr+uqLAdaK+8ODdTPo7N+W1VZeP6IcPkhZ65nZa97WjnMfKWtZbRXBl/USCU093w3sYxRD0nDPCM7rchRDpJmSYAhZojtWCcCCVt2XTafQ1UISEq6Dxjc69Cc3SimQ44a0snuJ+L/a+J565XVD+ZKCoBMvow1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZX3JB56v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZX3JB56v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F59D1F000FF;
	Thu, 17 Sep 2026 18:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668332;
	bh=V6bpyeQMbA8GduJceRDvSgj3uLuKQwpPb4dfsJ6b2DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZX3JB56vctIufUfaYDtavEX7zS/F6Oe5yJwN9GWVPB4aMDhVo8rqzOHzZBJEXfrJU
	 V1A3/vCu2JXeHliTedERuFcDG8sicAueCtdYn2nM5slm647C6clxq7hNGYh1DPbenB
	 VnvlnQXvcJUp1s0jC9Qtq1Au1pWDbbGjVWxdJP1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0390/1102] wifi: rsi: avoid reading TKIP MIC keys for non-TKIP ciphers
Date: Thu, 17 Sep 2026 16:05:33 +0100
Message-ID: <20260917151549.447084600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 843fe9bc583b7686ca68312ac9319c9240a73c03 ]

rsi_hal_load_key() copies tx_mic_key and rx_mic_key from data[16] and
data[24] whenever key data is present. Those offsets are only part of
the 32-byte TKIP key layout. Shorter keys used by other ciphers, such as
CCMP, do not provide those bytes, so the unconditional copies can read
past the supplied key buffer.

Only copy the MIC keys for TKIP, and reject malformed TKIP keys that are
shorter than the expected 32-byte layout.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260701053414.34015-1-pengpeng@iscas.ac.cn
[drop useless length check]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 7f2c1608f2ce3..2ddf4d158bfe3 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -848,8 +848,10 @@ int rsi_hal_load_key(struct rsi_common *common,
 		} else {
 			memcpy(&set_key->key[0][0], data, key_len);
 		}
-		memcpy(set_key->tx_mic_key, &data[16], 8);
-		memcpy(set_key->rx_mic_key, &data[24], 8);
+		if (cipher == WLAN_CIPHER_SUITE_TKIP) {
+			memcpy(set_key->tx_mic_key, &data[16], 8);
+			memcpy(set_key->rx_mic_key, &data[24], 8);
+		}
 	} else {
 		memset(&set_key[FRAME_DESC_SZ], 0, frame_len - FRAME_DESC_SZ);
 	}
-- 
2.53.0



