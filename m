Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD98524B0C;
	Thu, 17 Sep 2026 16:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661174; cv=none; b=HLbbLu05s9RGKGtbwQamyp9N2f/TPXdDNF/d3X0vB9nCxGsN76eW8NmG1ZRSdKJcsWGMuBQYhbCo5QMqyk5zZFwEBsQ+hNqtoZQBB6lQANhMIcYF4J9Ur6G5n3MlNPdXhM4t+fOnretPbBL6FrHzRfFHX+op/uREwPdkbKQcmB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661174; c=relaxed/simple;
	bh=ifpLdTSQGfhpoMKTopa5kFrpValhbY2wJJNbiLWP4fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjv0TwPovE94lQ1r9XXVls6K3BPJd6c/YixTMHPv7xjKQ43XL8jyIIE1vfv9mqOrh5BQgfg5bAiALt1vGijvnTZvhP/iPQbx9WPamNw89ws59f5yU1CRsPJQst6Fhr3N0O+64beqDd262hFLSRY+f01wMyidrlVveY4PumVgZJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOisyl+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOisyl+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B061F00893;
	Thu, 17 Sep 2026 16:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661173;
	bh=a9qbjHSWPHyThNhSuCTJ1pnaTNjt0PVuVHpQ7Dqidao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOisyl+Wjg36S9KLdSY5fHmmUslurCdMX32IlOevpbwsxY4l1xvaOyyZMQnS7BZ6b
	 HOeuma/Ttc8nRDkHWzNUl1PWfZyvlydfbB6FhQaEjI1bFRxF0EynvPAF7EzjOC6sBo
	 5Exc3f7hEQspdirol+X3p23EARixjDs0zMAe9o3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0106/1250] media: chips-media: wave5: Add range checks for dec_output_info
Date: Thu, 17 Sep 2026 15:58:21 +0100
Message-ID: <20260917151554.873177564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 79aef69bb0903616f4867f0168aea717a11c439c ]

If the driver's dec_output_info contains invalid data the driver can
write in invalid memory. Add a range check for that.

This fixes this smatch error:
drivers/media/platform/chips-media/wave5/wave5-vpuapi.c:588 wave5_vpu_dec_get_output_info() error: buffer overflow 'inst->frame_buf' 64 <= 127

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/chips-media/wave5/wave5-vpuapi.c   | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
index e94d6ebc9f816..e7ea2f6a99d5b 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
@@ -559,8 +559,15 @@ int wave5_vpu_dec_get_output_info(struct vpu_instance *inst, struct dec_output_i
 		p_dec_info->num_of_decoding_fbs : p_dec_info->num_of_display_fbs;
 
 	if (info->index_frame_display >= 0 &&
-	    info->index_frame_display < (int)max_dec_index)
-		info->disp_frame = inst->frame_buf[val + info->index_frame_display];
+	    info->index_frame_display < (int)max_dec_index) {
+		u32 idx = val + info->index_frame_display;
+
+		if (WARN_ON(idx >= MAX_REG_FRAME)) {
+			ret = -EINVAL;
+			goto err_out;
+		}
+		info->disp_frame = inst->frame_buf[idx];
+	}
 
 	info->rd_ptr = p_dec_info->stream_rd_ptr;
 	info->wr_ptr = p_dec_info->stream_wr_ptr;
-- 
2.53.0



