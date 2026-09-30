Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0338350B8DA;
	Wed, 30 Sep 2026 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782501; cv=none; b=KYV7XhYWLdGfc8l0rEsG7UiDx6uUfxjKRnW8WivnWPUSZictCpycqiVxuofyV4q/vj+tW87XhZ3iTlkcnIY5m/dYJrHl6qXGvVeYinKF7qf/6apn6B5ms5tXU8uVUvDLJ1Ze062ASmq6EF52LVLtihEUDLqZZX7nfkR4fxWAbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782501; c=relaxed/simple;
	bh=jUVI2jF5LnyyPBEVxRXmd6NVuVVeOhyv+8bfD6uqBo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jez08eugTvSQj/JwhZLC41AWAksN6zJ0EYcwPcKdWLjt+FziS0o9iAy+hg8cZrc8KLBJr4/l6jaD+0pB9nzBIKHaulfGsZSXr1un7QV3rZgWr0zg0fnTb7FmIz1i5wIUNPtH1t3Q9gNVKiFaU3uxU5/Gu9cEU9WNgUSw6vgby5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRM68Cuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRM68Cuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9C31F0089C;
	Wed, 30 Sep 2026 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782496;
	bh=Hu5UICBhPOCl6pJhTylFmx4N0HYxDXPj7AoUhO+IouY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRM68CujTNsw7hyS9PJKemspshA9In1/nrzA8watsx80G+9+Cp5CaObhNPZiZdur3
	 Hl1KSihu/2rbCsrArI8w6SV7GdduT8hRkbCPYQJ9J7QQ9tPEGJg8h2fULb6Anc5wNw
	 BJDbYwk0QIdLBmsDNa6GSklgMoaIsx+qfJGJga/o=
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
Subject: [PATCH 5.10 022/595] drm/amd/display: Fix CRC open failure during active rendering
Date: Wed, 30 Sep 2026 17:18:35 +0200
Message-ID: <20260930152348.202548003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 04c20ce6e94df..2658339ad8cc8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -176,8 +176,13 @@ int amdgpu_dm_crtc_set_crc_source(struct drm_crtc *crtc, const char *src_name)
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



