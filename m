Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A38E231829;
	Tue, 21 Jul 2026 22:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673589; cv=none; b=MMLWOE5a34i7j1xRVRtxyjZkGntpqU5ipeNCgIoi98U0uDkgDYSbf5T2LKU6c18dgSGytwMYbmpi1P23bO2+8nwqNP9BHFAV5iV/q7eGuPycF8+HANjeAkGFPjGIcfTH1ZXABkcQGUKoKj+hHRcJJgHlApP7Mr6q0aWKoq56b9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673589; c=relaxed/simple;
	bh=B4X5dU+eFDeUk2A7m+FLJHVfosturHM+24oes+ZntQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaWHvE9wyv4iB+Nt6ex7Fsz4XKb2mGb/fa0u7VkZbc7TeaeqBM51l+G3nsEEgtm7Ahch9aG9kkm4lPYklSrlt5kWfqFpJgFTJ+VAEttxi60tDxg3H7nOeAOLXx0z4EmuRtXyoAoCCLZ5VRt8fby/ed9bFFY2NQTwt94dp7QtIKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+atSbXs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+atSbXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900FC1F000E9;
	Tue, 21 Jul 2026 22:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673588;
	bh=PwaNpvQ27pYB0XSI7FYrBzjNa+qE+mIQwxkf/gOoywU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+atSbXsITgPorMUj+pC4xNZvRz4z9jyzFeKXAj5tj7uHb7Vf9zGR/iJV+Z2L6p2b
	 1ja31XHIzKQ38jx0lbDGKlvEAF3HSU3qF7x4zSocYB1a3SsoRYiHEqj+oJJqNNBylx
	 GcAiy0jRY3XBTY2aLx2zgELOZKFcIb1Ywv7aw3C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renjiang Han <renjiang.han@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/699] media: qcom: venus: drop extra padding in NV12 raw size calculation
Date: Tue, 21 Jul 2026 17:19:36 +0200
Message-ID: <20260721152400.595986185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dcf9fc0da1ce42..d590c845ea2675 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -834,8 +834,8 @@ static u32 get_framesize_raw_nv12(u32 width, u32 height)
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



