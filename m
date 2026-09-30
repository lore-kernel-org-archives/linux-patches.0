Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5DF501F28;
	Wed, 30 Sep 2026 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784100; cv=none; b=DJjGsRpTYqQSqB5jvYIZaPTrc+EMYpSCevs3nE3oW4IwohBZTbxwitkTeicXk8bddlWKzs+XIraGc/Eh9rIJ3zvgotfIIw/32P74jg8+NlJwJOxtuxRaFFWaZFj6cwpOKZ+4wwqr7qnzctmtKLAXv+cwAxmpGHXf4j+78tIaQco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784100; c=relaxed/simple;
	bh=ni9snUYdHoqQDYrusMdAlF6eGT3O7jHh49Cnz0hGhUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+lTIpLKcG7YV+VOuMI2hui/xIb55zT/FVkc3jfhmaF25Uc9cC4OTsxLLeIodd3iUNANyBrthAc+s9phgOSqhcpnisSCqeCCpe9BvSwYpJl+ekDR+GVh0KnyV+aLH9/vVDyWJsFjwmeFUqnxtIYiRWcK58/hMMJqAKyQXtBR7eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWVw7HWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWVw7HWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82411F00893;
	Wed, 30 Sep 2026 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784094;
	bh=rf3HYMBd6GRVmrWgeWk/REL+jcs6QlLkzekrmDyFEvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GWVw7HWDc5gGD5V+FeLJHz9MIrfRAm/hdgFW0Rlfe6pOAw9I7ACLWgqpAUWvR3vAy
	 HWfntSNptg4qfkmHwqac3aPwjJAsLsiV2PChEdmU2SsKAe0p7cLRzdP2qXuv3cf/BZ
	 WwZZG67wXXnotSzGHEYNz63FU7MPF9cunHs2bTCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Wu <ray.wu@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	James Lin <pinglei.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/982] drm/amd/display: Fix CRC open failure during active rendering
Date: Wed, 30 Sep 2026 17:12:51 +0200
Message-ID: <20260930152417.549150019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit 5eb2fdafeb6f4a442643b77a21a4c9e70586a146 ]

[Why]
Opening the CRC data file during active rendering can fail with -EINVAL.
The wait for commit->hw_done returns remaining jiffies on success, but
the CRC path was treating that as an error.

[How]
Handle wait_for_completion_interruptible_timeout() correctly:
positive return as success, 0 as timeout, and negative as error.

Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: James Lin <pinglei.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
index 8a441a22c46ec..0c17877a6c5c8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -261,8 +261,13 @@ int amdgpu_dm_crtc_set_crc_source(struct drm_crtc *crtc, const char *src_name)
 		 */
 		ret = wait_for_completion_interruptible_timeout(
 			&commit->hw_done, 10 * HZ);
-		if (ret)
+		if (ret < 0)
+			goto cleanup;
+
+		if (ret == 0) {
+			ret = -ETIMEDOUT;
 			goto cleanup;
+		}
 	}
 
 	enable = amdgpu_dm_is_valid_crc_source(source);
-- 
2.53.0



