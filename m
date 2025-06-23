Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5438DE1;
	Mon, 23 Jun 2025 21:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713524; cv=none; b=jyCXULJebaU5fqtRKKgYOPE2i1SfC3DnVwc3tycAAPEbR2uKImf5z0f34+zitxTAmPkFRZJp+ICoKQKt5DASa70DVEbzG1LQfrZQSF8fHksCZ/GQ8yK7tlH5zHlc4TeaFPQcuYiqT/ygixHEx5/h/73wPOpV0G4g5KPjg3XZVx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713524; c=relaxed/simple;
	bh=koWihjQZQlBo6N8rLmo8kwTXT/ja0D36TXWTdfreDL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp6aEnFqanHGiOKkY7L92GUuqNwJL2m1YrfCjzWj+qK8unTAkLje7Q7gyYvgu9849aBL9jiJp6QUg1ScAJEJP4JHvQAhToRJvcuum3Cr94WAmDB6/lUJbuyEmWUZbcysevSL/Xb+l9Ow4QL5CaSQ33fhKpq2aV81zVBrq8dt8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZhbiGgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZhbiGgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8219BC4CEEA;
	Mon, 23 Jun 2025 21:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713523;
	bh=koWihjQZQlBo6N8rLmo8kwTXT/ja0D36TXWTdfreDL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZhbiGgtV4coS6Y6kAje0zx3beslpmS129Qm/hRiaI3ko+Z6WOfBzBLG1Bd8qWV4g
	 5oMr/hxIyNL5/3uRQ4h4mL4Osz4hqqJpGcr2HIrqGdxr+MeBzwHmAkXz4okjHikWoW
	 k6Xg2DbaWBWJIsZ+fr6Ex8EHJg2gStoElOzvq+Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 068/414] media: imx-jpeg: Cleanup after an allocation error
Date: Mon, 23 Jun 2025 15:03:25 +0200
Message-ID: <20250623130643.771743868@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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


