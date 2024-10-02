Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A04216F84F;
	Wed,  2 Oct 2024 13:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875414; cv=none; b=r/ZvDu5V01fFUvQ8U+cWyZs99fUq4DKVF4JldOnuHJrZt7ottsZH5JGpgTK3/Yi5vAXktSOVkfC1dkYYQApJ0IKWR7ZRs8KXFm4nu5e4FOrATzzPlrnNnvPf+ui1l2KiG8FVTZxoJnE9aQkRj4hgY2ZeR1ckzF8WnJzx2+Av+P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875414; c=relaxed/simple;
	bh=bY73kVYfNIeBnjfLX/F1Wwe5BKGsuSNqAFvZPlf+5Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HD0tFa4f0YIoismrE6hyYY8QBRtR5kT05ZMBAoA1a/qr7PdklHo6bdm90dEjpIvW3EoijSnOfsDcB0LGj6aTouhus/aMgyjyNM7gapvTXMsmrPIPbh2ilyVctp+Kii5lURyERT7Zw44a5bEJoT33rjjbYfF9KWjTf6M1Jz/YUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0ftZnnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0ftZnnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F04C4CEC5;
	Wed,  2 Oct 2024 13:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875414;
	bh=bY73kVYfNIeBnjfLX/F1Wwe5BKGsuSNqAFvZPlf+5Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0ftZnnubcETPn3a/dcEQh+YUQdkfamlw9Wm4nkAamFKJubX9mWqTRq/U/9G5Gx04
	 VxjC3WH3Yi6mHIO8XllHrRTkGPDpjCrNfdz8BNTan8JADXOEEsP/r25/YJ6oJ0RQN9
	 iC60cHHGBU3rOKQ0yvxWYNHF9joCEXXQfGU7zPhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Ye <jiawei.ye@foxmail.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 094/695] wifi: wilc1000: fix potential RCU dereference issue in wilc_parse_join_bss_param
Date: Wed,  2 Oct 2024 14:51:32 +0200
Message-ID: <20241002125826.230741933@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 3c48e1a57b24c..bba53307b960d 100644
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



