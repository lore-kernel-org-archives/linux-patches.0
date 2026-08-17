Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B927F175A99;
	Mon, 17 Aug 2026 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976731; cv=none; b=HmOYkLUuozX2zUlQTDwSqWDBBngpxIc2Zk+yq0bKot4D651ScGai6lRba/CqX7G77+7euIwa7c5jI+SmF84xa3qRFMCqlwV/nlnvrfNjwf7o6i/b/bi7eflSeGMFCe7TPlCjdNk4zb6lxlS4uAJJ9+FbWUkr+sQ9vikbvz5Q5Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976731; c=relaxed/simple;
	bh=Yitopl22jIBL2LB1y6D3TIJ+0dP1ugn2B63P/g/0w2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/U0BOmTwNzD2qYOQd+1AGP1TBBk3gq83nJViBPnZD82/CLNe4DDHpyUHW5wMeL0OppAnCV3AQ8acoJ31yN21hkkvXiVM/LZvdtrTFtBaPJHgeBgSUAGwfSFbVnzpL9IFWZTi5o02CcXNAKkaVtV5ulYhtE/uljtm7YqZmGqhDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+s/gmxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+s/gmxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7061F000E9;
	Mon, 17 Aug 2026 14:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976730;
	bh=KXUhWhD1gzGpPucjASehNxQds3EzNPjIkaTesEf8hhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+s/gmxZpqZAvi3WUBslk2keI4F31N+58ySn/OEqZzQjJciT2/M1XvNftrJ5FZCFW
	 pheUlzDf3+n9qX8x5/eyaPwAaHlDT239IQHjSYzbSjPTfP3rNxe79rghJAnHNNPEnH
	 DTco0HeS/76/2mj4u4qRN8gxT7zLjKg6JdyYxTDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/456] wifi: ath6kl: fix OOB read from firmware num_msg in TX complete handler
Date: Mon, 17 Aug 2026 15:27:54 +0200
Message-ID: <20260817132543.396579405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 3a21c89215cc18f1a97c5e5bfd1da6d4f3d44495 ]

The firmware-controlled num_msg field (u8, 0-255) drives the loop in
ath6kl_wmi_tx_complete_event_rx() without validation against the buffer
length. This allows out-of-bounds reads of up to 1020 bytes past the
WMI event buffer when the firmware sends an inflated num_msg.

Add a check that the buffer is large enough to hold the fixed struct
and the num_msg variable-length entries.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260625232907.3620746-1-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index bd1ef633499780..55607e3adacb24 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -484,6 +484,18 @@ static int ath6kl_wmi_tx_complete_event_rx(u8 *datap, int len)
 
 	evt = (struct wmi_tx_complete_event *) datap;
 
+	if (len < sizeof(*evt)) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "tx complete: invalid len %d\n",
+			   len);
+		return -EINVAL;
+	}
+
+	if (len < sizeof(*evt) + evt->num_msg * sizeof(struct tx_complete_msg_v1)) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "tx complete: invalid len %d for %u msgs\n",
+			   len, evt->num_msg);
+		return -EINVAL;
+	}
+
 	ath6kl_dbg(ATH6KL_DBG_WMI, "comp: %d %d %d\n",
 		   evt->num_msg, evt->msg_len, evt->msg_type);
 
-- 
2.53.0



