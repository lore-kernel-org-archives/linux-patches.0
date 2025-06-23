Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6FA252903;
	Mon, 23 Jun 2025 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685928; cv=none; b=p3c1iZ4FEAJsbEYW2EJfycVsDzQK/uOBeigMyAOKndjOB82zx7bSUUHBj+fUcP2Yq1OrFevOqNYP7b95xskJfXR/yySEannaGKQQo2h2QMnyzOPfZ6zu9EFCxNOPCxAQgwWG5F9CzosL5uIEq4o8IwtHNSJ1yfNEev10Xsr+h2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685928; c=relaxed/simple;
	bh=hgIXNwtVHeJq4G8Sgzvbrd/JfkVf2+MKAfY10VOAWTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWaHPuXBP5NY0GtCQNpbGVNIF3MJiUXhCQtl6aK+9XCOdRE9hp8c7cgl24IIQmUojF7eYMyPePMhAAFAQfGIGHvy2EiwgIqU0Of/DX17t76m9A1K1AkU4BRGZMaqrPH5FC6FEntgrNJxESNjpLdsRPRAY3zg53wlyfO3d/d5Feg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmyNDH4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmyNDH4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173D6C4CEF3;
	Mon, 23 Jun 2025 13:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685928;
	bh=hgIXNwtVHeJq4G8Sgzvbrd/JfkVf2+MKAfY10VOAWTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmyNDH4up0Y9DzeNMkJKe78MSr6oRVAkFJvGF47jDQC/FZlSvURUE67bBTKbcTVEB
	 eUdgshVcEhi66XqQ/nUUNRIPJAoehhzZCqZV3mwqIzMANRzHkH1pQlnufS9hv1+Hir
	 mNdkcooDs78y3/ZY3SgXnzzg6LgXbVPT9uGjK594=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/508] media: rkvdec: Fix frame size enumeration
Date: Mon, 23 Jun 2025 15:01:23 +0200
Message-ID: <20250623130646.183144419@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
index d16cf4115d03a..b5847259f4541 100644
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



