Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F61230D0D;
	Mon, 18 Aug 2025 13:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522290; cv=none; b=WD4NODFuQd2/2nhCVSXD2iGxfBABcyAm6dEG1j0tGI/JsLY+DJd6c25kUdLMlvGmfDw1ldJvbLbLs8VcV+Ijp78hdWzzrrAZWChI3xnF6HWFaX7KJ6ZFj8TC8ZpxLwbj4x1O5d8Us8q7IUPnXJYV4DxeJ5h9XJyZE53Hn2Dl2qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522290; c=relaxed/simple;
	bh=9GxcHCa9E+brpnU5g7R8LXRWfruuQaXzFTKSm2LNMms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImMFOs353Qu9KSl6YPTSnom299LLsDqizbwaEANEYnNEz0D7s2uyt1XEqkwJrykaWeyvO2nvv6JXMhU73BdArIdOBEQQehi46ZeDzHcs/qWbdbM2WDU26EpZpyvvTyn5OiMn9mdD6EZpGYZv5wa/V/kCgKuS4JgRZ3/+hALcSPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gn2T6Cs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gn2T6Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EEEC4CEEB;
	Mon, 18 Aug 2025 13:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522290;
	bh=9GxcHCa9E+brpnU5g7R8LXRWfruuQaXzFTKSm2LNMms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gn2T6CsLaiXFHkcaDtsr5DJ3CSFTKqgFADgtTk5phHbte9wX7epw+r/FMqWlZsXH
	 b3tqcJz0TX9cfXxJ0J73V0PNCBF3BqJbjfYdKoXAJCGP6yPtTNvL2RJtB2V1ODzx2i
	 odtt1ToJLJrb5Neo+a2QEt4LNjgLxRxtCQOvC3rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/444] wifi: rtw89: scan abort when assign/unassign_vif
Date: Mon, 18 Aug 2025 14:44:41 +0200
Message-ID: <20250818124458.381354885@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4df4e04c3e67..559aa60e3df0 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -2682,6 +2682,9 @@ int rtw89_chanctx_ops_assign_vif(struct rtw89_dev *rtwdev,
 	rtwvif_link->chanctx_assigned = true;
 	cfg->ref_count++;
 
+	if (rtwdev->scanning)
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
+
 	if (list_empty(&rtwvif->mgnt_entry))
 		list_add_tail(&rtwvif->mgnt_entry, &mgnt->active_list);
 
@@ -2715,6 +2718,9 @@ void rtw89_chanctx_ops_unassign_vif(struct rtw89_dev *rtwdev,
 	rtwvif_link->chanctx_assigned = false;
 	cfg->ref_count--;
 
+	if (rtwdev->scanning)
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
+
 	if (!rtw89_vif_is_active_role(rtwvif))
 		list_del_init(&rtwvif->mgnt_entry);
 
-- 
2.39.5



