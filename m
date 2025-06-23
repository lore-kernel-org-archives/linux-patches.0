Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D48124EAB1;
	Mon, 23 Jun 2025 13:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686180; cv=none; b=bXBtGdoCu6+iyCc7oRnmE3AcXCZuNpa2vy/axfYRSufqNih3695RA+UChwLMg+ZROCj2Cul/wITLD6wMzJL19BmSB+UYHF7slfq5h7G0SQMoh3a7hipNtcRXAa5MvpCXRro3pvEQcfDnzrVct0HuT0uulYOH9BhnVFu6UMa5fzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686180; c=relaxed/simple;
	bh=PZLmE3Xh3qoEneVNeSGrB3iNtEFVfruqYE03lvAnprs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwPqWSVRP4UIzZ/Y1+nLlutb08TwA44OLhDmqcLt5bLUObu1nQtEAlRMXLWYAlKXb5uDFoIg08AAE0Rm+t3JukSl2VHW6mY3YyS8VdIyjldl6qtKtZ4MlKcH87LCINm443c2uITfpsudRs1+TnSe30AkNjDw3qhvkW/lJrePn9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/Ee3Tdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/Ee3Tdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF6AC4CEF0;
	Mon, 23 Jun 2025 13:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686180;
	bh=PZLmE3Xh3qoEneVNeSGrB3iNtEFVfruqYE03lvAnprs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/Ee3Tdp065EmTCdOigAh7HsyS7JjiDZkfjRLoHIpb3sseXyj+iUTtymZW7QfNNHy
	 bH7ucVQGGfSn2q4/k0/npsHnBqUJeUUomVpqTZjKWt9qwGO6lOEwt/Qyu0JWbZpGmf
	 7JYK7ZGLXcVY7pkQ+m5Ky0eSW3ODkMPD6pcWvnM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 045/290] media: imx-jpeg: Cleanup after an allocation error
Date: Mon, 23 Jun 2025 15:05:06 +0200
Message-ID: <20250623130628.364480943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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


