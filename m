Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BF5346FB3;
	Thu, 12 Mar 2026 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346379; cv=none; b=N9Es6QWHGcHpj/DAYk00dpi+1OqjuxUNMdG1Bpsw7cjrgJbj5sfIDNe0Ywal80ImJwNcTG+8r8JwB7T736wU6adwCxQeWqFnVTIgyfacRcMcmf2I17MJaoXd4l5GJzcKoOjvkApJXLxSZjWOM5EzN4yZi9+sZa04ysqPuwJry8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346379; c=relaxed/simple;
	bh=m5AO4KP1TYsq8ZwogUTkD6seq0Yv7J1FOLeCJ+HdztQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2Tis/SbygKwdK4IMT7cSEpC4vpPtu2R6V9qld6xpnlGrA8jA2KgU+CmiSC6zozoUpZVNxDavFr3fCfMT8vTWRDcQHyFiApZur1ZhsEwcdz3Cr/9t39X95kIJcmiPG0Q3VwiVrAxtbBg6munGwYrQBztt+2TAeKZh63S4vFdfF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGq5VrQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGq5VrQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160BAC4CEF7;
	Thu, 12 Mar 2026 20:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346379;
	bh=m5AO4KP1TYsq8ZwogUTkD6seq0Yv7J1FOLeCJ+HdztQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGq5VrQuhmyBw67TtoEhPGhyPoRkFPX1AI/hkI6W+FN2e/2Rst7O17Jx2FkqgYjb6
	 zlvNtePkwkjXaiiH2WWmp5ItrUzM9er721OwIAKZKJW8LV/1fihHhJgl6We/5or6TD
	 0dLceCs4CD+b/EV/6ABWgkYX5+C+G9437wuIwxdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/265] drm/amdgpu: Replace kzalloc + copy_from_user with memdup_user
Date: Thu, 12 Mar 2026 21:06:56 +0100
Message-ID: <20260312201019.238473723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 99eeb8358e6cdb7050bf2956370c15dcceda8c7e ]

Replace kzalloc() followed by copy_from_user() with memdup_user() to
improve and simplify ta_if_load_debugfs_write() and
ta_if_invoke_debugfs_write().

No functional changes intended.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 480ad5f6ead4 ("drm/amdgpu: Fix locking bugs in error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
index 38face981c3e3..6e8aad91bcd30 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -171,13 +171,9 @@ static ssize_t ta_if_load_debugfs_write(struct file *fp, const char *buf, size_t
 
 	copy_pos += sizeof(uint32_t);
 
-	ta_bin = kzalloc(ta_bin_len, GFP_KERNEL);
-	if (!ta_bin)
-		return -ENOMEM;
-	if (copy_from_user((void *)ta_bin, &buf[copy_pos], ta_bin_len)) {
-		ret = -EFAULT;
-		goto err_free_bin;
-	}
+	ta_bin = memdup_user(&buf[copy_pos], ta_bin_len);
+	if (IS_ERR(ta_bin))
+		return PTR_ERR(ta_bin);
 
 	/* Set TA context and functions */
 	set_ta_context_funcs(psp, ta_type, &context);
@@ -327,13 +323,9 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 		return -EFAULT;
 	copy_pos += sizeof(uint32_t);
 
-	shared_buf = kzalloc(shared_buf_len, GFP_KERNEL);
-	if (!shared_buf)
-		return -ENOMEM;
-	if (copy_from_user((void *)shared_buf, &buf[copy_pos], shared_buf_len)) {
-		ret = -EFAULT;
-		goto err_free_shared_buf;
-	}
+	shared_buf = memdup_user(&buf[copy_pos], shared_buf_len);
+	if (IS_ERR(shared_buf))
+		return PTR_ERR(shared_buf);
 
 	set_ta_context_funcs(psp, ta_type, &context);
 
-- 
2.51.0



