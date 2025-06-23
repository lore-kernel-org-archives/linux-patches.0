Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21DA1EDA14;
	Mon, 23 Jun 2025 13:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685065; cv=none; b=S7Nb9kij5twYuBySm2Mz4VNoWP4Ugmpzf3RC83TvNftwd+XRT/cLQFxbe7Y7nTwNq8VieUSZ4ZpWFsxbuqTipeGNmOA+FguFnVKAz1Gthk460XlHpapCxHN7WDkZHLCk6vHT+KeMAeQqsMbiy4RzwTy0ZAOkMfwTj6oCTslln2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685065; c=relaxed/simple;
	bh=/5spZJhPTrfYjp+MJyH2r8h+BusUY/iYn82acOjwVtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6x1tEY5Dnx8W5TaOFW+BYIjKgLW4BDPNiGodAkO18wcf/keJE5ip2FM8vPlkrCmQJbxRL0MC68ewK1RgE21AhBQrzSvv76410+1SITIqL5MbJ1MNqKOBm3LpUJw7jNTaqHLM7zLKWsIDGFq2fKf79WqdtlgCWqVIOq61WypCi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5bw+fMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5bw+fMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EB0C4CEEA;
	Mon, 23 Jun 2025 13:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685064;
	bh=/5spZJhPTrfYjp+MJyH2r8h+BusUY/iYn82acOjwVtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5bw+fMi4PXVO6a/7VLPqRxOJDlnDrXyOaldhQscILGYKQl28dPHzwQsHxCTP3Bu8
	 Mw915w91p3MIM+hVxjxJ/08rzwcXfBFcSFLHWUvsRh0wWQVI8chgkE2UaInCpHCjeb
	 gsPMQdAGbHq7SplJFZZgIquRiRur1tNU2tzEa7PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/355] media: rkvdec: Fix frame size enumeration
Date: Mon, 23 Jun 2025 15:03:47 +0200
Message-ID: <20250623130627.595057395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit f270005b99fa19fee9a6b4006e8dee37c10f1944 ]

The VIDIOC_ENUM_FRAMESIZES ioctl should return all frame sizes (i.e.
width and height in pixels) that the device supports for the given pixel
format.

It doesn't make a lot of sense to return the frame-sizes in a stepwise
manner, which is used to enforce hardware alignments requirements for
CAPTURE buffers, for coded formats.

Instead, applications should receive an indication, about the maximum
supported frame size for that hardware decoder, via a continuous
frame-size enumeration.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Suggested-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index 86483f1c070b9..a5eca08ff2597 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -178,8 +178,14 @@ static int rkvdec_enum_framesizes(struct file *file, void *priv,
 	if (!fmt)
 		return -EINVAL;
 
-	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
-	fsize->stepwise = fmt->frmsize;
+	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
+	fsize->stepwise.min_width = 1;
+	fsize->stepwise.max_width = fmt->frmsize.max_width;
+	fsize->stepwise.step_width = 1;
+	fsize->stepwise.min_height = 1;
+	fsize->stepwise.max_height = fmt->frmsize.max_height;
+	fsize->stepwise.step_height = 1;
+
 	return 0;
 }
 
-- 
2.39.5



