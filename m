Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B0411705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79371C433C8;
	Mon, 11 Sep 2023 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442968;
	bh=00iuae5JbGwT1LwcMk0YSqpaBvYIEmC1lvCMRwk3MA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DR76MMRxOz6k2FW/0WYrVONF/aGkQeVdIjJbB4vY6XMVQu15IxJzhaG8yb8YBg/Bn
	 nU+lsV/+wUAtiJ635RuTGIk0Jg1A1jkCH0dmuvfquhJAWmHlEr10es3G351LxeNn4r
	 iXAHgAgvLGqfDh3KWKqhBUmbG0OCqJ0U3TmQvmWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 184/737] wifi: ath12k: fix memcpy array overflow in ath12k_peer_assoc_h_he()
Date: Mon, 11 Sep 2023 15:40:43 +0200
Message-ID: <20230911134655.710692118@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 603cf6c2fcdcbc38f1daa316794e7268852677a7 ]

Two memory copies in this function copy from a short array into a longer one,
using the wrong size, which leads to an out-of-bounds access:

include/linux/fortify-string.h:592:4: error: call to '__read_overflow2_field' declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
                        __read_overflow2_field(q_size_field, size);
                        ^
include/linux/fortify-string.h:592:4: error: call to '__read_overflow2_field' declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
2 errors generated.

Fixes: d889913205cf7 ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230703123737.3420464-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 58acfe8fdf8c0..faccea2d8148c 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1634,9 +1634,9 @@ static void ath12k_peer_assoc_h_he(struct ath12k *ar,
 	arg->peer_nss = min(sta->deflink.rx_nss, max_nss);
 
 	memcpy(&arg->peer_he_cap_macinfo, he_cap->he_cap_elem.mac_cap_info,
-	       sizeof(arg->peer_he_cap_macinfo));
+	       sizeof(he_cap->he_cap_elem.mac_cap_info));
 	memcpy(&arg->peer_he_cap_phyinfo, he_cap->he_cap_elem.phy_cap_info,
-	       sizeof(arg->peer_he_cap_phyinfo));
+	       sizeof(he_cap->he_cap_elem.phy_cap_info));
 	arg->peer_he_ops = vif->bss_conf.he_oper.params;
 
 	/* the top most byte is used to indicate BSS color info */
-- 
2.40.1



