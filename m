Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61A01DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZF/cqeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ED9C433CB;
	Wed,  4 Oct 2023 18:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444120;
	bh=iBCd4ajgQA2o2NWgIhKCiQQb7ohEfczeLdhYGazwFzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZF/cqeTKTVf6xGqVuQDW85qHdvPV3MepxwCtUVnZrTpffbCb5qaHyFZVhQD1ktYL
	 4xcs9PWxYsux1nNElnqIoi88Fc3pCxJ1cyhTGJ2VdEhfkgCe0V91pDXpR/A+IxpAEw
	 Tw0eQ7/1C/Da5doOdm1052p08Nroh8sb4Df79ISo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 137/321] firmware: imx-dsp: Fix an error handling path in imx_dsp_setup_channels()
Date: Wed,  4 Oct 2023 19:54:42 +0200
Message-ID: <20231004175235.591344421@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e527adfb9b7d9d05a4577c116519e59a2bda4b05 ]

If mbox_request_channel_byname() fails, the memory allocated a few lines
above still need to be freed before going to the error handling path.

Fixes: 046326989a18 ("firmware: imx: Save channel name for further use")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-dsp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/imx-dsp.c b/drivers/firmware/imx/imx-dsp.c
index a6c06d7476c32..1f410809d3ee4 100644
--- a/drivers/firmware/imx/imx-dsp.c
+++ b/drivers/firmware/imx/imx-dsp.c
@@ -115,6 +115,7 @@ static int imx_dsp_setup_channels(struct imx_dsp_ipc *dsp_ipc)
 		dsp_chan->idx = i % 2;
 		dsp_chan->ch = mbox_request_channel_byname(cl, chan_name);
 		if (IS_ERR(dsp_chan->ch)) {
+			kfree(dsp_chan->name);
 			ret = PTR_ERR(dsp_chan->ch);
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "Failed to request mbox chan %s ret %d\n",
-- 
2.40.1



