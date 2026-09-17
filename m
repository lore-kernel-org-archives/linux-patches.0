Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C996451C059;
	Thu, 17 Sep 2026 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667386; cv=none; b=XpQxCCUJS0Je92Qhw5uwdv1tHofjsbBO1cVAOIFuBkOyNLN7kINeA5bWQTVC83rscxv/vDsI8WWP+dDc05GakHncZDv5aoctSvpJZQCYPluEy43fr22c6lOQWJ/UUn5SnmTaYMhSDa0V/3NmEtDBmbz2zNGi+fhKLdjeZ72gJAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667386; c=relaxed/simple;
	bh=oMCWIMZGosJsPE95akvlIwJ/6hGFFBF9ylDPCahKO00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hX+zXswIESZFCfwDuSilJxQAvXjlfacMwKJhostErP0QskUzxmgbSbvQ5QALcn1faGdmV2qTnK27jyaWQS5DvAVthxXJUqq99FZ2C6Hqwjr5ATbcCngm0Tim/kSz4jXc174sUnAHBif9sANCsOOxz2T4fvrBksV5e2c43yHx+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w27G+EfA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w27G+EfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C361F000FF;
	Thu, 17 Sep 2026 17:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667384;
	bh=EeIX8snAtABwxpmB0zNGd7SCeifVltsgZJv08SzGUuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w27G+EfAs/DaTu6PcSKGSNl7KirBksWSEJTj6+nVvKNqNGVVwdDgdF7iG0B627AA/
	 dc/XgQTAOM7bQkZxTrf5qMmkznTsfWzT4geFUY1nJf8coggJgqwbFo3H3qohxEw39e
	 hmRkKM0CKmD5sHKBiqWRyheVjrV+dyz8K+hjrz2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0074/1102] media: chips-media: wave5: Add range checks for dec_output_info
Date: Thu, 17 Sep 2026 16:00:17 +0100
Message-ID: <20260917151541.327017970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 65fdabcd9d292..280db9a55eb43 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
@@ -553,8 +553,15 @@ int wave5_vpu_dec_get_output_info(struct vpu_instance *inst, struct dec_output_i
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



