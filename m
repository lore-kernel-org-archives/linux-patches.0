Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C6E267AF2;
	Tue,  8 Apr 2025 11:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112486; cv=none; b=kncBkmle7bIBPfGzoUXywoZBMhnFmpCBb2B0XsVAFbI4Re8260EQBXGAgPb5PuVxsHZ2CQySuzt0ZDVyiwRVDFtEqfH0pmzvvbBFZZZ6p3d/0Ue7BIG1KJfN+yPALv51rC+z2SMX6WmCcswvken1N4CPERSUpst0SWLoL8e6GP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112486; c=relaxed/simple;
	bh=M6NRKdE2dqTP5mnqkXS//O2iUGb8amp+7UCn7cGUWws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snSBK9zh9JNDvs0mrEfcpjd8jf57LvpUa0tlK1agLmWyil8gT+hoOVmNrOoknbjHRJ2CZaOeCMinIFTYXixUfb6q/3YAjsXJsRCNifeIsQ9WN1D9WJw7MZpwqWp4jSawYq5E1BTjLATm9Ytbk4iyQRw7y9XWqOZ7vtJ/37XJNVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ft3kzF/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ft3kzF/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F62C4CEE5;
	Tue,  8 Apr 2025 11:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112486;
	bh=M6NRKdE2dqTP5mnqkXS//O2iUGb8amp+7UCn7cGUWws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ft3kzF/Pw9woF4Joe1D3bSbO+aOOaw/lAfbjKhX11q6nLdgYc9lGPBND9USqvBDG1
	 txwXrHR5eBbzHRvPCCRnLKwPfrvCPF4dFBmY/MZkwcpjpXcTVEsgHQpWc18Aqbe/PI
	 4XpegXFVVEGWVyejF8yJcwhSJghvPBBkE/J5FeCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/279] firmware: imx-scu: fix OF node leak in .probe()
Date: Tue,  8 Apr 2025 12:47:42 +0200
Message-ID: <20250408104828.476962791@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit fbf10b86f6057cf79300720da4ea4b77e6708b0d ]

imx_scu_probe() calls of_parse_phandle_with_args(), but does not
release the OF node reference obtained by it. Add a of_node_put() call
after done with the node.

Fixes: f25a066d1a07 ("firmware: imx-scu: Support one TX and one RX")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index dca79caccd01c..fa25c082109ac 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -279,6 +279,7 @@ static int imx_scu_probe(struct platform_device *pdev)
 		return ret;
 
 	sc_ipc->fast_ipc = of_device_is_compatible(args.np, "fsl,imx8-mu-scu");
+	of_node_put(args.np);
 
 	num_channel = sc_ipc->fast_ipc ? 2 : SCU_MU_CHAN_NUM;
 	for (i = 0; i < num_channel; i++) {
-- 
2.39.5



