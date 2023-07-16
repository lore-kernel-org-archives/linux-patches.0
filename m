Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45D18F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC45DC433C7;
	Sun, 16 Jul 2023 20:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538842;
	bh=GDGzWpb4PeW6x27Y8Ho3q8elE1iRWc41EKla1wpVPX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+HooEeelReL7xoTglrpUr+PPdlYaPYb8TeiSB2tNLv8YF886nMNle0uH8aKTZsQ6
	 gODmCp1SHdByx8LO4oABYDFWS787e67KnQA+mYun22s+PfpFYfxE/FRvXEHrkJdxl1
	 qgCacgr7i3WjHF4dYC7klFbeIT0UfBhGw87pEfo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	"xiahong.bao" <xiahong.bao@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 567/800] media: amphion: drop repeated codec data for vc1g format
Date: Sun, 16 Jul 2023 21:47:00 +0200
Message-ID: <20230716195002.258212082@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit e1d2ccc2cdd6333584aa3d5386dc667d0837c48f ]

For format V4L2_PIX_FMT_VC1_ANNEX_G,
the separate codec data is required only once.
The repeated codec data may introduce some decoding error.
so drop the repeated codec data.

It's amphion vpu's limitation

Fixes: e670f5d672ef ("media: amphion: only insert the first sequence startcode for vc1l format")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Tested-by: xiahong.bao <xiahong.bao@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_malone.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index e96994437429f..c1d6606ad7e57 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -1313,6 +1313,15 @@ static int vpu_malone_insert_scode_pic(struct malone_scode_t *scode, u32 codec_i
 	return sizeof(hdr);
 }
 
+static int vpu_malone_insert_scode_vc1_g_seq(struct malone_scode_t *scode)
+{
+	if (!scode->inst->total_input_count)
+		return 0;
+	if (vpu_vb_is_codecconfig(to_vb2_v4l2_buffer(scode->vb)))
+		scode->need_data = 0;
+	return 0;
+}
+
 static int vpu_malone_insert_scode_vc1_g_pic(struct malone_scode_t *scode)
 {
 	struct vb2_v4l2_buffer *vbuf;
@@ -1460,6 +1469,7 @@ static const struct malone_scode_handler scode_handlers[] = {
 	},
 	{
 		.pixelformat = V4L2_PIX_FMT_VC1_ANNEX_G,
+		.insert_scode_seq = vpu_malone_insert_scode_vc1_g_seq,
 		.insert_scode_pic = vpu_malone_insert_scode_vc1_g_pic,
 	},
 	{
-- 
2.39.2



