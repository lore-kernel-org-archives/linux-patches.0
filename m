Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDF73B05A4;
	Wed, 30 Sep 2026 18:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794655; cv=none; b=ZObkuTngh0mJwMJj86cRYLJfNXFO6jbB0vnCnPkO+0Xpa8Ln1BYUtMBylT6rkL+sereoKa9csyoBxrl7iuzQAymD9qLuDskWsvN5rJf+cqy0LvEzGqYP1wnhrEK905nETGyvwS5AK2pGtoM7J2L+18LJG4HMF6eXE6xNHJjda6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794655; c=relaxed/simple;
	bh=Zng0+gsH3j6Y4HBwk5XhrT4aSYmOWPNhluik08760eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FehSsdZIYsTwdslTEfXA22Tbe3s7pSqXwmwMegyVZ5+U9bE6j2L4yFFvtJIh4WxiQ9+M3nugLSdIQVGLi1E6bZM98d7JPfYajklgR2JKnWMsDDv5AEXz7drUTO2xvgQkyERC8FhoG/VGdt6tFl4+MPMbGgpkpHQ6nndI2j555m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSZzccNv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSZzccNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B604A1F000FF;
	Wed, 30 Sep 2026 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794654;
	bh=gkvg+YMccGcFlJ/etZrAf2QaqIefvu/lf7O4lbqxyM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DSZzccNvnEMfbQBqgHYAyetZeU/c8nNXnEJJPiNqI7t6SQut8mVwpgnITjY75GpkC
	 IV0vhSUErN2/O/4U16iNECXRcjbbmgvNpHq1g5Azejbehpf9LoHTkzuDW0CqO4537N
	 WlN4ADCHgVKbmgKUnMZPx6EEsIb6SsfA6Ytx43WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0288/1193] wifi: rsi: avoid reading TKIP MIC keys for non-TKIP ciphers
Date: Wed, 30 Sep 2026 17:16:12 +0200
Message-ID: <20260930152440.563691713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



