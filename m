Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A2F33D50F;
	Thu, 30 Jul 2026 14:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421922; cv=none; b=qep8jM/bAUXgWdPJGiA4nj0ZOiHDOljKdt1Ok+G7QcmzdrpKNB+zvtayAlxQDiDPtBsYpfL6m0Hr2f40ECR1AWuDp9OuDIMgZyPm1vnmfx46ShJpKCozwv/2FLHV2moa/xe/juLij4nDcvSfvxsZTfE9O3/qSDiRU+N0CV2sJP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421922; c=relaxed/simple;
	bh=6lvPuFh3YdhvrsF4KC50VVTMqEWt/rnpTCmNEXSpknA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ied0J1My77urwUt+xiptxXO2uUvHNYqA2PRso7RZYD6yAn7SuGY+t84lhyRRxlSCb1ntYzCkS0BuG4EYerTle7caDDbiiThU/pXdcg20LelvMa32PeiUTgjBJg0S/rN141fIte9I0455LXya7Eko9DWOHu8pM5NsBF37Kzpv1eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM1s/5SO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM1s/5SO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD661F000E9;
	Thu, 30 Jul 2026 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421919;
	bh=G1gDSOAHodvdebAnXffgAeLsg9kvuVdnmsnCNSw4CRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM1s/5SO3MlOhUWO170jk06NY2FsOIejooTHF3w4CWXVSaFTH4LIACsVZGav4s5Wj
	 3pOiYOdVj+UIr2PW8sdtLlMiSencOLbxQSH6C71+hzsRInC/Q71X6taIY4G0p5bBvV
	 HyAVSvVJtv4ELFhBvgeZ+7nioAqhsde8RW3S6lSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 262/744] net: txgbe: fix heap overflow when reading module EEPROM
Date: Thu, 30 Jul 2026 16:08:55 +0200
Message-ID: <20260730141449.863258324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 6a905a71fd43ce8b45f05044b11491337f232c9d ]

txgbe_read_eeprom_hostif() always copies round_up(length, 4) bytes
into the caller buffer, which ethtool allocates with exactly 'length'
bytes. A non-4-aligned length therefore causes an out-of-bounds write.
Copy only the remaining bytes on the final dword instead.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Fixes: 9b97b6b5635b ("net: txgbe: support getting module EEPROM by page")
Link: https://patch.msgid.link/20260713085111.1481884-1-chenguang.zhao@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index 8fc32df8e49a44..479c83f5d6454c 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -96,11 +96,13 @@ int txgbe_read_eeprom_hostif(struct wx *wx,
 	dword_len = round_up(length, 4) >> 2;
 
 	for (i = 0; i < dword_len; i++) {
+		u32 copy_len = min_t(u32, 4, length - i * 4);
+
 		value = rd32a(wx, WX_FW2SW_MBOX, i + offset);
 		le32_to_cpus(&value);
 
-		memcpy(data, &value, 4);
-		data += 4;
+		memcpy(data, &value, copy_len);
+		data += copy_len;
 	}
 
 	return 0;
-- 
2.53.0



