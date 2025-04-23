Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898CD28935F;
	Wed, 23 Apr 2025 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420926; cv=none; b=qO7dXv83OnJT1tE570q9zZWn75pXrjVkVlgRdrS9iWpZtFA4Mb+c3NqW8xI4Z/BLnDVLGMnAM0R0Fhz9NyciJdArWaDrguA8Jy50WLF899GthbvnMkzX2OI66nPoqF+FBMrfALAmQNN1Na9CrcyKqCGtEFglEP3aIv7ug2HATC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420926; c=relaxed/simple;
	bh=KdRxXK0DzrrIOtnxtd9iMr7an9xlNLmQDdOZtlHOmZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6xEPP8ivYqLS+ny6Y6X5Aa6LQQfNc/FoUnYha+L1j0Gs4H1yU1mWNKrDF1YMRpeyCvknGpuPJaeDtuUgxLlG550TawiHx69Xyii7S9jtpc7w+yEYbbPUKvO4/vdr+jk/8Jjomy3VELz2ugdzZKPnbKAkLQC+JL2tOorIZNIz/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EW5Gj1mD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EW5Gj1mD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D931C4CEE2;
	Wed, 23 Apr 2025 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420926;
	bh=KdRxXK0DzrrIOtnxtd9iMr7an9xlNLmQDdOZtlHOmZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EW5Gj1mDI3LBbC5LWVj3ShlzRnw2KwFWd33kEH+1nHqqmkMszyGrLKcP3hkFpozRM
	 pVSqprcppGdmSzvaZ5HI+6EWnBqFWs/l4omdDj4VZi6mJimZBbkgjJ9EmHAtoaw2A7
	 Gt+oliOqAwAB4KSQp2H7WcJfOq+yrJH/qSFSGZQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 093/291] media: platform: stm32: Add check for clk_enable()
Date: Wed, 23 Apr 2025 16:41:22 +0200
Message-ID: <20250423142628.156048296@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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


