Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D895646A5F4;
	Tue, 21 Jul 2026 15:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648934; cv=none; b=aMDwSplSIIYwiPgSDzAune7LaMEamUamRdZxLCypczwFIhdaeLnGmkfxfMAFCiS5NJDKoJ4+DhfYS/CIqpNL3oQoW6drXlLrTRG5CMLKz5ZB3LfOnHf8KvkK0qb9XcPYB3AomG4iyC73gVuNFIH+8QQiKoCp8hwRvw+qDx8MiWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648934; c=relaxed/simple;
	bh=5csNALeBSs2rKw193lEvz1Sk1oWaiCfHCry/r6kr7sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYICz6PqgYhqOIUBidlvTXOafURYDwwCdmZ3H6+kj0ohNcnT0YCbvjadd7CNg6FlbrBxx1nDsEMAWCVzGcRgaFr6o4uMHIchH7GNBaYEW3ZRKtSM/R4y6geeePp1mRoQgIxyzf8CrLURhfoqFX8kNzkaI47AdAk8tIfCrb769To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZsIPDMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZsIPDMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD821F00A3A;
	Tue, 21 Jul 2026 15:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648933;
	bh=Z4iz+M4x+oXS5bcPhDREzpLJ6IG8p3Saho9LDivjORg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZsIPDMUnrphJ8hXThRshOEc7JOKfEdDqTXC/FfeLjvK50jVS1NE+FjJuxbIczS00
	 4ZJWJDwmEzH7NBlrijp3TkUEAPVNQA3++pMOHbxOcbnRmilGHmH7pG2JRRFIKXyBg7
	 UdD2AWa0CFNQ7r5VvgwR7HJBR4gINeWxJuohYZWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renjiang Han <renjiang.han@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0387/2077] media: qcom: venus: drop extra padding in NV12 raw size calculation
Date: Tue, 21 Jul 2026 17:01:00 +0200
Message-ID: <20260721152601.828956006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 747c388fe25fa3..59eee3dd9e06c2 100644
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



