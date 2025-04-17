Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916E425C708;
	Thu, 17 Apr 2025 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914465; cv=none; b=flCnWbaVFxDZ2DVtDO1pjNNO/G8x6xDfDXIHHIIcnGU2xzBDxKBOuUnQgEUUIhUm3UUJLbb9qRqY5fT2FOvtRg+zqxHNAE/WT7C98KJxS90pv7gUtgi+GzRUp1o/B9STXH54oTiQSdHFK+i4Ar80vK+fZyBXcTs8RGMzBNhaQKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914465; c=relaxed/simple;
	bh=no+LbkrpJGncA+y1A4iU+Xa1SpwR7mMh2P70NOONULI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXwDQG2z54eXZPRBiYNqOg6KywOXayAHH51b5N5ILjRmYZJbCEJ/uiW4RDrkGhNhhGhVX3ANhaC+hYpYJVpT5JO9Jk3D15qnokVCtLlQuRz+yzL8WVeSjYUeSE7Tvi8zy2VV5Qx8Zv1Qg91CEqdmucMWft/i6VWDCaBtsSJiGs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmeXoz0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmeXoz0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C52C4CEE4;
	Thu, 17 Apr 2025 18:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914465;
	bh=no+LbkrpJGncA+y1A4iU+Xa1SpwR7mMh2P70NOONULI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmeXoz0C31KwNUhu5jmYz8o1utLwHMgYTtSv5mzoCk1M6GH6Nj1RnO7EpghdnNMNR
	 bYaHibBrI4NrT2v/BIt20Qgy50wia2PlMpftMsDA2h+dFrmSiqvLbw1RnlVsyoI+ba
	 vH3jbmg4cXpJ+25xHtfIeOgNaZUboHiNt2yS4gcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 225/414] media: platform: stm32: Add check for clk_enable()
Date: Thu, 17 Apr 2025 19:49:43 +0200
Message-ID: <20250417175120.484226843@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit f883f34b6a46b1a09d44d7f94c3cd72fe0e8f93b upstream.

Add check for the return value of clk_enable() to gurantee the success.

Fixes: 002e8f0d5927 ("media: stm32-dma2d: STM32 DMA2D driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/st/stm32/dma2d/dma2d.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/st/stm32/dma2d/dma2d.c
+++ b/drivers/media/platform/st/stm32/dma2d/dma2d.c
@@ -490,7 +490,8 @@ static void device_run(void *prv)
 	dst->sequence = frm_cap->sequence++;
 	v4l2_m2m_buf_copy_metadata(src, dst, true);
 
-	clk_enable(dev->gate);
+	if (clk_enable(dev->gate))
+		goto end;
 
 	dma2d_config_fg(dev, frm_out,
 			vb2_dma_contig_plane_dma_addr(&src->vb2_buf, 0));


