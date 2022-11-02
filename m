Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757D0633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E954C433D6;
	Wed,  2 Nov 2022 03:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360780;
	bh=VvzhreFiUeeY9bk0cBpFcnqvpoq8fDpRsrXgFX9xgUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBt7BmiAfJHrQlaX2RD7g3geDpeI19HsQsNok9iKG56j4a7mV0HqsVXvHnmxnPwUy
	 L6C/0oU/Qi4pw9GoPmtVYjksXeLTXAa0tJCaNVCSCbVST59iiuxeCa2PDfMKGca4zb
	 ghnUTnkckINARQ5pWig+g0QENH3TDoQi1jW+UKRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 36/44] media: v4l2-dv-timings: add sanity checks for blanking values
Date: Wed,  2 Nov 2022 03:35:22 +0100
Message-Id: <20221102022050.333378830@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 4b6d66a45ed34a15721cb9e11492fa1a24bc83df ]

Add sanity checks to v4l2_valid_dv_timings() to ensure that the provided
blanking values are reasonable.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: b18787ed1ce3 ([media] v4l2-dv-timings: add new helper module)
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 730a7c392c1d..12e04ac6a9ee 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -171,6 +171,20 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	    (bt->interlaced && !(caps & V4L2_DV_BT_CAP_INTERLACED)) ||
 	    (!bt->interlaced && !(caps & V4L2_DV_BT_CAP_PROGRESSIVE)))
 		return false;
+
+	/* sanity checks for the blanking timings */
+	if (!bt->interlaced &&
+	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
+		return false;
+	if (bt->hfrontporch > 2 * bt->width ||
+	    bt->hsync > 1024 || bt->hbackporch > 1024)
+		return false;
+	if (bt->vfrontporch > 4096 ||
+	    bt->vsync > 128 || bt->vbackporch > 4096)
+		return false;
+	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
+	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }
 EXPORT_SYMBOL_GPL(v4l2_valid_dv_timings);
-- 
2.35.1



