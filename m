Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D689426A08C;
	Tue,  8 Apr 2025 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109826; cv=none; b=NKyG7A9ZLyILafeFYJLXf5wXquykHzbQNZQl+CdD4cTi4KeKLZke4HkHKAzplZK+t4cFCm/dQF4zs3emg2/Bh7KiTvkbMuiRNVSvt6EuXacnI4zZTwHj22zTZAbM6ofiHc8yQ+vbQOe8oJ+QQZrF+0KAVgoAVckg6nm9Zp8acnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109826; c=relaxed/simple;
	bh=yh5mIIrpa/iTxuJycjJXIKfGo7qgxfxUzDuDrsBgTOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCy2QsVyGmgH02vkP5m8u4bgptNgVSYTHnuWPBGDeEcYZBVwaNwPPFmf5EwcAyzn8KYCRNdDkqvWrpyXe9PwbOXupO4E5LjDbcJx8SAS2ylJVFIWMl7/pDp7R1gcHfFH6+hsrawWuSuZaARVmHe7c3hVMp4Ghbc3qYRCHjs9glA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qy+klQ94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qy+klQ94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6786DC4CEE5;
	Tue,  8 Apr 2025 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109826;
	bh=yh5mIIrpa/iTxuJycjJXIKfGo7qgxfxUzDuDrsBgTOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qy+klQ945z2JBJey0bgTzfZpbwdgPQhTIlKEn0ZPZORbROCxioRuogjTNOXAVfYZg
	 G9zcs19y7LcnyEvUjOsKBALhh5XHD/vuhvsXRK3LukBOlkPT/fUa/NLKq/DiVOJDax
	 jPMXRgPZEa6HZFGqf2mf9Cek8KokTkFOP9Y/YO6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/227] firmware: imx-scu: fix OF node leak in .probe()
Date: Tue,  8 Apr 2025 12:47:25 +0200
Message-ID: <20250408104822.414477127@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



