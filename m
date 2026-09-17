Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC0051B19F;
	Thu, 17 Sep 2026 17:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667368; cv=none; b=SQfxI3U5S7PLrv0uyG8hUxNdbcm6NM8uWIryFNQMAwmTkuP6chznas6AvUUkJ5hyQFgt9CIOENlRDCXfeXy37J7TUdblbkwtl0ZfTPGQVGxcUOx6IzdRW/QHhvE7G2FmcecD9AAwVwNbMsm+u1sVTWovnwCexWp8CNkvlWqrn7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667368; c=relaxed/simple;
	bh=k7vtdzgaPV4IYblh7T72bcz7RtgZmyPl4Oexn9nDgww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xqv4NXEn0tM/V6IQxpcZmUs5MUDmcC77TxPx7cV1U5tJ1eLbnc+oJHhaFUstgDX0Iq5G8Mbd9pk70AE2dQmWzaO8KvXTRgeBlwmrv0t3OPmqZG44DD9yS50255UL54+CMcJlvh8X7fOYZcdfjCBeY9Lf/rZ4bBq//1YjFtWHNyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsnx5dF7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsnx5dF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8F31F000FF;
	Thu, 17 Sep 2026 17:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667366;
	bh=j02nGPZiK9O6FeyZOQejnUr9L8D3WR8aivNhX/r/A7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsnx5dF7Drxbavh/5WD5MS9rn9FuN2jTl2LicQ14PfDMWBxIqLdJl4zWSdko1Zy7I
	 HWjBEK28gvv3/ynVJcKh5V3FBHNNSIJV9+bcySgqr1CfqGf1Q+a4FAnvxrokscoju6
	 CqX7cY2MRi8ZbTMW++eXu6TvLdVXEFQBWM29U3qk=
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
Subject: [PATCH 6.12 0069/1102] drm/amd/display: Fix CRC open failure during active rendering
Date: Thu, 17 Sep 2026 16:00:12 +0100
Message-ID: <20260917151541.196095382@linuxfoundation.org>
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
index 0f6ba7b1575d0..41812081418e3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -296,8 +296,13 @@ int amdgpu_dm_crtc_set_crc_source(struct drm_crtc *crtc, const char *src_name)
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



