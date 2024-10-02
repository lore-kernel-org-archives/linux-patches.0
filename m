Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8381D0797;
	Wed,  2 Oct 2024 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877456; cv=none; b=lfz7FdBWedzSQfMe4IsbN6IpsHvgl2ol3k2v8uJU6xCtMvF128Ta97Ja+QyGY4Xa4szuPJop6HKA8Bc/AosxRIUOMzikugzyRqizSH9peuJstS4de6Sd9LcxxjCY6IgazXqEwQgtaVBmV7eEA8Afch8H2fCBe4Rv+Hmt0VUoUZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877456; c=relaxed/simple;
	bh=JFOeO3aM2/rbpDQ2hCn/DShKecXBYPF7VkukgVUtk+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fg++JoNZtZsu7nd+cN9QsXYv0xP3lom9dvrza/EniRus25B4bxrzrIdm6L6hpj+3S5Rh8wt3Dulefs7nEQhLJcm46Eaer2G6ua7PVSvWrfOGmH3Ha42qCX4/SVTqabsF191lHFBIWb8P+bB4rCBJgeJXYDSBJGpIwmRY8gqWSfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STJuxwKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STJuxwKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07112C4AF0D;
	Wed,  2 Oct 2024 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877456;
	bh=JFOeO3aM2/rbpDQ2hCn/DShKecXBYPF7VkukgVUtk+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STJuxwKGfpu0vvsBKA5SgI0EcQ4LfnhBh0HP8Fdn3SMPNAAxu74M57b16GXYNI5I6
	 MP9Oc30jasg2JfvSlVrhfYtYKahP9hwny4EPz5ZiGgtC4z47uiyJhd/ktK7jjERoDR
	 KY86qHjCwFr7ku1RqrMSDNbiml9r/4wVx8AU5FWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 084/634] wifi: wilc1000: fix potential RCU dereference issue in wilc_parse_join_bss_param
Date: Wed,  2 Oct 2024 14:53:04 +0200
Message-ID: <20241002125814.427161133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/microchip/wilc1000/hif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index 7719e4f3e2a23..2ee8c8e365f89 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -384,6 +384,7 @@ wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 	struct wilc_join_bss_param *param;
 	u8 rates_len = 0;
 	int ies_len;
+	u64 ies_tsf;
 	int ret;
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
@@ -399,6 +400,7 @@ wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 		return NULL;
 	}
 	ies_len = ies->len;
+	ies_tsf = ies->tsf;
 	rcu_read_unlock();
 
 	param->beacon_period = cpu_to_le16(bss->beacon_interval);
@@ -454,7 +456,7 @@ wilc_parse_join_bss_param(struct cfg80211_bss *bss,
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



