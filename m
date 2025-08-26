Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF36833CE88;
	Tue, 26 Aug 2025 13:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214195; cv=none; b=d7SF1KN/zSH5q0DQZ5Q1fjA49l2TD2ZNfaMrmk9zEGLeOZzuobCZmFt4/XeH+dNdASOTdTSn6eLrUSRvaDolE4TgMJoYhdNSUu204hQNtYRtU+G+Ez94b5YKlmoQaK6JGTR9+0Cd/HBcJUVX2LV4HF4xKSGBKMxbfq8RxVsUJ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214195; c=relaxed/simple;
	bh=ylrZn/6oyXUhcP8hFM3mjnaMNHJS77/QXNDkTeDpBe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyayvYC//OksEkZbCcvIf2vQd5g0Sazb0obAzTs2hfVoaECpOVlrwVOVkyVoZs1GeZne4HQObO+4oqRURb+JSryw76q3sW88W2stLRwPjy+nKPXqeffIAK6f1EWZNZh590WHdD55dBKTMHmSpC1qC5Wo8iVIBMkPc1jXLkzzBKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1bzKEKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1bzKEKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CE1C113CF;
	Tue, 26 Aug 2025 13:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214194;
	bh=ylrZn/6oyXUhcP8hFM3mjnaMNHJS77/QXNDkTeDpBe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1bzKEKK/jLRPfDiDdYFobGBZwtZXxDmmNowckm1Bi4JphQMzN5uj6dAbZPaPQ0JM
	 Xt0KlKFha6MvpiZ7PFf+2MWCNIiLmlK1RjJuEcHGoU7pPAutB7EDKC7nkImVqOyV6+
	 vOB4Vcx/J5S7EMUx/oWQj1g3l6BwNc0fVeL+yb1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 014/482] net: dpaa: fix device leak when querying time stamp info
Date: Tue, 26 Aug 2025 13:04:27 +0200
Message-ID: <20250826110931.138822419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 3fa840230f534385b34a4f39c8dd313fbe723f05 upstream.

Make sure to drop the reference to the ptp device taken by
of_find_device_by_node() when querying the time stamping capabilities.

Note that holding a reference to the ptp device does not prevent its
driver data from going away.

Fixes: 17ae0b0ee9db ("dpaa_eth: add the get_ts_info interface for ethtool")
Cc: stable@vger.kernel.org	# 4.19
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-2-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -473,8 +473,10 @@ static int dpaa_get_ts_info(struct net_d
 		of_node_put(ptp_node);
 	}
 
-	if (ptp_dev)
+	if (ptp_dev) {
 		ptp = platform_get_drvdata(ptp_dev);
+		put_device(&ptp_dev->dev);
+	}
 
 	if (ptp)
 		info->phc_index = ptp->phc_index;


