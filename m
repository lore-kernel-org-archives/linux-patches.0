Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CB9384;
	Thu, 13 Jun 2024 12:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282167; cv=none; b=HUXA/ARdKZDAAcedt5UkNTCIbHfe8J81AyEZJAY3Xl2RAQQgdivkCqONIOCbJhT77QxP56s/8B+kmEOnv0HSUVoftjmQEDxtF5enaKG9etWE7ljGJQrCwiguajwMrusq/Sz5QRjFDvKnzMFIbz3y7Ixr2o7URgExpHCKnAIfNFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282167; c=relaxed/simple;
	bh=EZ7+2qgZj1sdH5XuJGkBM+LD1wqxdzbrDBVbT5ywycQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6uyzyZDb4FO/LYZUJ/zXToXTH2nSU5wiiRBX1bCI1r4uY6qAfrtQPEardk2JSCPNCnGWKKgYGqBGb78wFp5Wj2wXUnl8jKlrzMtj9QQ7BTiagZOas0OO0Jp0R3uYYif62zFJo6mOBWBtz0oZ/vHSiFVgkMzFFO+bW4KZO6kU5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeAa2z/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeAa2z/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C6AC4AF1C;
	Thu, 13 Jun 2024 12:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282167;
	bh=EZ7+2qgZj1sdH5XuJGkBM+LD1wqxdzbrDBVbT5ywycQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeAa2z/iUMWB5QsYu4/8TBrV5qiT2DXagg0IBbh+POHisrfbwlylnraSR+ZO3q2p2
	 MhLbJ1Lc4xO0P/JTl9k9FNb8Zx86bG7cSqP7kuECO7/CQGxufekb2lmTBieLfRE9nc
	 gvleG2wpPU8+0IG6aG5ioZgNmp9g9cnAD2DZs5SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Marc Gonzalez <mgonzalez@freebox.fr>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/402] clk: qcom: mmcc-msm8998: fix venus clock issue
Date: Thu, 13 Jun 2024 13:31:52 +0200
Message-ID: <20240613113308.181347265@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index a68764cfb7930..5e2e60c1c2283 100644
--- a/drivers/clk/qcom/mmcc-msm8998.c
+++ b/drivers/clk/qcom/mmcc-msm8998.c
@@ -2587,6 +2587,8 @@ static struct clk_hw *mmcc_msm8998_hws[] = {
 
 static struct gdsc video_top_gdsc = {
 	.gdscr = 0x1024,
+	.cxcs = (unsigned int []){ 0x1028, 0x1034, 0x1038 },
+	.cxc_count = 3,
 	.pd = {
 		.name = "video_top",
 	},
@@ -2595,20 +2597,26 @@ static struct gdsc video_top_gdsc = {
 
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



