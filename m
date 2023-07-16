Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7092E8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FCFC433C7;
	Sun, 16 Jul 2023 20:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540532;
	bh=s3R8g4QE40GllNpqSeri+HBhfyFpnkFaMvtFqGoMgPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7iAYChmI/iRwt87wfDLuwjsYYmm4OlfWQcTbpRoM65ncxxgKn8ArRoUEJYk7LVJQ
	 epvYM/oxwmZtyLMekG+2SwPx0/Zejtam/R0wFBEGbd4DQvxmW99bESTYKgx0SRHLGu
	 xvVEEPqQYf9CH2sQYmdAHTBpHJPXyatolIs2CpMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	"xiahong.bao" <xiahong.bao@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 396/591] media: amphion: drop repeated codec data for vc1g format
Date: Sun, 16 Jul 2023 21:48:55 +0200
Message-ID: <20230716194934.163737503@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 36e563d29621f..c2f4fb12c3b64 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -1286,6 +1286,15 @@ static int vpu_malone_insert_scode_pic(struct malone_scode_t *scode, u32 codec_i
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
@@ -1423,6 +1432,7 @@ static const struct malone_scode_handler scode_handlers[] = {
 	},
 	{
 		.pixelformat = V4L2_PIX_FMT_VC1_ANNEX_G,
+		.insert_scode_seq = vpu_malone_insert_scode_vc1_g_seq,
 		.insert_scode_pic = vpu_malone_insert_scode_vc1_g_pic,
 	},
 	{
-- 
2.39.2



