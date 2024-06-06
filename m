Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3953119AD8E;
	Thu,  6 Jun 2024 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683370; cv=none; b=kxE8RM7ynaut9B2BfPgyqWgheV+Q8YGYGKO0sbGtvfkwVk73mItP6OBX85pTqt9w0w7DJnjWqxoEjMa8VQdyMN5axy+HrhZ4PB+mMgs/qsSvD4rbN4whzW9X+OMqWeJ7cJULEiHhy87y2XrdfmXESJYgZ4XN/j8w3M+NBsHhNdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683370; c=relaxed/simple;
	bh=UEFpl9WcuCBsm0BRvo67ltCDnOtl3y1r0sVH2LZZORQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRDf9HUg2fjzXGhr/hLP3t0HgVN/n25Uu+uFf9iSWmszOGrWKHq5i2X/YPWbhKMS1yGfpqwaAPY5jolt9UgibDMxGkS8lBy8elOAt7TmVmW14q09wdBJA6q+JZdEIo+siP9YkZUXOEvkUAQAXuEbB1KSdxAsAbsjBa3SqqS/LTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irXQrDmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irXQrDmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDBBC32782;
	Thu,  6 Jun 2024 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683370;
	bh=UEFpl9WcuCBsm0BRvo67ltCDnOtl3y1r0sVH2LZZORQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irXQrDmvjQgFD2Ng3NP6hDVgtTYrMB1FywCnuMgNLHOFQ5RcUee+apfPkFF7S0LL4
	 yEb3KEf/YbnZHG7yRJx7LCBN54rsHVK/fx4Lv3kENjufw1FoeOmL+NIfEDcrpZsuz3
	 zhy3x1Rj+vpPIFuaPz9Ku1G3C7p/Bib2sZA+yfQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Marc Gonzalez <mgonzalez@freebox.fr>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/473] clk: qcom: mmcc-msm8998: fix venus clock issue
Date: Thu,  6 Jun 2024 16:03:03 +0200
Message-ID: <20240606131708.372149877@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Gonzalez <mgonzalez@freebox.fr>

[ Upstream commit e20ae5ae9f0c843aded4f06f3d1cab7384789e92 ]

Right now, msm8998 video decoder (venus) is non-functional:

$ time mpv --hwdec=v4l2m2m-copy --vd-lavc-software-fallback=no --vo=null --no-audio --untimed --length=30 --quiet demo-480.webm
 (+) Video --vid=1 (*) (vp9 854x480 29.970fps)
     Audio --aid=1 --alang=eng (*) (opus 2ch 48000Hz)
[ffmpeg/video] vp9_v4l2m2m: output VIDIOC_REQBUFS failed: Connection timed out
[ffmpeg/video] vp9_v4l2m2m: no v4l2 output context's buffers
[ffmpeg/video] vp9_v4l2m2m: can't configure decoder
Could not open codec.
Software decoding fallback is disabled.
Exiting... (Quit)

Bryan O'Donoghue suggested the proper fix:
- Set required register offsets in venus GDSC structs.
- Set HW_CTRL flag.

$ time mpv --hwdec=v4l2m2m-copy --vd-lavc-software-fallback=no --vo=null --no-audio --untimed --length=30 --quiet demo-480.webm
 (+) Video --vid=1 (*) (vp9 854x480 29.970fps)
     Audio --aid=1 --alang=eng (*) (opus 2ch 48000Hz)
[ffmpeg/video] vp9_v4l2m2m: VIDIOC_G_FMT ioctl
[ffmpeg/video] vp9_v4l2m2m: VIDIOC_G_FMT ioctl
...
Using hardware decoding (v4l2m2m-copy).
VO: [null] 854x480 nv12
Exiting... (End of file)
real	0m3.315s
user	0m1.277s
sys	0m0.453s

NOTES:

GDSC = Globally Distributed Switch Controller

Use same code as mmcc-msm8996 with:
s/venus_gdsc/video_top_gdsc/
s/venus_core0_gdsc/video_subcore0_gdsc/
s/venus_core1_gdsc/video_subcore1_gdsc/

https://git.codelinaro.org/clo/la/kernel/msm-4.4/-/blob/caf_migration/kernel.lnx.4.4.r38-rel/include/dt-bindings/clock/msm-clocks-hwio-8996.h
https://git.codelinaro.org/clo/la/kernel/msm-4.4/-/blob/caf_migration/kernel.lnx.4.4.r38-rel/include/dt-bindings/clock/msm-clocks-hwio-8998.h

0x1024 = MMSS_VIDEO GDSCR (undocumented)
0x1028 = MMSS_VIDEO_CORE_CBCR
0x1030 = MMSS_VIDEO_AHB_CBCR
0x1034 = MMSS_VIDEO_AXI_CBCR
0x1038 = MMSS_VIDEO_MAXI_CBCR
0x1040 = MMSS_VIDEO_SUBCORE0 GDSCR (undocumented)
0x1044 = MMSS_VIDEO_SUBCORE1 GDSCR (undocumented)
0x1048 = MMSS_VIDEO_SUBCORE0_CBCR
0x104c = MMSS_VIDEO_SUBCORE1_CBCR

Fixes: d14b15b5931c2b ("clk: qcom: Add MSM8998 Multimedia Clock Controller (MMCC) driver")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Marc Gonzalez <mgonzalez@freebox.fr>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/ff4e2e34-a677-4c39-8c29-83655c5512ae@freebox.fr
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8998.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/qcom/mmcc-msm8998.c b/drivers/clk/qcom/mmcc-msm8998.c
index e5a72c2f080f8..c282424bac537 100644
--- a/drivers/clk/qcom/mmcc-msm8998.c
+++ b/drivers/clk/qcom/mmcc-msm8998.c
@@ -2578,6 +2578,8 @@ static struct clk_hw *mmcc_msm8998_hws[] = {
 
 static struct gdsc video_top_gdsc = {
 	.gdscr = 0x1024,
+	.cxcs = (unsigned int []){ 0x1028, 0x1034, 0x1038 },
+	.cxc_count = 3,
 	.pd = {
 		.name = "video_top",
 	},
@@ -2586,20 +2588,26 @@ static struct gdsc video_top_gdsc = {
 
 static struct gdsc video_subcore0_gdsc = {
 	.gdscr = 0x1040,
+	.cxcs = (unsigned int []){ 0x1048 },
+	.cxc_count = 1,
 	.pd = {
 		.name = "video_subcore0",
 	},
 	.parent = &video_top_gdsc.pd,
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = HW_CTRL,
 };
 
 static struct gdsc video_subcore1_gdsc = {
 	.gdscr = 0x1044,
+	.cxcs = (unsigned int []){ 0x104c },
+	.cxc_count = 1,
 	.pd = {
 		.name = "video_subcore1",
 	},
 	.parent = &video_top_gdsc.pd,
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = HW_CTRL,
 };
 
 static struct gdsc mdss_gdsc = {
-- 
2.43.0



