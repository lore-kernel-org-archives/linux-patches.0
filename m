Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB5322523;
	Mon, 18 Aug 2025 13:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523912; cv=none; b=grf5zFYjIQGluoRTGI/mROj3NKugjOtQN3ipyyR4i4b5ef+dTGe9NMatcgg4d1lnoWK6MxMCO2HCZdua7h2los1sWR34h2RNC0XiShQHnVfUuMQxseIWON4lgAjC5B2mDnu2zhRnZ9kPysEub6ZO2qVXPbc6u8utdLwWMubiZ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523912; c=relaxed/simple;
	bh=mFLUtCKOsYZCjMjGqiDpc7dU1XIR+Fi+LopXX/lva68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJwGN8K2r+0khe1DlmJFrRHtpe8bsS5qVqxG12tm29hZeEdl+rmwP7tWhXXnU9RSEFHsTT80/PrAt6mq2W21QDyChkcdP04PunPPN2W1cU/RslLm7y7DGHJAjSin7wf2dKmtlflmZ46bckXr3+yijfZHeU5XzHNvqEyYrWQCXe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weqFYjeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weqFYjeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42656C113D0;
	Mon, 18 Aug 2025 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523911;
	bh=mFLUtCKOsYZCjMjGqiDpc7dU1XIR+Fi+LopXX/lva68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=weqFYjeqdymZYOxNR9yccFqLanXboGKhFconiHH11xW5ExwSCSPiLT/imMyIi9uT+
	 Ph+Hea15CtNM8AWKPPMH+DohqSgo6B6WWyk+z4CXrsHbuSL9ibwgeDvVEvOVijCzZl
	 2FL9Vz4ZCCBkzGPI9DYA8/MZrxhZ987gWbUOC4Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 310/515] wifi: rtw89: scan abort when assign/unassign_vif
Date: Mon, 18 Aug 2025 14:44:56 +0200
Message-ID: <20250818124510.369586902@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 3db8563bac6c34018cbb96b14549a95c368b0304 ]

If scan happen during start_ap, the register which control TX might be
turned off during scan. Additionally, if set_channel occurs during scan
will backup this register and set to firmware after set_channel done.
When scan complete, firmware will also set TX by this register, causing
TX to be disabled and beacon can't be TX. Therefore, in assign/unassign_vif
call scan abort before set_channel to avoid scan racing with set_channel.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250610130034.14692-13-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/chan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index f60e93870b09..d343681c2c00 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -2680,6 +2680,9 @@ int rtw89_chanctx_ops_assign_vif(struct rtw89_dev *rtwdev,
 	rtwvif_link->chanctx_assigned = true;
 	cfg->ref_count++;
 
+	if (rtwdev->scanning)
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
+
 	if (list_empty(&rtwvif->mgnt_entry))
 		list_add_tail(&rtwvif->mgnt_entry, &mgnt->active_list);
 
@@ -2719,6 +2722,9 @@ void rtw89_chanctx_ops_unassign_vif(struct rtw89_dev *rtwdev,
 	rtwvif_link->chanctx_assigned = false;
 	cfg->ref_count--;
 
+	if (rtwdev->scanning)
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
+
 	if (!rtw89_vif_is_active_role(rtwvif))
 		list_del_init(&rtwvif->mgnt_entry);
 
-- 
2.39.5



