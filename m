Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1072F2372;
	Tue, 17 Jun 2025 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175539; cv=none; b=CE1BL9bZpLJrNvbwd9+OJ/A9Ek64Ce+fhHpDHjC5fxOSeQiqrxb+SbkfZ65d50WjNzZT4lF9rZvalGJVMRByPVWBj32wnVUgEOogNyJSjdVUTBFQBZujb9ivEme0xnsAmcU5CG2Mr7mQypgoz18G/g4SYQoe00uI9qT3oDO+TRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175539; c=relaxed/simple;
	bh=ss4OElmHaCXcPr4u4n63j0aNkMyswp6zBDGtdREwZOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/jl+sHxl0pTle/U/dMRXGGRL7dRqGyvpU/wWFwEpSmplbRrHSlgy86sDRdK+I+MSejJBRJFHbh75HwEzQTGpvOq1qeyCLDB7TuGkka6AP7gabbvoCHhcCIyqNE2QwYJmmuMZ1ZF5j71gOho+zTXYEXa30IR9JSme0wdJqgW7N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Six8EYS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Six8EYS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F62C4CEE3;
	Tue, 17 Jun 2025 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175539;
	bh=ss4OElmHaCXcPr4u4n63j0aNkMyswp6zBDGtdREwZOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Six8EYS0Kjew6mth7SKsGOrCtBxbpRV0eB85tYJ2GjDTZYN3kF49QYavTQlQ4IDpZ
	 JXbDxncz8qcgcurhawHkOw09PmHVSxDoo3frCH/wyqZEcfz+Sul/a8QFqQLtqe0HBh
	 Cow2tTTuQzPn3uvcoLH8sk3fuVzxFMeAl7N24S7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 099/780] media: rkvdec: Fix frame size enumeration
Date: Tue, 17 Jun 2025 17:16:47 +0200
Message-ID: <20250617152455.544920242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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
index f9bef5173bf25..a9bfd5305410c 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -213,8 +213,14 @@ static int rkvdec_enum_framesizes(struct file *file, void *priv,
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



