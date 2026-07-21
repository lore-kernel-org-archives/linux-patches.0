Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211E546D094;
	Tue, 21 Jul 2026 17:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656388; cv=none; b=j8/LC3wOf1uMsBAKzqhPLucJDVs9w1MnTu6oxxGho0e1M9LM6wK92ytadI20iRlD7l6r+T7rrufYvKz7kzSmkA8ZJ4I9ha/iS7NBKXZz0pS5BvOPbr5nT7jmB6g4tM5BHmlZsCMRW4IncMBHYZ1cAvIkRNRlko+VXjkSAUtk/Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656388; c=relaxed/simple;
	bh=nFjyKV65q+goWuzyM5Ffk67dy6vBSdANaKAuKr6079E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXYP5sFgxX/bFuyaLgWXVISnWucRUdxsIbkKfOggT6ExN+Q/GaHOqMVAqXOKeTxj2jZTF7Pt1emHzDFV4DsFQvYOngAhDRwk577B5JvFlC3C/yXlpHZMiRnL7lQoppB++A2eJdbL0pTvZKLhYu4G3giWBA2nNJGxuJfJ2DD8Xbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1QwgKtf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1QwgKtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877091F00A3A;
	Tue, 21 Jul 2026 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656387;
	bh=ySEb3aV9lL5NLKeeaREVrF4MGEcbc2DUHf8dmyDJhpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1QwgKtfGt1Hs29Ospq1hdia+oTcNCK8r54k1tT80XZcqi/22rwgQxNAHm6Iir3AE
	 BzRCJaQ+5in0VKWe/fzYdIV6t7d9Xo0vw/bTjX1DGzDtXqqD3IBaN9ZzkbFNpwIihx
	 r/9PA4RDPPp2Z38VuPikF+nqB3W9XHfx3BCxTez4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0366/1611] wifi: wcn36xx: fix OOB read from firmware count in PRINT_REG_INFO indication
Date: Tue, 21 Jul 2026 17:08:02 +0200
Message-ID: <20260721152523.395167554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit df2187acfca6c6cca372c5d35f42394d9c270b09 ]

The firmware-controlled rsp->count field is used as the loop bound for
indexing into the flexible rsp->regs[] array without validation against
the message length. A count exceeding the actual data causes out-of-
bounds reads from the heap-allocated message buffer.

Add a check that count fits within the received message.

Fixes: 43efa3c0f241 ("wcn36xx: Implement print_reg indication")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260421135018.352774-3-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index f550eb86301322..0cea465edf327d 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2865,6 +2865,12 @@ static int wcn36xx_smd_print_reg_info_ind(struct wcn36xx *wcn,
 		return -EIO;
 	}
 
+	if (rsp->count > (len - sizeof(*rsp)) / sizeof(rsp->regs[0])) {
+		wcn36xx_warn("Truncated print reg info indication: count %u, len %zu\n",
+			     rsp->count, len);
+		return -EIO;
+	}
+
 	wcn36xx_dbg(WCN36XX_DBG_HAL,
 		    "reginfo indication, scenario: 0x%x reason: 0x%x\n",
 		    rsp->scenario, rsp->reason);
-- 
2.53.0



