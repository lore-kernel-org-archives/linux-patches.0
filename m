Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499602358A6;
	Thu, 12 Dec 2024 16:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021153; cv=none; b=lsay3CxsrFSQRYq8V4WC9gRxIjO18js0VypLAumGcQ4HPxkoYkp5J32LsNbsHs9/ubxGERBih2PtFS7jkM3Ni0ZkDvnLE4VVIwwC0jWVbF2xaYOB6sHYFmDnL2SpEDMXmRVbvFDrZjAOuqA/fraTr8NGGbym/ZZudjb+Jksus1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021153; c=relaxed/simple;
	bh=+NaXVwwVA/Lfwt+J6MguqT24pm0rqiJngAysW0OqDl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osIIrLxCK8l/Qnh4lwt+WFLcQoxc3rZmybwvKn6eu9bvho25pnDSG/D1cBWkGHJtZNHL/XXHkXxVVz9YLUClyI85Y/z5xArZ+Z4bcBuBxLj4yESnIgM6csf8cJ7MQSg/UtMmg3w9bMnaPJfb1uPb6k9Nhy2P8bQLmmQWvuEBPxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lj7WH1kP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lj7WH1kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B72C4CEF5;
	Thu, 12 Dec 2024 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021153;
	bh=+NaXVwwVA/Lfwt+J6MguqT24pm0rqiJngAysW0OqDl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lj7WH1kPQ6FxsL6pXy8yFCEoylaIzaXPWJhYAViqwLQlpS0xmggzA5XDV6vye5oS4
	 PwEcrNTfXZaabJnLHW96vlelCY1f4Ea14NyGoBN1d8RrhCWh0r/36x9WycPkVBsdeR
	 QnCCGxeMs1twYXeJ5RLcb0DYfkSRLg8nKBRwmE+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Artemiev <Igor.A.Artemiev@mcst.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 660/772] drm/radeon/r600_cs: Fix possible int overflow in r600_packet3_check()
Date: Thu, 12 Dec 2024 16:00:05 +0100
Message-ID: <20241212144417.193447494@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6cf54a747749d..780352f794e91 100644
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



