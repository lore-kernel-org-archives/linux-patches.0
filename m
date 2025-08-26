Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE2F450FE;
	Tue, 26 Aug 2025 12:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212567; cv=none; b=gbsh1q0vfu+MRvKZQyhIrkQptEDeDa38cJlnFqejiN4VlYrvESKinYsuQSrSGibB8+t5xkL2+a2F0b3chMlgFQDOWM8vXygqBIAFMYEQ281qL6qAOy5nnIBPsE9dCVoajUn/ZJfZRJMn23rzd8dUNeIH3CGA6rYO/dI29Aulwgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212567; c=relaxed/simple;
	bh=sMjfXijs5OxdwE7AMIzgTN9KQqO6fWQmFFsw/XwxzC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpSu2jKWJM/lCNvWXufxg/bX9C0nMZii3Hr95wLbwMQkMVwXEGZ4zcUyUlZeYsNnra64c4WYwseaZ/+fsmMspLnxUw6bnm0IVKBQWfzq2buMGKqS850zrLq0zDYk/V5QAYn2kMcK3Y3uVk+0C8omEDpZmsMX21pfBZHFSktanIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtK3z4uB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtK3z4uB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C02C4CEF1;
	Tue, 26 Aug 2025 12:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212567;
	bh=sMjfXijs5OxdwE7AMIzgTN9KQqO6fWQmFFsw/XwxzC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtK3z4uBBMNvFvNZyVaNYGszDZfCiOncVhKFe7kTgKj/GpwiRJPAg0jB8L6yKPhiS
	 YfTdAKGMPLbqd+4DFiMCc+Z004CgCJ9JR4IsuAaUt7BMVrCMsRgF5IJEvU4gajcl3R
	 1XfJn6qF74VQh6YuTE7y+/SSsuZq6uwjtSNSwb44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 019/587] net: dpaa: fix device leak when querying time stamp info
Date: Tue, 26 Aug 2025 13:02:48 +0200
Message-ID: <20250826110953.444236466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -415,8 +415,10 @@ static int dpaa_get_ts_info(struct net_d
 		of_node_put(ptp_node);
 	}
 
-	if (ptp_dev)
+	if (ptp_dev) {
 		ptp = platform_get_drvdata(ptp_dev);
+		put_device(&ptp_dev->dev);
+	}
 
 	if (ptp)
 		info->phc_index = ptp->phc_index;


