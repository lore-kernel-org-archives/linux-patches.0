Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB1533A71A;
	Sat, 12 Sep 2026 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228437; cv=none; b=nCsSiBRRAp1o2s8agBMfkJQpgjV1dUOc8Blmqp61rxAqi4RRxjq/QGqhXJ7NYsI39E0dxntdxtAuB30GFLUiB6uVHSwU43/xRmNkl2MJGscWZ1+zgODXAAM7j+Ywfc2xkzcKVsbq6NuAX3nfbdRa8dj2/aaAvvQwJIqlJAcaVmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228437; c=relaxed/simple;
	bh=tGS+6UMSoHUPHtMvumNJQCRAYx52Zsxb9r5JInnRDdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ownTZXSu9u8bl6cmvo+fIah3m0MhBzng8VD6stkeVV7gqN1Q58rAGXYexQMa65z+ibiwacx56NmxN+YhqyLI1kRYHuon+Kp0bEf+aLm0VdajcHNALpB9mX67V/QzR+4Y8F5GGZ2WCRtTWN52xJq0MGAW69A6QtmM/u/7Z4iXoGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRI9iD6N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRI9iD6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613B61F000FF;
	Sat, 12 Sep 2026 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228436;
	bh=WFQ6CmpubVnlaezhjaoay8kfTAEssfrqeWS6NkdIQsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRI9iD6NOVqL2vu87qvb9Kv8yWlrs2P1lAu8KCX9GstDg4jMqrsoz74Z8g8HmY2ON
	 iJSgvNzcmOAMhlhwNatEa05Y+lfTG4Dim1xuotwtszgOtv5xT+aoDZiu95niYLHyig
	 cYhiQGksT7HY+/NaCCylEXOm+q9Y9W81vajenuBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0386/1191] media: vimc: fix pixel format lookup in enum_framesizes
Date: Sat, 12 Sep 2026 08:51:54 +0200
Message-ID: <20260912065556.909818632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Arash Golgol <arash.golgol@gmail.com>

commit ad4c65fa30cfb00e2e06adae9a8eb407086eaa66 upstream.

vimc_capture_enum_framesizes() looks up the requested format using
vimc_pix_map_by_code(), which searches the pix map table by media
bus code (MEDIA_BUS_FMT_*).

However, v4l2_frmsizeenum::pixel_format holds a V4L2 pixel format
(V4L2_PIX_FMT_*), not a media bus code, so valid pixel formats end
up being rejected with -EINVAL.

Fix this by using vimc_pix_map_by_pixelformat() instead, which
performs the lookup by pixel format as the ioctl expects.

Fixes: 09c41a23a2e2 ("media: Revert "media: vimc: propagate pixel format in the stream"")
Cc: stable@vger.kernel.org
Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/test-drivers/vimc/vimc-capture.c
+++ b/drivers/media/test-drivers/vimc/vimc-capture.c
@@ -177,8 +177,8 @@ static int vimc_capture_enum_framesizes(
 	if (fsize->index)
 		return -EINVAL;
 
-	/* Only accept code in the pix map table */
-	vpix = vimc_pix_map_by_code(fsize->pixel_format);
+	/* Only accept pixel_format in the pix map table */
+	vpix = vimc_pix_map_by_pixelformat(fsize->pixel_format);
 	if (!vpix)
 		return -EINVAL;
 


