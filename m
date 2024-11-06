Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694651DFE1E;
	Wed,  6 Nov 2024 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897868; cv=none; b=LgTAc6WpnRE77cUj5+Djd88tmLyapbdIYY1tJep/KVrUvz3HNqpABJ7TqGjGbUj6Kxiwh2uDsMC0bB87BsKjjYjDNofxm31AQPhyOcCoU6jA7x6qKttGt96WIC+drx++uTgm0WGoxSJcK7xRMvGiL+rd/j40Qrj+i/EDEcmvPoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897868; c=relaxed/simple;
	bh=F4Qal/97qdkpTYXCpKsQD23f5Iq+4j8HxeGhu2mrX+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfSULl9Hcs7p4uPLsSW3p8UYS0saGclatFHY+nXBQRGw37DU8alpwZHwwmGUZ6VRhWkgULng8/Th4f2ghLST1pAKsA+zDrPb/EDqT0iTEll1Q/zXjm4YdDX97A9rrziV1fII991qoPwmJXdmq/j45MT0+J39lGAfdgIcZLxua40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kS8VL219; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kS8VL219"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB89C4CECD;
	Wed,  6 Nov 2024 12:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897868;
	bh=F4Qal/97qdkpTYXCpKsQD23f5Iq+4j8HxeGhu2mrX+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS8VL219pKUSsUI/W6Fv98FyzbIoaNQucrsDJ4eb3VkMb1H/rE4fzFmNBSLZVv6KI
	 MUYdo4f1G2VJUmM/0G0hOe4B1ORB4y2kHBkFAJFM/MG9L2EIwuktExUxvnzyKjNkev
	 XCtPhZ+z0TKlyN0FKB24C+IfTd8PZTiYYCAa6HfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/462] wifi: wilc1000: fix potential RCU dereference issue in wilc_parse_join_bss_param
Date: Wed,  6 Nov 2024 12:59:00 +0100
Message-ID: <20241106120332.680803651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawei Ye <jiawei.ye@foxmail.com>

[ Upstream commit 6d7c6ae1efb1ff68bc01d79d94fdf0388f86cdd8 ]

In the `wilc_parse_join_bss_param` function, the TSF field of the `ies`
structure is accessed after the RCU read-side critical section is
unlocked. According to RCU usage rules, this is illegal. Reusing this
pointer can lead to unpredictable behavior, including accessing memory
that has been updated or causing use-after-free issues.

This possible bug was identified using a static analysis tool developed
by myself, specifically designed to detect RCU-related issues.

To address this, the TSF value is now stored in a local variable
`ies_tsf` before the RCU lock is released. The `param->tsf_lo` field is
then assigned using this local variable, ensuring that the TSF value is
safely accessed.

Fixes: 205c50306acf ("wifi: wilc1000: fix RCU usage in connect path")
Signed-off-by: Jiawei Ye <jiawei.ye@foxmail.com>
Reviewed-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/tencent_466225AA599BA49627FB26F707EE17BC5407@qq.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/wilc_hif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_hif.c b/drivers/staging/wilc1000/wilc_hif.c
index 7f54665c0a0f6..98f1c3102d688 100644
--- a/drivers/staging/wilc1000/wilc_hif.c
+++ b/drivers/staging/wilc1000/wilc_hif.c
@@ -448,6 +448,7 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 	struct wilc_join_bss_param *param;
 	u8 rates_len = 0;
 	int ies_len;
+	u64 ies_tsf;
 	int ret;
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
@@ -463,6 +464,7 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 		return NULL;
 	}
 	ies_len = ies->len;
+	ies_tsf = ies->tsf;
 	rcu_read_unlock();
 
 	param->beacon_period = cpu_to_le16(bss->beacon_interval);
@@ -518,7 +520,7 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 				    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
 				    (u8 *)&noa_attr, sizeof(noa_attr));
 	if (ret > 0) {
-		param->tsf_lo = cpu_to_le32(ies->tsf);
+		param->tsf_lo = cpu_to_le32(ies_tsf);
 		param->noa_enabled = 1;
 		param->idx = noa_attr.index;
 		if (noa_attr.oppps_ctwindow & IEEE80211_P2P_OPPPS_ENABLE_BIT) {
-- 
2.43.0



