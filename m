Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F08393DD1;
	Tue, 26 Aug 2025 11:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208417; cv=none; b=PqDXYwGAhU1xj3JDi2axuNP7kSUuTrDgb0lC4ki1q4pthpNLlV0IzES7mhlWFsA/jEDsaSLizpbV6bpqiVOWTwMHVN+Rxn+nROTBe2Xi53ccNTnap/tAHp00I4Y64k5zqmqIwezUf4XJiFcO0Us9jGDaOJC62agLMNHR//lGpxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208417; c=relaxed/simple;
	bh=Bbqdwrivrgn8erSyYoPeI/vobkSyXA5MHDprmAlH22Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGZM93y9uQ+h1T4XN0PDJFOqvMQAJje6KJwcFSBbWnuSXo1/OOnJNUQP99lKIm/qInWAH17HPZoiN0vjmZv8n8AYXKMftgWbpb8Ekj5CLUOrxm+PCzQ8e1rvZ78/lchUk7HomJmVL3jtM6ZFoAf2DAWIH2ARiwEE9nfWb1Z8wNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLUc9uMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLUc9uMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E19C4CEF1;
	Tue, 26 Aug 2025 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208417;
	bh=Bbqdwrivrgn8erSyYoPeI/vobkSyXA5MHDprmAlH22Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLUc9uMeMXintaa46zkqIXwQXFz0jPSpJwEAkB8VUmPwjGx+foOicy+dwyK3n0xrb
	 s5Gy2+mVKQWYCHfi6FSJOkrUkwZk56rzUzSMEbU6m07d8HvnC7G9AVEl/E+1G8252Z
	 Xxte0g18fAmEAQBEUXKIoPI6922FlOWhGvaf26pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 102/322] media: vivid: fix wrong pixel_array control size
Date: Tue, 26 Aug 2025 13:08:37 +0200
Message-ID: <20250826110918.235468695@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil@xs4all.nl>

commit 3e43442d4994c9e1e202c98129a87e330f7faaed upstream.

The pixel_array control size was calculated incorrectly:
the dimensions were swapped (dims[0] should be the height), and the
values should be the width or height divided by PIXEL_ARRAY_DIV
and rounded up. So don't use roundup, but use DIV_ROUND_UP instead.

This bug is harmless in the sense that nothing will break, except that
it consumes way too much memory for this control.

Fixes: 6bc7643d1b9c ("media: vivid: add pixel_array test control")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vivid/vivid-ctrls.c   |    3 ++-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/test-drivers/vivid/vivid-ctrls.c
+++ b/drivers/media/test-drivers/vivid/vivid-ctrls.c
@@ -243,7 +243,8 @@ static const struct v4l2_ctrl_config viv
 	.min = 0x00,
 	.max = 0xff,
 	.step = 1,
-	.dims = { 640 / PIXEL_ARRAY_DIV, 360 / PIXEL_ARRAY_DIV },
+	.dims = { DIV_ROUND_UP(360, PIXEL_ARRAY_DIV),
+		  DIV_ROUND_UP(640, PIXEL_ARRAY_DIV) },
 };
 
 static const struct v4l2_ctrl_config vivid_ctrl_s32_array = {
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -453,8 +453,8 @@ void vivid_update_format_cap(struct vivi
 	if (keep_controls)
 		return;
 
-	dims[0] = roundup(dev->src_rect.width, PIXEL_ARRAY_DIV);
-	dims[1] = roundup(dev->src_rect.height, PIXEL_ARRAY_DIV);
+	dims[0] = DIV_ROUND_UP(dev->src_rect.height, PIXEL_ARRAY_DIV);
+	dims[1] = DIV_ROUND_UP(dev->src_rect.width, PIXEL_ARRAY_DIV);
 	v4l2_ctrl_modify_dimensions(dev->pixel_array, dims);
 }
 


