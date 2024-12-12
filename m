Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2847A215710;
	Thu, 12 Dec 2024 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024715; cv=none; b=qAiox3JXPL7llA4QpmYZS1AdPc7FI94Xy8Spyf5+grdPIR+1nSGghfCOMrTNSgwNc3K5sa3Aqz6TMUTW935p4k0sdhvzgPxkQMxOQTEb92PLhfTRmW8HS4uaAcQdXAIx53I96fJh6vnoNDk+JhDG5MwtBLjG1ACqxWt7XWUaU4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024715; c=relaxed/simple;
	bh=B9Z1tD5DxA1zZQNff9+GHReCntR6KT7r8StQ+B7VzvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhByRsEXNh/Gelq5Z4JniJa8VkdZRcDPwtm/9Rh0GiN58pfnc5oQ3KBJrOyMhYgUyGs+dY5SUUpq1f6X8OuZXPmc6j544ObnbYtZYJdLbfcAI1NdNp0seUb+hrFTTyAwrFbrDMTLcbAnZwlNpFhXXLCq8RsnatSMAOPVXeYgnxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vesZRTqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vesZRTqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488A1C4CECE;
	Thu, 12 Dec 2024 17:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024714;
	bh=B9Z1tD5DxA1zZQNff9+GHReCntR6KT7r8StQ+B7VzvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vesZRTqnazMA0MraSdS0fMm+KC0AhGbrOZOoorp9miEjdiK/c8fZGFEW2TnfuEUoc
	 umqvdADhMBAlC2Ll9eOhx7gcAIsGX+zM3jd3pJRgGK0GXmqCd/IzAoo9UzgHuw13rg
	 9zbIpLsE6yyaNTRa2PQYDAO5CQuq4O/gIuLed6Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 388/459] drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()
Date: Thu, 12 Dec 2024 16:02:06 +0100
Message-ID: <20241212144309.097349723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1e6ad9daff534..c738740f8b19e 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -2102,7 +2102,7 @@ static int r600_packet3_check(struct radeon_cs_parser *p,
 				return -EINVAL;
 			}
 
-			offset = radeon_get_ib_value(p, idx+1) << 8;
+			offset = (u64)radeon_get_ib_value(p, idx+1) << 8;
 			if (offset != track->vgt_strmout_bo_offset[idx_value]) {
 				DRM_ERROR("bad STRMOUT_BASE_UPDATE, bo offset does not match: 0x%llx, 0x%x\n",
 					  offset, track->vgt_strmout_bo_offset[idx_value]);
-- 
2.43.0



