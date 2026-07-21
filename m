Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2167444AB7F;
	Tue, 21 Jul 2026 21:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668922; cv=none; b=iakOt3qFzx71SRcFoD0TOA3AeayZPUMmQT/HTKbq4g7RCYVhrG90pofGDs7iB8TntfYMFjtdwSruWvKYgaPAQFH7i5sjlzc24+Ykj4+Kl0YNiOtRQskz+XmrPp9h8cMzLMGslu7EZ1Fp0ODluH/5Iok9xg9rxN8lfY8MBPzuaTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668922; c=relaxed/simple;
	bh=qZhbJfhqJ35f+JoKaJOcZpyroRwiC5fhRUkO3hXIdSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGKCyflXY9yVYNeFiK9sKKXARGfIQ+8FNrGpdqURSp8Uacca8K5yLnGNxht7HX2P1vrzy8ThHi5cRZ/pxRb/IUHUdDY0tRd5uc3QJSGNaUYOKMQUjj9m36vE9797FVXJ1TboiwsOFVUXrdxAJyoP20EHZfX7FyMAIM+ly0bwt+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RI4hoiPN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RI4hoiPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9B11F000E9;
	Tue, 21 Jul 2026 21:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668921;
	bh=QorGl5M9hjJJJr/7WMzK8pXPoSBpw2oyNn31S7GQYvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RI4hoiPNMteYX8On4/vsexfzdbhwNZk5RA+PoFFbwpFVrokels6SHdgEahfBEQK6v
	 enKFxAGUXMvS8hMSvNblK2maoAFRZCIUIEUL41XJd2jXr2tsU+G0A4owi5onwKzPw9
	 wd1T2kpz0unygGM3DVswh0CgJMCz305QZ+mOq3g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renjiang Han <renjiang.han@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0359/1067] media: qcom: venus: drop extra padding in NV12 raw size calculation
Date: Tue, 21 Jul 2026 17:16:00 +0200
Message-ID: <20260721152432.646016312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Renjiang Han <renjiang.han@oss.qualcomm.com>

[ Upstream commit e1c9adabb268cc5d56723b7df1da49e59070f309 ]

get_framesize_raw_nv12() currently adds SZ_4K to the UV plane size and an
additional SZ_8K to the total buffer size. This inflates the calculated
sizeimage and leads userspace to over-allocate buffers without a clear
requirement.

Remove the extra SZ_4K/SZ_8K padding and compute the NV12 size as the sum
of Y and UV planes, keeping the final ALIGN(size, SZ_4K) intact.

Fixes: e1cb72de702ad ("media: venus: helpers: move frame size calculations on common place")
Signed-off-by: Renjiang Han <renjiang.han@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 652ad33cbc4b2d..918c0d65de0aad 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -952,8 +952,8 @@ static u32 get_framesize_raw_nv12(u32 width, u32 height)
 	uv_sclines = ALIGN(((height + 1) >> 1), 16);
 
 	y_plane = y_stride * y_sclines;
-	uv_plane = uv_stride * uv_sclines + SZ_4K;
-	size = y_plane + uv_plane + SZ_8K;
+	uv_plane = uv_stride * uv_sclines;
+	size = y_plane + uv_plane;
 
 	return ALIGN(size, SZ_4K);
 }
-- 
2.53.0



