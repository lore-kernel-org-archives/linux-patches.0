Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCFA13B79B;
	Tue, 27 Feb 2024 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042815; cv=none; b=lXe8wsIJPa9toucLp/uOvftgrSoIK8fmgv2gj0wlzt+Wxro1Wo+y/dmu8DR8e0qVvu392oNnRPGvUWMKJg3iiUStCQA0TzYQDhV3R+vi8okFEF2nwzVABtZ+hxp6uW4ViIWgoHWUIKfFihcm7oYC3gbjDYutHQLQ2PnOSbYDutw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042815; c=relaxed/simple;
	bh=ykv4ttsmdjSn2jQECC8ZyeJ7znlGaCFxzziHsUPPCVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjZvpGrVntVAfdcqRmB/yQv1bIELKAX74PjnPhT0B623hSbQVF9+xp364J2LXNEVxtjPRysxX2mutg680TaipNSYzgPbrMtkVLpqeVG5A5QztaR5TVb1cOlxZTMPBsuW4QwAWIR3QdL2RTJrc0reuY1GZ/3ej/nBK1zmNxxcWFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHiq0XFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHiq0XFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE2AC433F1;
	Tue, 27 Feb 2024 14:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042814;
	bh=ykv4ttsmdjSn2jQECC8ZyeJ7znlGaCFxzziHsUPPCVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHiq0XFQYXWOcpdLrtzwws6FgiwK6XBFWOycZ2y9eVtsReP1pTZ7PHtGkJRAYOWbs
	 eiPgkKg50LwbqW8byx2sPxE/OK2pcWUupWSswrzdbFxY+y2BxyIanLHH90eGeLAV4i
	 bD66tuZq6+METsK0ApSBwH29NsEky/RheNpE68/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/245] RDMA/siw: Balance the reference of cep->kref in the error path
Date: Tue, 27 Feb 2024 14:25:19 +0100
Message-ID: <20240227131619.470957045@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit b056327bee09e6b86683d3f709a438ccd6031d72 ]

The siw_connect can go to err in below after cep is allocated successfully:

1. If siw_cm_alloc_work returns failure. In this case socket is not
assoicated with cep so siw_cep_put can't be called by siw_socket_disassoc.
We need to call siw_cep_put twice since cep->kref is increased once after
it was initialized.

2. If siw_cm_queue_work can't find a work, which means siw_cep_get is not
called in siw_cm_queue_work, so cep->kref is increased twice by siw_cep_get
and when associate socket with cep after it was initialized. So we need to
call siw_cep_put three times (one in siw_socket_disassoc).

3. siw_send_mpareqrep returns error, this scenario is similar as 2.

So we need to remove one siw_cep_put in the error path.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20230821133255.31111-2-guoqing.jiang@linux.dev
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index ecd19a7408679..116f1c38384b6 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1504,7 +1504,6 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 
 		cep->cm_id = NULL;
 		id->rem_ref(id);
-		siw_cep_put(cep);
 
 		qp->cep = NULL;
 		siw_cep_put(cep);
-- 
2.43.0



