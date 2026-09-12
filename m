Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443FF352003;
	Sat, 12 Sep 2026 09:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203773; cv=none; b=RFP8VdVsGB5vll5ZupwB2lfKX3Rj2VwlPRsKwrVfxXfKNgVS2AYQUGsnY7WH4XggcpLCZH4CrBpON59Uny5m7zj2Wy4rozPVDs1iAm8yhG1IIfEs9lUOEb2FSx0M8vjdwIb5wLKAnHu2Xgz3cLp6PHDkvzb+3E0cm2MWcIGHCO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203773; c=relaxed/simple;
	bh=0Iz1ROwCVVzIFgSxvNpOBuVZWFi26icbERIiFjwezE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cC0tWiFBTNpBmZI9wdg37gzr02XH1NKlbsc+Ng3jUzOKxl47XJ5U5vI2e5EYxdMVLeRJJp59+kcEvKRrM3OzbyC2tVXcMRDEZ3Gd+J4wRlxYhR4ZpW51SKuB4duxuks9VX6spuhsq5xf86S2w4675nJotisrQ9NKtVBYQx3l9wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNKike1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNKike1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E7E1F000FF;
	Sat, 12 Sep 2026 09:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203772;
	bh=4QT13Iy7mfotb0zU2/YE6eZK1azqb7JExT+O/Lsp6Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNKike1CJOcvGLcUttaFfU7rjDeEXVf7u+GcdjMlDTNpsajhSvusSA/Crr8K+YIsv
	 WRSa05FMYAY5QEzqR23Cg8pjiQ1JyCEqEWjnAwSVf9FhGN81Va/55ST0v1H6mLjwzl
	 FYaOYTXUEksViYTjbbde+y4z8YPsfSRea7ELUvuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Yang <jia.yang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1477/1815] mailbox: qcom-cpucp: handle NULL data in send_data callback
Date: Sat, 12 Sep 2026 08:53:47 +0200
Message-ID: <20260912065723.680487372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Yang <jia.yang@oss.qualcomm.com>

[ Upstream commit fc4f2f99530298a1739226947aa76525142d421d ]

mailbox_clear_channel() calls mbox_send_message() with NULL data to
notify the remote side that the RX channel has been cleared.
qcom_cpucp_mbox_send_data() blindly dereferenced the data pointer,
causing a NULL pointer dereference kernel panic when invoked from
this path under PREEMPT_RT.

Add an explicit NULL check and return early without writing to the
TX register, which is the correct behaviour for a channel-clear
notification.

Fixes: 0e2a9a03106c ("mailbox: Add support for QTI CPUCP mailbox controller")
Signed-off-by: Jia Yang <jia.yang@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-cpucp-mbox.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mailbox/qcom-cpucp-mbox.c b/drivers/mailbox/qcom-cpucp-mbox.c
index 0f7fe189e8b1f..298b357c0f9a6 100644
--- a/drivers/mailbox/qcom-cpucp-mbox.c
+++ b/drivers/mailbox/qcom-cpucp-mbox.c
@@ -117,6 +117,14 @@ static int qcom_cpucp_mbox_send_data(struct mbox_chan *chan, void *data)
 	unsigned long chan_id = channel_number(chan);
 	u32 *val = data;
 
+	/*
+	 * mailbox_clear_channel() calls mbox_send_message() with NULL data to
+	 * signal the remote side that the channel has been cleared.  Nothing
+	 * needs to be written to the TX register in that case, so just return.
+	 */
+	if (!val)
+		return 0;
+
 	writel(*val, cpucp->tx_base + APSS_CPUCP_TX_MBOX_CMD(chan_id) + APSS_CPUCP_MBOX_CMD_OFF);
 
 	return 0;
-- 
2.53.0



