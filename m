Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B16147A0C0;
	Sat, 12 Sep 2026 11:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213910; cv=none; b=akBhawzBU2qDfIJ8D4mGqkQ0FRJ4ZDq+ACcNbn/I03LsgOEoJRp8fdTcvkldtwp1vhZWTEaXDzVr9hY9doj6DjAmVd8VLl5+s53pvPHhfcPh0ue6IOmk+RFG78ibngJV1pR20OmB+F4J9vSZr7m1JM1jcEp7Fdd+4kjpctQUeX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213910; c=relaxed/simple;
	bh=pKEgB5Nu6QBtBxHT89xXj7qldCZQvpnSNSC6zl8pHGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGm30+WrtvPIxytXVzqirggWX9uo+6u4WswLwgsFVqIuk29zq+sJGNbaBuU9UJ9AJXiLakl6HAx/hQNBXllB3fWadhe6/NIVumPxp0tI0bHjVbQscbcJIQ58TSYC9Y6F/5t6JOvtlZGb41OmmJlCG40s1asRod2kEobqxFECvGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pldj+X00; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pldj+X00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2561F000FF;
	Sat, 12 Sep 2026 11:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213909;
	bh=PMkAek3e+BgBbvdorhD01fDXcGS8K6fGLfqWfN0og4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pldj+X00NFNFGvkfS4h6c7C7vSDC1ND8vCYmLfsz1185w/wBmOO09PEuimRlFnaAj
	 ot2tKCyBdePH5cWmhyKz525tAAUCSBo659ZyGU/6kqid6A3hMqi/sQLgTdDfxdmM62
	 noBbjok9GLNwSXDopcHXiMLV0SOWiz22HnyeQfvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0217/1376] media: vimc: fix pixel format lookup in enum_framesizes
Date: Sat, 12 Sep 2026 08:44:03 +0200
Message-ID: <20260912065612.385123432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


