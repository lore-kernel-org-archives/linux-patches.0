Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0D84EC66E;
	Wed, 30 Sep 2026 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784028; cv=none; b=tElw7UvByBusZfiVu13qc9ICAB6bIBz96DXLLn/mSlZRlW0cEmzw5ZyRD7EiPmblGP653/BbarKPPGqGUMixXnWafbUZ0h9W023lmmlE+Ty3K809rKaoHce0POul+2Fcto+Ezec4/GYItuswOHn5KPlvUsi28ngpzxAXc/HlRw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784028; c=relaxed/simple;
	bh=1BVIL8awjHxbtpRx+QKSEfPn++ImU22MKBpSn8/gntA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyX6l4zxY70Acgp2shKorE36OamziBEaepurmSzWPQWvHg5cUF9O+YdQzZfskIpAtCwZxcm0o8KCOzWJLTQCKxFm12DqGZQzfBgUjoL1rCs7Lse59dcLJA79vY1XcXcE6Jzl/9YELoGSsfqf3KMwMTwLGJ1HKNUwaOYhz7MVxXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CP94HSqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CP94HSqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDA31F000FF;
	Wed, 30 Sep 2026 16:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784025;
	bh=YohizN/RCBD3YNJs0Y8lnAwP3WfxEyO84/o0Lakhvc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CP94HSqcs6Ex5u8F78p+FddelC6qNalIJJ/0azU00kvFB6VwSFvHu7K9f6abacO8e
	 UhMnL+DXSIVMixtNNIGofJRtFhX7tTUyARgk3gE/JUwmEv1W1XEzox9GlZxpoBlQkP
	 Hu0ip4sxqFPsH/ZpB/e7OSXi4tz3FD+yNCevc0TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Oleksandr Havrylov <goainwo@gmail.com>,
	Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/982] wifi: rtw88: Add NULL check for chip->edcca_th in rtw_fw_adaptivity_result()
Date: Wed, 30 Sep 2026 17:12:27 +0200
Message-ID: <20260930152417.030476966@linuxfoundation.org>
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

From: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>

[ Upstream commit d5e6f353ce1e1c25b8458ea390ed09d2377412c5 ]

It was recently reported that rtw_fw_adaptivity_result()
in fw.c dereferences rtwdev->chip->edcca_th without
a NULL check. The issue is that devices with the
8821CE chip don't define edcca_th in their chip
info. As a result, when rtw_fw_adaptivity_result()
tries to dereference it, the kernel triggers an oops.

Add a NULL check for edcca_th before dereferencing
it in rtw_fw_adaptivity_result() in fw.c. Placing
the check at the function entry avoids logging any
garbage values.

This change does not address the root cause for
this behavior, but it prevents the NULL dereference
and the resulting oops while a more permanent solution
is developed.

Tested on a 8822CE chip which defines edcca_th, so
this issue is not present on it, but it still uses
this driver and I can verify there are no regressions.

Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Reported-by: Oleksandr Havrylov <goainwo@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221286
Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Oleksandr Havrylov <goainwo@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260415052959.14844-1-npetrakopoulos2003@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 0b5f903c0f366..28a37dcba223f 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -197,6 +197,9 @@ static void rtw_fw_adaptivity_result(struct rtw_dev *rtwdev, u8 *payload,
 	struct rtw_hw_reg_offset *edcca_th = rtwdev->chip->edcca_th;
 	struct rtw_c2h_adaptivity *result = (struct rtw_c2h_adaptivity *)payload;
 
+	if (!edcca_th)
+		return;
+
 	rtw_dbg(rtwdev, RTW_DBG_ADAPTIVITY,
 		"Adaptivity: density %x igi %x l2h_th_init %x l2h %x h2l %x option %x\n",
 		result->density, result->igi, result->l2h_th_init, result->l2h,
-- 
2.53.0



