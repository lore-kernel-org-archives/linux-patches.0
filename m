Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB56495D9;
	Thu, 30 Nov 2023 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grMNAVJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8C8C433C8;
	Thu, 30 Nov 2023 16:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361961;
	bh=xurkWOm46CGx774EHVG87GQxFz0j/7W2621pmyCayCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grMNAVJzWrSwJolu44qbZ2sY+7nQj3GXvsfE+bNqqsO//Dyh6qlcLkhcLFoKz0uo0
	 l+JKW3QqzmYVhYnrsT2JPx0UgCdwYB/sk0416oHx19SUiwiqZYYDMpc7DrEokov8W8
	 yFgk+6Mne90fx4QnhJrFs95nVQoZCxGzBe9ZZ4EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andrey.konovalov@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/69] media: qcom: camss: Fix csid-gen2 for test pattern generator
Date: Thu, 30 Nov 2023 16:22:29 +0000
Message-ID: <20231130162134.133390467@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andrey.konovalov@linaro.org>

[ Upstream commit 87889f1b7ea40d2544b49c62092e6ef2792dced7 ]

In the current driver csid Test Pattern Generator (TPG) doesn't work.
This change:
- fixes writing frame width and height values into CSID_TPG_DT_n_CFG_0
- fixes the shift by one between test_pattern control value and the
  actual pattern.
- drops fixed VC of 0x0a which testing showed prohibited some test
  patterns in the CSID to produce output.
So that TPG starts working, but with the below limitations:
- only test_pattern=9 works as it should
- test_pattern=8 and test_pattern=7 produce black frame (all zeroes)
- the rest of test_pattern's don't work (yavta doesn't get the data)
- regardless of the CFA pattern set by 'media-ctl -V' the actual pixel
  order is always the same (RGGB for any RAW8 or RAW10P format in
  4608x2592 resolution).

Tested with:

RAW10P format, VC0:
 media-ctl -V '"msm_csid0":0[fmt:SRGGB10/4608x2592 field:none]'
 media-ctl -V '"msm_vfe0_rdi0":0[fmt:SRGGB10/4608x2592 field:none]'
 media-ctl -l '"msm_csid0":1->"msm_vfe0_rdi0":0[1]'
 v4l2-ctl -d /dev/v4l-subdev6 -c test_pattern=9
 yavta -B capture-mplane --capture=3 -n 3 -f SRGGB10P -s 4608x2592 /dev/video0

RAW10P format, VC1:
 media-ctl -V '"msm_csid0":2[fmt:SRGGB10/4608x2592 field:none]'
 media-ctl -V '"msm_vfe0_rdi1":0[fmt:SRGGB10/4608x2592 field:none]'
 media-ctl -l '"msm_csid0":2->"msm_vfe0_rdi1":0[1]'
 v4l2-ctl -d /dev/v4l-subdev6 -c test_pattern=9
 yavta -B capture-mplane --capture=3 -n 3 -f SRGGB10P -s 4608x2592 /dev/video1

RAW8 format, VC0:
 media-ctl --reset
 media-ctl -V '"msm_csid0":0[fmt:SRGGB8/4608x2592 field:none]'
 media-ctl -V '"msm_vfe0_rdi0":0[fmt:SRGGB8/4608x2592 field:none]'
 media-ctl -l '"msm_csid0":1->"msm_vfe0_rdi0":0[1]'
 yavta -B capture-mplane --capture=3 -n 3 -f SRGGB8 -s 4608x2592 /dev/video0

Fixes: eebe6d00e9bf ("media: camss: Add support for CSID hardware version Titan 170")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Konovalov <andrey.konovalov@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-csid-170.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid-170.c b/drivers/media/platform/qcom/camss/camss-csid-170.c
index 270a960165b53..f7839e994bda6 100644
--- a/drivers/media/platform/qcom/camss/camss-csid-170.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-170.c
@@ -348,9 +348,6 @@ static void __csid_configure_stream(struct csid_device *csid, u8 enable, u8 vc)
 		u8 dt_id = vc;
 
 		if (tg->enabled) {
-			/* Config Test Generator */
-			vc = 0xa;
-
 			/* configure one DT, infinite frames */
 			val = vc << TPG_VC_CFG0_VC_NUM;
 			val |= INTELEAVING_MODE_ONE_SHOT << TPG_VC_CFG0_LINE_INTERLEAVING_MODE;
@@ -363,14 +360,14 @@ static void __csid_configure_stream(struct csid_device *csid, u8 enable, u8 vc)
 
 			writel_relaxed(0x12345678, csid->base + CSID_TPG_LFSR_SEED);
 
-			val = input_format->height & 0x1fff << TPG_DT_n_CFG_0_FRAME_HEIGHT;
-			val |= input_format->width & 0x1fff << TPG_DT_n_CFG_0_FRAME_WIDTH;
+			val = (input_format->height & 0x1fff) << TPG_DT_n_CFG_0_FRAME_HEIGHT;
+			val |= (input_format->width & 0x1fff) << TPG_DT_n_CFG_0_FRAME_WIDTH;
 			writel_relaxed(val, csid->base + CSID_TPG_DT_n_CFG_0(0));
 
 			val = format->data_type << TPG_DT_n_CFG_1_DATA_TYPE;
 			writel_relaxed(val, csid->base + CSID_TPG_DT_n_CFG_1(0));
 
-			val = tg->mode << TPG_DT_n_CFG_2_PAYLOAD_MODE;
+			val = (tg->mode - 1) << TPG_DT_n_CFG_2_PAYLOAD_MODE;
 			val |= 0xBE << TPG_DT_n_CFG_2_USER_SPECIFIED_PAYLOAD;
 			val |= format->decode_format << TPG_DT_n_CFG_2_ENCODE_FORMAT;
 			writel_relaxed(val, csid->base + CSID_TPG_DT_n_CFG_2(0));
-- 
2.42.0



