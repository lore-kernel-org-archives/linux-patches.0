Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7754B46A60E;
	Tue, 21 Jul 2026 19:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661790; cv=none; b=NoaHr0127NxwLL85AKNTnZPfsnK3tsfuPiE2pEeRXcm+vTHqRCD/6+JCKHdPr6e1Ta8gUyoDpsdTchm9Jy54hqElcSJHVhuhgy6ZYmf3MsOPlkLxSda5qZGnodhglDXyZ/PqVABj/tS8YYv88dd5RZqMEXnO1RsseiJ/p6jcXeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661790; c=relaxed/simple;
	bh=dZXKPK5zjthZi6KCxx4ia/uEmtwOqUH+kYGgpF7cDPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBkpmho/ddD+oCd4JL0ZXtbnG5nD/EgakHpTai/UMHVd1nR1872AduevqJ7w2k6Ag//RlHkuOInHHI7mxz7xP1HjYp0FtjZbvUAhpRVmX8fyZjkxLz7/sF0ggwo1NUVAhW2NylWcAjqLG5AMys45jvWkoBsMlfkb9B8/CKjfADA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRHQFm6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRHQFm6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCF51F000E9;
	Tue, 21 Jul 2026 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661789;
	bh=EaUpahD5hoL+l2wXbhAlFN9li0qHtyg02gCVgoor1vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRHQFm6xGblknzemnFSqdjwZeFveQ/LYf+a85ps1aNFFQXJ8rgdtO6sGzrfZrCbLb
	 bU9KtBvkAwHFX7SUuMM0N+AlAmAZjOx5bu/tWBe5KieInbSDuIFTLEyAZ7cai3dGOM
	 czQzeaDRwbDYKDuGsOT3gC8i0n+jNU4jBHGZc4I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renjiang Han <renjiang.han@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0200/1276] media: qcom: venus: drop extra padding in NV12 raw size calculation
Date: Tue, 21 Jul 2026 17:10:43 +0200
Message-ID: <20260721152450.562573431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 8295542e1a7c8c..d6984129c2f361 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -954,8 +954,8 @@ static u32 get_framesize_raw_nv12(u32 width, u32 height)
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



