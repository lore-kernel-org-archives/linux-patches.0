Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A3724DD0A;
	Mon, 23 Jun 2025 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684487; cv=none; b=vFGZ3xuji0ZCyk747LLp77uPV1F0zt7ejr+vwV9YChUpnCJyBZEDBgJJvl01MwBGF7yO40/nBOV9S3/SbFxqMl5zcWTN7bZ15+Sp/fS+cJZK0MB9/0Ge9TehWY/2PaHzCyN4cHhl4OBuigGmBOwOA8bajvsC21COv3FjVQavhw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684487; c=relaxed/simple;
	bh=sGLkbGrLnkMpP0IlDuPqfw58rx+nCwAKNA/eqbcmFLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D88Pen8ud/Mi68kUSZdutkLR0Z1yl1oqKo++u3YGqh4WotRsfnfe8HOSiQBbQNvpu9LNIZEktR0JUO/qsmzOSajsF41IxuKzS+YYoq1i0IXX5HxR8wOXfilg0EkLc3WLlXV1c5PqHK+Ve3Pt3Ee4P1HJd9FC5EVsUXKQoL5F4KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qonu6p8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qonu6p8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76817C4CEEA;
	Mon, 23 Jun 2025 13:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684486;
	bh=sGLkbGrLnkMpP0IlDuPqfw58rx+nCwAKNA/eqbcmFLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qonu6p8w+QsHrsS+DZ3mQR5SAtRfvV9aVjpyN3AMA/PjOCPDoyIuTXzWlSK74Verc
	 DSelf5MVlXki1m2LUsWgkT1t56p/+NLIe5ZXe6AaKMkVpIFG29tb/8YOQO6lq9gkiX
	 JabLFKdxlx/xXb7fjMsv+CaX+kRCtT+MGFgt7pkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 088/592] media: imx-jpeg: Cleanup after an allocation error
Date: Mon, 23 Jun 2025 15:00:46 +0200
Message-ID: <20250623130702.371183073@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit 7500bb9cf164edbb2c8117d57620227b1a4a8369 upstream.

When allocation failures are not cleaned up by the driver, further
allocation errors will be false-positives, which will cause buffers to
remain uninitialized and cause NULL pointer dereferences.
Ensure proper cleanup of failed allocations to prevent these issues.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -820,6 +820,7 @@ skip_alloc:
 	return true;
 err:
 	dev_err(jpeg->dev, "Could not allocate descriptors for slot %d", jpeg->slot_data.slot);
+	mxc_jpeg_free_slot_data(jpeg);
 
 	return false;
 }


