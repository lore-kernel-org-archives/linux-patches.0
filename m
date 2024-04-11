Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B941474D0;
	Thu, 11 Apr 2024 10:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832070; cv=none; b=AQPYMETHwernY+rIg4ob92e6nA/+0ESzQc1LhwLGwFYOoboPpk6VZsHpPmRQC/coYCcm/E1fcuxT7vDb5tGIiXG29XYGMI8PhE3+N7myno+N15YTw3V2/jiHXZdxRuOw9xgD6y1AikT1u/w8O6EUzWRxK1jypdJ3VS91Mh8v0y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832070; c=relaxed/simple;
	bh=Sm13lrb5Nd5WArFXfacSQDNrK0v8m36iLCyw8uTEAhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyuND9J1RvsmAqifgM52O5hRavxOyVynTzDCg6SFgXgW4UCkh/mAE+boWVtmqCnE6LlK8M2RZFH+mm7hhGS0to90CarUHFX+nY7qt/0snqXD8jZNUhsiya4I6iWB3iclv+azz+mBrVNPj4auJp+PZXenibiXsZnAWWJYJ+4Q2/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhSfXExc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhSfXExc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF031C433F1;
	Thu, 11 Apr 2024 10:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832070;
	bh=Sm13lrb5Nd5WArFXfacSQDNrK0v8m36iLCyw8uTEAhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhSfXExcgmTB/wo2oeuZKUnMfi1vwrvS38ZzNACBRPsvo5Kka/BlmD+eyp1/guvZv
	 MiaXVwlg+d874A6TvqCtRsnRr3/x3JfmB15Szv1tGt9TNIxS3TURrerZ6mmVEwl9zk
	 KcJZfd44jyt5ZEWnrHJ/KNyguDozk0X8IfEn26fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 218/294] octeontx2-pf: check negative error code in otx2_open()
Date: Thu, 11 Apr 2024 11:56:21 +0200
Message-ID: <20240411095442.157060456@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

commit e709acbd84fb6ef32736331b0147f027a3ef4c20 upstream.

otx2_rxtx_enable() return negative error code such as -EIO,
check -EIO rather than EIO to fix this problem.

Fixes: c926252205c4 ("octeontx2-pf: Disable packet I/O for graceful exit")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://lore.kernel.org/r/20240328020620.4054692-1-suhui@nfschina.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1598,7 +1598,7 @@ int otx2_open(struct net_device *netdev)
 	 * mcam entries are enabled to receive the packets. Hence disable the
 	 * packet I/O.
 	 */
-	if (err == EIO)
+	if (err == -EIO)
 		goto err_disable_rxtx;
 	else if (err)
 		goto err_tx_stop_queues;


