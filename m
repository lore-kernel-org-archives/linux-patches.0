Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7999F2236EB;
	Thu, 12 Dec 2024 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024840; cv=none; b=Om4pTz2hXgsNCmWNQcmBnbRkQoFGe8QZp43b4wUwi4AYY5o353ugtpB92PLaeLBts72TqDUjd6O8dJCwdSfQX40U742azA0w3t86eXqQjxu9WJdFao3oKcW6J5yyO4mq+Z+wEYjmU9DVHvAZyOgxBYK8G5K2zQkvg3wrfCUETrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024840; c=relaxed/simple;
	bh=SuPF9fIulFCsjuqAxKI248MRMR+ZlZGK8QMIqFO4I60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHBHNkOxD+6WRbcmcz5fkmqVK6BTrAPLUJi4jmwocAxEFSQ4g8+y62Tx0Y5JmoheSsPO+OrPr6SldAmec3FAOI6J3Sw5rQoroBustCYbUqPXjrM7Uv5QQRCsnwSBjY5yZfXgLtwiyT6A/zrNuzSoAiVRSuOo30vgS2kM+F6vrZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kukfiWnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kukfiWnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00745C4CECE;
	Thu, 12 Dec 2024 17:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024840;
	bh=SuPF9fIulFCsjuqAxKI248MRMR+ZlZGK8QMIqFO4I60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kukfiWnMq14q/LQjj0hjwvL/a9VTlIfxY9dQi0GtrMO9F0wnLdwGlRFBff4a7Kn8M
	 cjByS/xmlMvxClMQ5tXPU3pgt5CXRjAIqCHHTNsKMSccoR51F9nQR7aaEbL1Lx5T1P
	 DUCBZZ7OYhp/nB/6OJRc3+UGksjqIiAsSh6oUYAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/459] usb: chipidea: udc: handle USB Error Interrupt if IOC not set
Date: Thu, 12 Dec 2024 16:02:47 +0100
Message-ID: <20241212144310.708839172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 548f48b66c0c5d4b9795a55f304b7298cde2a025 ]

As per USBSTS register description about UEI:

  When completion of a USB transaction results in an error condition, this
  bit is set by the Host/Device Controller. This bit is set along with the
  USBINT bit, if the TD on which the error interrupt occurred also had its
  interrupt on complete (IOC) bit set.

UI is set only when IOC set. Add checking UEI to fix miss call
isr_tr_complete_handler() when IOC have not set and transfer error happen.

Acked-by: Peter Chen <peter.chen@kernel.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20240926022906.473319-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 5cdf03534c0c7..1c7af91bf03af 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -2024,7 +2024,7 @@ static irqreturn_t udc_irq(struct ci_hdrc *ci)
 			}
 		}
 
-		if (USBi_UI  & intr)
+		if ((USBi_UI | USBi_UEI) & intr)
 			isr_tr_complete_handler(ci);
 
 		if ((USBi_SLI & intr) && !(ci->suspended)) {
-- 
2.43.0



