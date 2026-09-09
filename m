Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6A35650F4;
	Wed,  9 Sep 2026 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962795; cv=none; b=RA9MwkfL2OJm38ry81+l+R3X8S6dDdP0UsLQt0HotJeRv4D5XBGn1wFhoWm2eN69xjpSrqAO7VkvI7rRtf8do/1Hqu+FZyyuM6E07izpbwGzo0eHDzeEEkzcuUT9f3jCAm7Lw+fgDJPWwCV1QA+z+vXUM8JhzR8LoH8PGyAcCpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962795; c=relaxed/simple;
	bh=VibMdN7rwNIhzWQ/uAFf41AdWO75LLicU5cYVX0XNoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHKhRg3P5N511SePKERDpN/b4OMFQYH/37b/8SuX5zd7gPZokyasvxgb3i9azhwAlQKJi09vXt3T3lwadITaeY8xnL/eVR1qcEoM5b/IpHTTKbinf9xivc8ssLP3cSbt4ZakZw7Qz8ZPz35tEv0672TcbIpw0RyaRFQjsearAHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFIHs1BB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFIHs1BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA221F00A3A;
	Wed,  9 Sep 2026 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962794;
	bh=7kWYuEdJoKVd2gjJ2SKNcsTiQympjFQP3naQ8BFBXeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFIHs1BBW4IugBh4xXUzIkW8jq7sFJp5+xmn+wCMO90t7lNN0FG/DyzPBTII8u1b4
	 kVFhCWiXIl7V6lPujiSTSmvmaoJQlSpLD0rLmatW6p/tm5jgel3aMP/6tfaeOL+hr8
	 aHTOul3Irzya6XxoOcgEJs0aaEhoWworydv1F09g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 387/556] media: rkvdec: hevc: tighten EXT SPS RPS control dimensions
Date: Wed,  9 Sep 2026 15:41:07 +0200
Message-ID: <20260909134244.282624565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit f0b9d7e5be061b4858279d451f5a6ad0ed20b1be upstream.

The VDPU381 HEVC driver registers V4L2_CID_STATELESS_HEVC_EXT_SPS_ST_RPS
and V4L2_CID_STATELESS_HEVC_EXT_SPS_LT_RPS with .cfg.dims = { 65 }, but
the HEVC spec caps num_short_term_ref_pic_sets at 64 (ITU-T H.265 7.4.8)
and num_long_term_ref_pics_sps at 32 (7.4.3.2.1). The hardware descriptor
table (struct rkvdec_rps) sizes match those spec limits: refs[32] and
short_term_ref_sets[64].

Reduce the dims to { 64 } and { 32 } respectively so the V4L2 control
framework rejects oversized payloads before any driver code runs.

Fixes: c9a59dc2acc7 ("media: rkvdec: Add HEVC support for the VDPU381 variant")
Cc: stable@vger.kernel.org
Suggested-by: Detlev Casanova <detlev.casanova@collabora.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rkvdec/rkvdec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/rockchip/rkvdec/rkvdec.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec.c
@@ -278,12 +278,12 @@ static const struct rkvdec_ctrl_desc vdp
 	{
 		.cfg.id = V4L2_CID_STATELESS_HEVC_EXT_SPS_ST_RPS,
 		.cfg.ops = &rkvdec_ctrl_ops,
-		.cfg.dims = { 65 },
+		.cfg.dims = { 64 },
 	},
 	{
 		.cfg.id = V4L2_CID_STATELESS_HEVC_EXT_SPS_LT_RPS,
 		.cfg.ops = &rkvdec_ctrl_ops,
-		.cfg.dims = { 65 },
+		.cfg.dims = { 32 },
 	},
 };
 


