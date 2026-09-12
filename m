Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6710447D931;
	Sat, 12 Sep 2026 13:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218440; cv=none; b=PJniKFg7WmG5GWbNnQJpBuY+sdpZqkaLpq4D/WoPIP2PKCyEwoAjRc7Quaz2wEASyX8ARG/Naoz9pj1B95vDZYTn+5Nie0SQ5CCP1horabYsLTU73lsZMgWMRraIHjRZTT/pD25DjPYJMI6au0qjKfkmjOOqsZ91+7v57srIUgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218440; c=relaxed/simple;
	bh=TC8Y5nN3JehVSy34KjFf4pLLmpyGNWzN+l/4IoHBQ7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJJNEmDYCvws5H0eHaVcwVVMp5HNGRq+h3SB6nJvYTUnogmk5g9dMFuDhYK6xpi1H+vhlXySFkfaT3HL9JUJPHuE3t5d+dWOFVwlHjas0BTpUdJqU2762mvtHb+23D4zkwbj6VHFC0ffDKRAhQW57o/Ex15qoZGMzwFcn/IYFz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jONyZhnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jONyZhnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B6C1F000FF;
	Sat, 12 Sep 2026 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218439;
	bh=KLbpu0wASxls1ChjveuNPu7VoKUdScjdF8jqAmmVogk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jONyZhnSz14bHe2QiCx2T11AwWji7b5vGorZDQ7v1hPDe/y37fj9wEf5SrwPLDcLe
	 Y1wMBc1k3h7hqn8b3qUQMefkc1018+dxuLhOcXBoDcz8aem4lGmzF4jKyr8MXO0P69
	 BRgvxLSrr3OySSxQT5Wiybp+d/Ivt4y74XiTmHck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Yang <jia.yang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1144/1376] mailbox: qcom-cpucp: handle NULL data in send_data callback
Date: Sat, 12 Sep 2026 08:59:30 +0200
Message-ID: <20260912065633.054409646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



