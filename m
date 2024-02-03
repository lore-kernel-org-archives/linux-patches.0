Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C6E1CD19;
	Sat,  3 Feb 2024 04:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933531; cv=none; b=FUeNpYbJAubR7XSBx+VPfHADYdItUSQddE+5a4tjFC4A4dOs7+SwPxYsWEXQLNrlwTfwjY+DKF7D6LXr4hX0fPmOysUAyJJGgj9mKoQ43jw6jWJrTJD8uUbykcw38tKeCRwsk7Vo+8234qvwWze49H1494HEmwtj/pU2tOq/iM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933531; c=relaxed/simple;
	bh=1/1ydPRyKsJtVcko9y/6H13iK/oUJYyEQLxQlqrQeUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7XYDk18xCCPrkGjnnsg+bAUep1/JDZsSIdb4lyAFuuGL8AndGH+ZJDE311zVlZrmLkafB7m+o378CDy3L6gwx4pjorF2Ym6VWYfA/sN9pdjwAvJpvhIfhlGPPdfYr7hzx48OIxNrh+h1DhP4ySygaDt5GB1dcONR2K9JTIXk8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bZR2qEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bZR2qEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F66DC433C7;
	Sat,  3 Feb 2024 04:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933531;
	bh=1/1ydPRyKsJtVcko9y/6H13iK/oUJYyEQLxQlqrQeUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bZR2qEVVSpx1et6795zXO5O6fPIsaSvpIWy+U9OpLim4eQ8Wq/gLgqJi8pPFYGRx
	 w4Df0k/qcGPnEbheFpnXnrPRcCIXIxs4e3ASvg/V3Yj06NcQ2VG25D9bW3PnhtnBsj
	 wthdupDnj9rmA6bBNMei78xGIeiZfDeVr9zy+RgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/322] net: phy: micrel: fix ts_info value in case of no phc
Date: Fri,  2 Feb 2024 20:02:52 -0800
Message-ID: <20240203035401.595159525@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 915d25a9d69be969c1cc6c1dd0c3861f6da7b55e ]

In case of no phc we should not return SOFTWARE TIMESTAMPING flags as we do
not know whether the netdev supports of timestamping.
Remove it from the lan8841_ts_info and simply return 0.

Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 27ca25bbd141..f81c4bcd85a2 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3628,12 +3628,8 @@ static int lan8841_ts_info(struct mii_timestamper *mii_ts,
 
 	info->phc_index = ptp_priv->ptp_clock ?
 				ptp_clock_index(ptp_priv->ptp_clock) : -1;
-	if (info->phc_index == -1) {
-		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
-					 SOF_TIMESTAMPING_RX_SOFTWARE |
-					 SOF_TIMESTAMPING_SOFTWARE;
+	if (info->phc_index == -1)
 		return 0;
-	}
 
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
-- 
2.43.0



