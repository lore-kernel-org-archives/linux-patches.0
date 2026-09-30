Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B964DDB20;
	Wed, 30 Sep 2026 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784717; cv=none; b=jWhz3zxRKM1SONAPOBqoVMpNkHd3hIu4HXsMy/tNGNcZmO9sNaYwHaiapVl4mTKQE8yNSW6QZIuXkmACWAiW+Rte5SJS6vhEW944HV4lTXCtNKJdKp/IeWo4KyPW1cCFnOCxbBsWTZcejqjmy01bSJfZBvO/jpDtZty8UFY4ZZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784717; c=relaxed/simple;
	bh=mubmwMI3/M7X4vXEoiKEtYpm7Xp00hfTIzLpyHyip+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFzq4JE8+U/gZyIeMCRP6jnjXRwTcs5FauzgVJMiB74B1Q4/C2yc6D4PxX2EABsct/P8JNoz3vwnnGjISSBiucQtZmpxNwl/pMMuxiuAKc23XQcZMvbkcl0fOvSC8ARqkOrX1WC+GvtVjLYyHTUpnN33eiZqfxGR/0j0SyHbQ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjStzuW/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjStzuW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8C91F0089B;
	Wed, 30 Sep 2026 16:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784708;
	bh=m87B6NNNRmNijsmXDCiLOvTja78hhIQeMhuc9MsYFzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjStzuW/BKrNz047Knqh8oiwTTh7rl4zdWh2TO+YhkIBfPrTyzPnfxB7SHWNyxC4v
	 NDXN/jP+MR/ycCiEIFVRk27/o6D25fNE63qDKFM15LNtUsEwLPmtl9cZ1BG6FWc7CV
	 R1VshnvjuPzhnEuAhk+FXRzhzirNwOcMW2HngafE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 249/982] wifi: rsi: avoid reading TKIP MIC keys for non-TKIP ciphers
Date: Wed, 30 Sep 2026 17:16:25 +0200
Message-ID: <20260930152422.141984303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1b309e47a1f11..195d7394ab775 100644
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



