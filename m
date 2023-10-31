Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC0C208C6
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdjSjQaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7469C433C9;
	Tue, 31 Oct 2023 17:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774439;
	bh=ANN6YBuEV0Nmh1Akadguq0IFhBdRcLsPtNZixoCq9Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdjSjQaOv2H1+8+jhnw7pz4vEmr4WT9UdldFcSaaSbNrv+hqTnEeH603dNdksB3/s
	 +Yzg6JjD07BK/KB+xZuRrQQS4jQEsWhuiqOqmyX4HcymBYVdoCqILp1Lo5jJ3xFYO+
	 9xe1Nzl/upYvYtuioU2NbQGtuR07S6NEy3ofXNz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 046/112] firmware/imx-dsp: Fix use_after_free in imx_dsp_setup_channels()
Date: Tue, 31 Oct 2023 18:00:47 +0100
Message-ID: <20231031165902.755614131@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <gehao@kylinos.cn>

[ Upstream commit 1558b1a8dd388f5fcc3abc1e24de854a295044c3 ]

dsp_chan->name and chan_name points to same block of memory,
because dev_err still needs to be used it,so we need free
it's memory after use to avoid use_after_free.

Fixes: e527adfb9b7d ("firmware: imx-dsp: Fix an error handling path in imx_dsp_setup_channels()")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-dsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/imx/imx-dsp.c b/drivers/firmware/imx/imx-dsp.c
index 1f410809d3ee4..0f656e4191d5c 100644
--- a/drivers/firmware/imx/imx-dsp.c
+++ b/drivers/firmware/imx/imx-dsp.c
@@ -115,11 +115,11 @@ static int imx_dsp_setup_channels(struct imx_dsp_ipc *dsp_ipc)
 		dsp_chan->idx = i % 2;
 		dsp_chan->ch = mbox_request_channel_byname(cl, chan_name);
 		if (IS_ERR(dsp_chan->ch)) {
-			kfree(dsp_chan->name);
 			ret = PTR_ERR(dsp_chan->ch);
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "Failed to request mbox chan %s ret %d\n",
 					chan_name, ret);
+			kfree(dsp_chan->name);
 			goto out;
 		}
 
-- 
2.42.0



