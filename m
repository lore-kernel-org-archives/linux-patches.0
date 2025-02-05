Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6421A522A;
	Wed,  5 Feb 2025 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765231; cv=none; b=RMNZ/jF3QgunqbrRu5gH0rmrJ+DitEY3qefCcKDsg/14u1eIk0zWn/ujGaosZHlTEj30hlHNUreocFdYPqv0PE02UD779tq2P2JNIGGHK3f7XIapq3dARDgFSKOgnu91mGBxmdd4CS4TLVmsaA+RcbOQ3/JrMniuOXmjkVlTbAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765231; c=relaxed/simple;
	bh=HtiwUiXUnZRofw33dAgctjsUBkws9m3hr5Rm3Yng6oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkaZ7W0Lr1Q9m9wg29kNpYLVX5+geTF8kY4NC5BnrG9KkTr9mqKxBm29MdInoBxMp2qynK76q/b3VR6g+WOIPlDmM+A5ev+M43JBenags7iTYQn67Fpvqz0Kdxcio5PNCNrllNQwDtmNSR11ygyK3TC2eFd7+j6BNGnKSeO6ERA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3Hsh7mH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3Hsh7mH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39E8C4CED1;
	Wed,  5 Feb 2025 14:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765231;
	bh=HtiwUiXUnZRofw33dAgctjsUBkws9m3hr5Rm3Yng6oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3Hsh7mHP7Im7RfIsIgKNGHMDGrrlUaYhqjx7Us50boKyeGGO0gH1Fcsnwqv9KM9c
	 AdEoIYmX/wCZQ4LFmzlb4AioWSLh2zcgIRUHDtdqiC/YFX/96SZe7YC5OrSTBGK3in
	 kr/Rcy28XpsYWumsjMaAwA5dGUo7w59887E8MZVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 158/623] wifi: rtw89: mcc: consider time limits not divisible by 1024
Date: Wed,  5 Feb 2025 14:38:20 +0100
Message-ID: <20250205134502.280516122@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 35642ba31dc4a1816a20191e90156a9e329beb10 ]

For each MCC role, time limits, including max_tob_us, max_toa_us, and
mac_dur_us, are calculated if there are NoA attributes. The relation
between these time limits is "max_dur_us = max_tob_us + max_toa_us".
Then, the unit is converted from us to TU. However, originally, each
time limit was divided by 1024 independently. It missed to consider
the cases that max_tob_us or max_toa_us is not divisible by 1024. It
causes the result breaks "max_dur (TU) = max_tob (TU) + max_toa (TU)".
Finally, when MCC calculates pattern parameters based on these kinds
of time limits, it might not perform well.

Fixes: b09df09b55fb ("wifi: rtw89: mcc: initialize start flow")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250103074412.124066-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/chan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index c06d305519df4..4df4e04c3e67d 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -802,7 +802,7 @@ static void rtw89_mcc_fill_role_limit(struct rtw89_dev *rtwdev,
 
 	mcc_role->limit.max_toa = max_toa_us / 1024;
 	mcc_role->limit.max_tob = max_tob_us / 1024;
-	mcc_role->limit.max_dur = max_dur_us / 1024;
+	mcc_role->limit.max_dur = mcc_role->limit.max_toa + mcc_role->limit.max_tob;
 	mcc_role->limit.enable = true;
 
 	rtw89_debug(rtwdev, RTW89_DBG_CHAN,
-- 
2.39.5



