Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00387264A76;
	Tue, 26 Aug 2025 13:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215017; cv=none; b=kO2Y0QOrABYDje+Y4+XZWDyDJHGfDKoVgPFshQVOIXtbeXXQyxIQ8+qNxBL2PIP9IlL9eHRx1fXhoXWHM+oGHmeesVRtM4YWV0IVd5LbK8iil6A6EFR5mQbouvpELOeFDrbmnWYuMZ7ifIWewZSdsuK4jAfS5PlLnWrHwaewEyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215017; c=relaxed/simple;
	bh=+juATEhE2R0Sc8Poq0IQvGxrujwYSJbgUHyHXPSo6/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeIsPxI/4Hf8jlFHUU1twqfojTxzK0XzmLmeF5Qe0eVNLC7k484QrNFwdxXikS7SLCk8Ykp/fg47qF5pxaLggRtGSdcLb2dW/l0+uXDduma3j6zprIiUhgQgfcpKsosH9MvM5giIdM47BpmeTOwY6IiauDzPXs4ZTSL7yB6aHb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7CetV54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7CetV54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891A9C4CEF1;
	Tue, 26 Aug 2025 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215016;
	bh=+juATEhE2R0Sc8Poq0IQvGxrujwYSJbgUHyHXPSo6/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7CetV54EqE216yqMcRzzzYD1T3y/CbZolrptYHFqvaelUZR9L4L2B3WM2QCUlsbm
	 jna7DPOzAvqDUpfcn5nzc4H7ybqEwWbaK1wedB8COi/G9Z/Oh1vJ87QUsL1HDmWrrC
	 5IvOdlQwL6gmpT0mqMkwkDF727KZhImU8wdFHqxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludwig Disterhof <ludwig@disterhof.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 324/482] media: usbtv: Lock resolution while streaming
Date: Tue, 26 Aug 2025 13:09:37 +0200
Message-ID: <20250826110938.815027577@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Ludwig Disterhof <ludwig@disterhof.eu>

commit 7e40e0bb778907b2441bff68d73c3eb6b6cd319f upstream.

When an program is streaming (ffplay) and another program (qv4l2)
changes the TV standard from NTSC to PAL, the kernel crashes due to trying
to copy to unmapped memory.

Changing from NTSC to PAL increases the resolution in the usbtv struct,
but the video plane buffer isn't adjusted, so it overflows.

Fixes: 0e0fe3958fdd13d ("[media] usbtv: Add support for PAL video source")
Cc: stable@vger.kernel.org
Signed-off-by: Ludwig Disterhof <ludwig@disterhof.eu>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: call vb2_is_busy instead of vb2_is_streaming]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/usbtv/usbtv-video.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -73,6 +73,10 @@ static int usbtv_configure_for_norm(stru
 	}
 
 	if (params) {
+		if (vb2_is_busy(&usbtv->vb2q) &&
+		    (usbtv->width != params->cap_width ||
+		     usbtv->height != params->cap_height))
+			return -EBUSY;
 		usbtv->width = params->cap_width;
 		usbtv->height = params->cap_height;
 		usbtv->n_chunks = usbtv->width * usbtv->height


