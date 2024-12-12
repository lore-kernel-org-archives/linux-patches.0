Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC0E223E8D;
	Thu, 12 Dec 2024 17:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025736; cv=none; b=CKh5bZqIataNQRZCNuWRO4p0VvaMyomZqtnTcENWADi08T2xZY4Admg6k1qj39g0pfJWpvmbbDwO5UjwqqeRwNPbzHoRzsNfEcmpU9iO1GQsIRenc6HHCzWzf9z2fpoNiNEt7UEPN6AovmNfWtIAb0qATUW/fL1GXFOafPgdzks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025736; c=relaxed/simple;
	bh=s2PWYsitFNWblFaNOHIE3plgtqvzcDrmCZNWl6/4Qyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIFC3UAXTusBxq3M++rLsXVrVNlE3a1OlNxH3f/+ThN34owfxOUFGgG3LNzqy1bcczVLfvONu751rWUu5wKoa0ZLfM6IvscfSDcQ8+GsP83Qgj3+pjVz71PT6I70Ar8mhj+jghMLMAhdze/DOen4e2unuoH8hO50AnIUbLCfIbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZQfjOsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZQfjOsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8BCC4CECE;
	Thu, 12 Dec 2024 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025736;
	bh=s2PWYsitFNWblFaNOHIE3plgtqvzcDrmCZNWl6/4Qyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZQfjOsAq0g/Nim95w2qrNankvtPLfoA5BgsStIMIExyq3nzHfOCpgbcGIB5FU9cv
	 BB0NLqx6G7/FDfUIiplvRNlDuqU7IRx5dKMpKgJfHDYhlINN8IRGXtAo8JGTi0s+QF
	 6itGOa6zmZcA9tpF9q7fwsZ4laU8SPhc9IdoCZ3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 269/321] drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()
Date: Thu, 12 Dec 2024 16:03:07 +0100
Message-ID: <20241212144240.607629599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Artemiev <Igor.A.Artemiev@mcst.ru>

[ Upstream commit a1e2da6a5072f8abe5b0feaa91a5bcd9dc544a04 ]

It is possible, although unlikely, that an integer overflow will occur
when the result of radeon_get_ib_value() is shifted to the left.

Avoid it by casting one of the operands to larger data type (u64).

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Signed-off-by: Igor Artemiev <Igor.A.Artemiev@mcst.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/r600_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 19c9e86b2aafe..a85470213b27f 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -2104,7 +2104,7 @@ static int r600_packet3_check(struct radeon_cs_parser *p,
 				return -EINVAL;
 			}
 
-			offset = radeon_get_ib_value(p, idx+1) << 8;
+			offset = (u64)radeon_get_ib_value(p, idx+1) << 8;
 			if (offset != track->vgt_strmout_bo_offset[idx_value]) {
 				DRM_ERROR("bad STRMOUT_BASE_UPDATE, bo offset does not match: 0x%llx, 0x%x\n",
 					  offset, track->vgt_strmout_bo_offset[idx_value]);
-- 
2.43.0



