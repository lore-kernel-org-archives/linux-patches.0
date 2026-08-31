Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CDA51043D;
	Mon, 31 Aug 2026 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183794; cv=none; b=VR9hUd8tAtlK1ZI8ZJbXIHv/ox9hp6ioT1+7EucrfO3XR+ntn3oV+mwN4SOBZkKea25iu4vN6thLMLoLkQLHjDjpRY06xvB2vWiPOq7fTwnn9puY4u9V98k7lqxnk1l2IUFN7xEOapsod4KO38fD7B7+24LTsSRN7OzbNVvTW4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183794; c=relaxed/simple;
	bh=ybXQpZUfgZ32ccm9FuhYE2lLDrtz7oXawzEZP8k0oS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RmlApoFuEdBAB/9rfNoS0tANT0nCyWHj6G8w4sMkmbEMrPtYlbtRcGQVGRKQqJ29N4/tvNHjG4vTrHZJeu2gDDR5vpd0nBRvJcB+HrjQ12Id0XN6rbjIsujKC7r+WMgwfy0OaNL9FNinyerS7fZWzjMuIEXrqhzpZlsBzyWGG0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5A8qDRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5A8qDRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0E11F000E9;
	Mon, 31 Aug 2026 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183792;
	bh=w5lh3aCVAo9rPW0i7OECtnfBmySyoPR//G0XDXo8WSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5A8qDREHDGa6ygPD2ejc3GlKhbpYdHAWjPgWheHzrulCmThyWAvW16IKSadMuocg
	 3HtWKNl+4IisArd8blKAumn77ehFixYUH3h1ciufkgC5IFycoNUCNk9xXNiNiwuj8Q
	 sYpPdhIuEIMr59IW+GlWNl/9ijMTfwW5+6rijeB/eSa1Qj4vsH9Fx8/3zzbxAG+bfI
	 ZTgCo3TOPPOPNiJGOpeONFKNLgoe8sXhwM9shLgaidOybf9FbmzPDhEvxJ4gWKa7AR
	 855cY8/8QSrVkWKcuHC6JQRigSXXRk4+HecDoqDMqB+Uj3Ei0fUXJ2xB3IsrErxMv8
	 sj5ROdm7bKP6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: rsi: avoid reading TKIP MIC keys for non-TKIP ciphers
Date: Mon, 31 Aug 2026 09:25:35 -0400
Message-ID: <20260831133314.4125787-307-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background `git log -S "tx_mic_key"` search finished, but it wasn’t
very useful: with `--all` it mostly hit unrelated commits, and without
it the shallow clone only reaches the graft root (`5d324e5159d9e`).

Tag checks are more reliable here — the unconditional MIC key copies are
present at least as far back as `v5.10.1`, `v6.12.1`, and `v6.18.44`.

**Verdict for this 6.18.44 tree: YES** — real OOB read on CCMP key
install, small maintainer-reviewed fix, applies cleanly.

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

