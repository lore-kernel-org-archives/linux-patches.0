Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C067024BBFD;
	Thu, 17 Apr 2025 18:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915708; cv=none; b=avO+SLC9lBHgw8IZ5zQbx/9Mssaeta9GKil63FVhUnsBf9qK3YrfG2PwXkhGa57rVICCabMKabmjEBm2Ee/VJQaqO+DQzntVOstcDblDbi/iHh7tX7KBy/HDtoPP0juwAwJTkFzbkX1jyZN4SpqihNI6ft1rZr6z1EFOypV77Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915708; c=relaxed/simple;
	bh=oC1w8Jv94xhb7KQOsw9Ah998e+tockJpYr3HUmLYbW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqb10xP9Li+A9kQUaHV128ggd2py3iJ21ME94hWd/I6ltT85GL+A8SNVQDegLA11NeemBiz1Jp+6LR68WwFNqpYUwrQIk4dvJ8vvbadJYg0YgOjAOa9xnKOd/fXbs53JEftt2AVkEQRG09erJw0HBJZLQ++3rWtiWbrykJYlWRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJspsS+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJspsS+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E83CC4CEE4;
	Thu, 17 Apr 2025 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915708;
	bh=oC1w8Jv94xhb7KQOsw9Ah998e+tockJpYr3HUmLYbW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJspsS+VxuB8uLJpBy46rx1J00DCF7tWw5sCHIv2WN7RRZW+EcWR/oKsZeAfgiD3s
	 T5xMzKvHItsYb/LOCmELn1Gev5zIvOPWIK4lyTdU1/8l9Qoa5gJ42mLq2CwoO5maVb
	 vxufQ0ty0vTRCIjli61WqbLJcANXTqoS0NZbiaNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 214/393] media: platform: stm32: Add check for clk_enable()
Date: Thu, 17 Apr 2025 19:50:23 +0200
Message-ID: <20250417175116.186417769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -492,7 +492,8 @@ static void device_run(void *prv)
 	dst->sequence = frm_cap->sequence++;
 	v4l2_m2m_buf_copy_metadata(src, dst, true);
 
-	clk_enable(dev->gate);
+	if (clk_enable(dev->gate))
+		goto end;
 
 	dma2d_config_fg(dev, frm_out,
 			vb2_dma_contig_plane_dma_addr(&src->vb2_buf, 0));


