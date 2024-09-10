Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9C018FDB1;
	Tue, 10 Sep 2024 09:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961664; cv=none; b=eVJ1rlq5DvIzmO9eE4+YMoCplWCOdF8OFCz1Zh2BcTGC99GK7Wbcs7TRDF8qxkcpL076VgcHUbGEBbQhMMpe3LoOSr93gvQl+iSIK3hFGqnTEi9KZHuSAjpv7LCjhWqa3HtrkJuKqbneKLFuOhf+WxNJ3TEITS8cwT4uHfkH74g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961664; c=relaxed/simple;
	bh=M/U36P/6vtCpUwuZ9DF4DpyfrFLCSCjVd4v7Stx5OyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igZ52E/tcOJdTd8NeQRXUp2QLsU1IGL68wwp8Q+/9hyGceDXz1zwBdTkQFThOzBn/4bT40NXLA+rIQAux3jwzKD7+sGi8/7cvJih9EVqDFVgTy4eWwsRzv02mOe2zS+hlwIJP7gtQf3/+0RdekhOuasu4Am7vXGZfWLVJUSUvVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dd690gT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dd690gT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EFAC4CEC3;
	Tue, 10 Sep 2024 09:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961664;
	bh=M/U36P/6vtCpUwuZ9DF4DpyfrFLCSCjVd4v7Stx5OyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dd690gT1CL3r0N8TYUIEmj9Etzsv1E6fISGVRZ8nZwcMsyCzPbxf2kYzAF7BxCv9A
	 l5TddBLNFecuJXZ1pLaBmuI3/Ahi0XWkPYC4vYLsick6WSZUOO+rP9GjNx9GDnSX3a
	 ez5g+TDAITvkBzrGIpxraTe3YWlvqwvNKPZuaGcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 147/375] can: m_can: Release irq on error in m_can_open
Date: Tue, 10 Sep 2024 11:29:04 +0200
Message-ID: <20240910092627.407220809@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 06d4ef3056a7ac31be331281bb7a6302ef5a7f8a ]

It appears that the irq requested in m_can_open() may be leaked
if an error subsequently occurs: if m_can_start() fails.

Address this by calling free_irq in the unwind path for
such cases.

Flagged by Smatch.
Compile tested only.

Fixes: eaacfeaca7ad ("can: m_can: Call the RAM init directly from m_can_chip_config")
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/all/20240805-mcan-irq-v2-1-7154c0484819@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 14b231c4d7ec..205a6cb4470f 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2009,7 +2009,7 @@ static int m_can_open(struct net_device *dev)
 	/* start the m_can controller */
 	err = m_can_start(dev);
 	if (err)
-		goto exit_irq_fail;
+		goto exit_start_fail;
 
 	if (!cdev->is_peripheral)
 		napi_enable(&cdev->napi);
@@ -2018,6 +2018,9 @@ static int m_can_open(struct net_device *dev)
 
 	return 0;
 
+exit_start_fail:
+	if (cdev->is_peripheral || dev->irq)
+		free_irq(dev->irq, dev);
 exit_irq_fail:
 	if (cdev->is_peripheral)
 		destroy_workqueue(cdev->tx_wq);
-- 
2.43.0



