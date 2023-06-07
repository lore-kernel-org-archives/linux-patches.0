Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7EF39251
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0196C4339B;
	Wed,  7 Jun 2023 20:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169227;
	bh=pQ/5k1AQ+zLaXa874EIKPhb50W9/u7lSf26AGbJiuDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbytxvJpAACsYAZhNrCr6xDHrdD/eic1CX1on0VvPC0//iM77HyJqjce02KZWq3Mh
	 ILVkXQASpO5xGyC8+ZViNhW5cNLIcwvVsXYTuewr2uL4u33kJvpzOWSpZsA1nw6TTr
	 2lCR/NWPPNrMd948dmhGdvpx77qVX6TntwJXlsmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 4.14 61/61] wifi: rtlwifi: 8192de: correct checking of IQK reload
Date: Wed,  7 Jun 2023 22:16:15 +0200
Message-ID: <20230607200856.233687007@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ping-Ke Shih <pkshih@realtek.com>

commit 93fbc1ebd978cf408ef5765e9c1630fce9a8621b upstream.

Since IQK could spend time, we make a cache of IQK result matrix that looks
like iqk_matrix[channel_idx].val[x][y], and we can reload the matrix if we
have made a cache. To determine a cache is made, we check
iqk_matrix[channel_idx].val[0][0].

The initial commit 7274a8c22980 ("rtlwifi: rtl8192de: Merge phy routines")
make a mistake that checks incorrect iqk_matrix[channel_idx].val[0] that
is always true, and this mistake is found by commit ee3db469dd31
("wifi: rtlwifi: remove always-true condition pointed out by GCC 12"), so
I recall the vendor driver to find fix and apply the correctness.

Fixes: 7274a8c22980 ("rtlwifi: rtl8192de: Merge phy routines")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220801113345.42016-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2414,11 +2414,10 @@ void rtl92d_phy_reload_iqk_setting(struc
 			RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
 				 "Just Read IQK Matrix reg for channel:%d....\n",
 				 channel);
-			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
-					rtlphy->iqk_matrix[
-					indexforchannel].value,	0,
-					(rtlphy->iqk_matrix[
-					indexforchannel].value[0][2] == 0));
+			if (rtlphy->iqk_matrix[indexforchannel].value[0][0] != 0)
+				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+					rtlphy->iqk_matrix[indexforchannel].value, 0,
+					rtlphy->iqk_matrix[indexforchannel].value[0][2] == 0);
 			if (IS_92D_SINGLEPHY(rtlhal->version)) {
 				if ((rtlphy->iqk_matrix[
 					indexforchannel].value[0][4] != 0)


