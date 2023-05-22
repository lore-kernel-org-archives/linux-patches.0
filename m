Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ECD171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DAAC433EF;
	Mon, 22 May 2023 19:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783524;
	bh=4WEG8nfAvdunFGh0TR6vBtdz1z/RCOD4phfAcvrKy8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDrYGfDFelpkoSIsejFklmKvIRM6bMYd8Kv0l0lK/mWhYtOqhdOu/lh6UROau0/4u
	 JsGkb6hHfhfyNr4gWOX+VZyE3Tn7m4L2XesxkaZ8ozsRKpQ5KxZCFilo2HxoshcVla
	 NplqwX7QHwoZ4BVh29l+/d9G59TmC9uzOrFZ++Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Chen <harperchen1110@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/292] media: mediatek: vcodec: Fix potential array out-of-bounds in decoder queue_setup
Date: Mon, 22 May 2023 20:07:09 +0100
Message-Id: <20230522190407.762290769@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Chen <harperchen1110@gmail.com>

[ Upstream commit 8fbcf730cb89c3647f3365226fe7014118fa93c7 ]

variable *nplanes is provided by user via system call argument. The
possible value of q_data->fmt->num_planes is 1-3, while the value
of *nplanes can be 1-8. The array access by index i can cause array
out-of-bounds.

Fix this bug by checking *nplanes against the array size.

Signed-off-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
index c99705681a03e..93fcea821001f 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
@@ -735,6 +735,13 @@ int vb2ops_vdec_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	}
 
 	if (*nplanes) {
+		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+			if (*nplanes != q_data->fmt->num_planes)
+				return -EINVAL;
+		} else {
+			if (*nplanes != 1)
+				return -EINVAL;
+		}
 		for (i = 0; i < *nplanes; i++) {
 			if (sizes[i] < q_data->sizeimage[i])
 				return -EINVAL;
-- 
2.39.2



