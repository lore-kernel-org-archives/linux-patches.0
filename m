Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF5A4399E2;
	Sat, 12 Sep 2026 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211327; cv=none; b=UCubSwMhOR0a+RU+TXxql/6q/+ovRRGMJJmH8p3zl4kHOVO1vQjcZdfqMQL3HA+/GwJL18aDVA+n6sH8OUzU2k+cAakYOcGEbEJcWZhTXolAOln11Xu2d4FS9WVNozaf/qA95lRmezoOfaNeF7rqHrhRh4L+glfDE2UEZIPu0nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211327; c=relaxed/simple;
	bh=AztL5JSzSCtWBHuvb+AFw2qarLMMZViLPCkSuiOOvFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKqchKG/Qb3b5Ti1UedOLaTvprIQDUvOqcwbq3wW/rrM57zfSyE2nLkRYW8S6nLsgEGBo7qQTccaIiEXLZn3ArULGKVhrVl++LQIIX1I38B4MZcYEUYpTnT5N7/RqNEeJifeAlpcvLMiTmjrxHjL0m7DneBQU8jFLGeZ9PBfBCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htKsVGJQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htKsVGJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE42D1F0089B;
	Sat, 12 Sep 2026 11:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211326;
	bh=RW9ODmlzM9bbZ7eXuwgho+W9Y8CRWZAV7OefH7U941I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htKsVGJQ7Lb0FtGbCJ3/Zf1oqscXFD7gmqb0xfWPCVhUaw3uniBHQWkJ1TKksEC85
	 f/n6R7J3RDqBn+TX668ROy3lVfCtUAMmLYOSHFegHQMw9Wc3abZvbo6RgqtQXuPCve
	 pZdcLET5IcwI6fp/xQZpFzxPXbGNJvLbNSl/cmBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Yang <jia.yang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1209/1518] mailbox: qcom-cpucp: handle NULL data in send_data callback
Date: Sat, 12 Sep 2026 08:56:18 +0200
Message-ID: <20260912065650.838387014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index f68298b2a1912..57f731418fafb 100644
--- a/drivers/mailbox/qcom-cpucp-mbox.c
+++ b/drivers/mailbox/qcom-cpucp-mbox.c
@@ -110,6 +110,14 @@ static int qcom_cpucp_mbox_send_data(struct mbox_chan *chan, void *data)
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



