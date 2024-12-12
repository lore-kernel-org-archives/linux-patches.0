Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CD72054EF;
	Thu, 12 Dec 2024 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023296; cv=none; b=ZFxXruTAhfCF+0uvn9Qd7TDO4Su80gUBdNYfnwE/r/VXvgo2jwaRwjfQ1W4b1w+rUTSsZHW5GqgWW98+3ZRzN22384ZV2MN8X6DIyTjQ71shpx7hpJKfk7Gl2zyMWV08S6s3++jt/AG3XeiaRxo2CgoBke/p6Vk2TwN+p1RzfDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023296; c=relaxed/simple;
	bh=6Kz0+8u21vt17u6qyhZnWZ3tt2HMj4S/zDdnQ5uoFeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGun6T866Fg1gdLhuSkeM/+KnsH0SRriDvIDxps6+CfvfwX3U35JeX5IZ4MR0HUrZ98TTAPAlW5GIno+ZGVovIvZ4txqkEemkiRn/IDOcr5maJdkMtjqxFHqAwNjXqspT1RUqfxpjQrvQ3eXPLpCKjipvGBwoIuU1JrOPplUnhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQFdYCc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQFdYCc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AA5C4CECE;
	Thu, 12 Dec 2024 17:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023295;
	bh=6Kz0+8u21vt17u6qyhZnWZ3tt2HMj4S/zDdnQ5uoFeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQFdYCc+lACo+qr55Qtsma9JRODXNHdxo3bYhnVlopyrhg66zXh/Uf5SHg7TaZ1m2
	 WuCCTJ1/3kRO8bNvGuxM/L0C1szCj35o3kKPTENCk6/iw8K+hStQdotSlznULEyNuU
	 uw4yctYLhpGaPLGXMT8nE1wNVUYZ9iQTvo2W6DFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 480/565] drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()
Date: Thu, 12 Dec 2024 16:01:15 +0100
Message-ID: <20241212144330.728116486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 6ade5dd470d5f..7fe2c49854987 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -2106,7 +2106,7 @@ static int r600_packet3_check(struct radeon_cs_parser *p,
 				return -EINVAL;
 			}
 
-			offset = radeon_get_ib_value(p, idx+1) << 8;
+			offset = (u64)radeon_get_ib_value(p, idx+1) << 8;
 			if (offset != track->vgt_strmout_bo_offset[idx_value]) {
 				DRM_ERROR("bad STRMOUT_BASE_UPDATE, bo offset does not match: 0x%llx, 0x%x\n",
 					  offset, track->vgt_strmout_bo_offset[idx_value]);
-- 
2.43.0



