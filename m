Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5556E4E80B5;
	Tue, 13 Oct 2026 12:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894957; cv=none; b=qIxOUhZ31URAPS1a0ELDn4kt+1H2rXwgT8VcJOaGPTNkyIVAgEMySngNnsFjcOgCUIJTvAXBv5RcPsxgVt2aX/bNSJ3PbiLR77wbkaNacSGh3rwCTtZnDFw2v3YEjM4w3NEtkn3Uoh8zkMW/fMqIAkS66BE2xWRFyhphiQ+FKGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894957; c=relaxed/simple;
	bh=8x6A4kT2hz+ji9qDFuy7u6nx674DhsRCWUHJmV254HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8g1ryScbm12bYWf8KxIp6ABJylYTFzW3vQye00lJdAEQfZzj92bnOyeqAT+cu2Cd9b+qtMuH297/O2tYV3e3c/ZhRVzVP1nORFAaD5/J0sDBnl/YLNOcQF9JQZ4AVVg+tFtMFnTchRs9IkcI+0ePXYutMJxqkXDd7rcTAgR4ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WORk2Nm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WORk2Nm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4E61F00893;
	Tue, 13 Oct 2026 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894956;
	bh=wZzsGRb5hWTNwqyewZjMuX/jeqM4kek/LfYNzzzTK1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WORk2Nm69K2J2xdD5tSBgz5esa/c65ZDoPetD3c8PKRkDQzr2UxrlMStAUmoEBNvT
	 yo/DZNL5pgdvCgqDvDVTddXNdrxldnM6lljp0xwcQE4mAmaVzjoZ7xNsam1kgGfs3l
	 8U9c3O0bLgRE4FZQ5GQo2F0TvcSE7L2OKNnqygJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 113/497] drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend
Date: Tue, 13 Oct 2026 13:34:40 +0200
Message-ID: <20261013112910.572999137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 015e72cde567d2450e282c2790773463156b2d0a upstream.

dc_state_create_copy() can return NULL on allocation failure.
dm_suspend() only conditionally skips dm_gpureset_toggle_interrupts()
and continues execution, returning success.  dm_resume() then
dereferences the NULL cached_dc_state in link_enc_cfg_copy() and the
following dc_state->stream_count loop, crashing during GPU reset
recovery.

Return -ENOMEM immediately if the copy fails, so the caller aborts
suspend instead of leaving a NULL cached state for resume.

Fixes: 8092aa3ab8f7 ("drm/amd/display: Add null checker before passing variables")
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 84b6d7932fdd2857795a257f9f258562a3cddcab)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3045,9 +3045,14 @@ static int dm_suspend(void *handle)
 		dc_allow_idle_optimizations(adev->dm.dc, false);
 
 		dm->cached_dc_state = dc_state_create_copy(dm->dc->current_state);
+		if (!dm->cached_dc_state) {
+			drm_err(adev_to_drm(adev),
+				"Failed to allocate cached DC state during suspend\n");
+			mutex_unlock(&dm->dc_lock);
+			return -ENOMEM;
+		}
 
-		if (dm->cached_dc_state)
-			dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
+		dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
 
 		amdgpu_dm_commit_zero_streams(dm->dc);
 


