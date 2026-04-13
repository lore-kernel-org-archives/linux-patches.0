Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAC12FFFA4;
	Mon, 13 Apr 2026 16:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097584; cv=none; b=kDcqX67mWv+7FfzMobBTv9IY0BCC/DA3RWS9k6H2NIXGM3hK2rIAGTP/SuWxkFjA0DddoPX6XTqe2BAtnClu5EXoue/CITS6y6hoduqs/NOunIhyOyZbiwtqfPrKXeMDPC3EN/KrMd6XmseMeVqpUQ+IsY1woOIFR37BGF9mSZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097584; c=relaxed/simple;
	bh=yjBlP+61ItWlirC+/vs6FTrVdRSjC+nnYtaJyzx2lKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmwMylqw6xqEPfwQ6ax9//SIiqx9MVJnV8PTO8jm2NoYqRPIouMgOR2puclT9ujA13JHRV9NhB6EW9KkB07aqpoJhMX/nBzYFEmRYpMA5ligYV7FZGzVSS9Sn1R33bz/KHMNr7y/qZRyhhk+8L3PMNM4FDwEFrEQehIYo6ZhImg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCqt7SsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCqt7SsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB61C2BCB3;
	Mon, 13 Apr 2026 16:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097584;
	bh=yjBlP+61ItWlirC+/vs6FTrVdRSjC+nnYtaJyzx2lKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCqt7SsExOPtGmevB31866YbkW8NRrtxH0d5VrlulF4GiaO2vLVIYRgIXn7HrRrAd
	 9E6z7Hnfvr2QQmDn6xuOLJnjOsUqLHpTecsvLxsEXTWCBC3131JxKfNMIQVCB2CgqA
	 Ae6vLpaGSyJViUfSY5H8MZtyW4xmNEZkMHnMGa9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 5.15 161/570] staging: rtl8723bs: fix potential out-of-bounds read in rtw_restruct_wmm_ie
Date: Mon, 13 Apr 2026 17:54:52 +0200
Message-ID: <20260413155836.482088554@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luka Gejak <luka.gejak@linux.dev>

commit a75281626fc8fa6dc6c9cc314ee423e8bc45203b upstream.

The current code checks 'i + 5 < in_len' at the end of the if statement.
However, it accesses 'in_ie[i + 5]' before that check, which can lead
to an out-of-bounds read. Move the length check to the beginning of the
conditional to ensure the index is within bounds before accessing the
array.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20260224132647.11642-2-luka.gejak@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -2008,7 +2008,10 @@ int rtw_restruct_wmm_ie(struct adapter *
 	while (i < in_len) {
 		ielength = initial_out_len;
 
-		if (in_ie[i] == 0xDD && in_ie[i+2] == 0x00 && in_ie[i+3] == 0x50  && in_ie[i+4] == 0xF2 && in_ie[i+5] == 0x02 && i+5 < in_len) { /* WMM element ID and OUI */
+		if (i + 5 < in_len &&
+		    in_ie[i] == 0xDD && in_ie[i + 2] == 0x00 &&
+		    in_ie[i + 3] == 0x50 && in_ie[i + 4] == 0xF2 &&
+		    in_ie[i + 5] == 0x02) {
 			for (j = i; j < i + 9; j++) {
 					out_ie[ielength] = in_ie[j];
 					ielength++;


