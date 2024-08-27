Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690941BDA93;
	Tue, 27 Aug 2024 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772547; cv=none; b=kf6A81SElcxnvk6952C14sLtgko10xUzXIcGNUhX9GrgJD5MCwg+wXOpvnQydAMR34obZGXqQOc0OoNKBxAGSNHaUnnZYR+zlKuQbs/PCke56OwdkSer2YacNfIJHHS1rPJTEjC957sTFklfQoVtS/1U9aIFzZ5T8EPPokfsbSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772547; c=relaxed/simple;
	bh=gaCZIbqAE1S2By3yLRxYM/KgIZTSaq0jcqOZa7evgqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzioU3zBzmTaZVlDFXL+BQixNrgczhplDfLtv7IXlfDzmwGjTLKrsNFNUHEpFq73vuh4ZoqJMj1qUUBOD9RPu38Cuz4DA4Y6UAwAlaCYZ5wsG2pZP/fdRt3opuoE9PbpX7gPJPt7k+zA+22mVLu0raMxmffqce6fIbS5qx6dEqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHBlE2MA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHBlE2MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C917FC6107E;
	Tue, 27 Aug 2024 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772547;
	bh=gaCZIbqAE1S2By3yLRxYM/KgIZTSaq0jcqOZa7evgqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHBlE2MAie7p8cbno9ujAUFa0br+Kgv1RwbwMvTkhDHyeurDrXmRzeNdrmrQqWbJ4
	 tQ6CMgEyYg+FZCBgCzq7HOU1eoXzAQr8Jgj811e6UPCBI+qrqpTpAlETFrt+cmtHTq
	 dCncSP+ANGfQuf6+vsEYaaDUYxm8XsQ3Hk15SYx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/321] dpaa2-switch: Fix error checking in dpaa2_switch_seed_bp()
Date: Tue, 27 Aug 2024 16:39:16 +0200
Message-ID: <20240827143847.685752301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit c50e7475961c36ec4d21d60af055b32f9436b431 ]

The dpaa2_switch_add_bufs() function returns the number of bufs that it
was able to add.  It returns BUFS_PER_CMD (7) for complete success or a
smaller number if there are not enough pages available.  However, the
error checking is looking at the total number of bufs instead of the
number which were added on this iteration.  Thus the error checking
only works correctly for the first iteration through the loop and
subsequent iterations are always counted as a success.

Fix this by checking only the bufs added in the current iteration.

Fixes: 0b1b71370458 ("staging: dpaa2-switch: handle Rx path on control interface")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/eec27f30-b43f-42b6-b8ee-04a6f83423b6@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index b98ef4ba172f6..d6c871f227947 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2583,13 +2583,14 @@ static int dpaa2_switch_refill_bp(struct ethsw_core *ethsw)
 
 static int dpaa2_switch_seed_bp(struct ethsw_core *ethsw)
 {
-	int *count, i;
+	int *count, ret, i;
 
 	for (i = 0; i < DPAA2_ETHSW_NUM_BUFS; i += BUFS_PER_CMD) {
+		ret = dpaa2_switch_add_bufs(ethsw, ethsw->bpid);
 		count = &ethsw->buf_count;
-		*count += dpaa2_switch_add_bufs(ethsw, ethsw->bpid);
+		*count += ret;
 
-		if (unlikely(*count < BUFS_PER_CMD))
+		if (unlikely(ret < BUFS_PER_CMD))
 			return -ENOMEM;
 	}
 
-- 
2.43.0



