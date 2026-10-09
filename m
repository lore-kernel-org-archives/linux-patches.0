Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0438D33EB01;
	Fri,  9 Oct 2026 14:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555907; cv=none; b=IOiF/tCjGq7hsLzvpLFJuKTVGEdmUi8Mhqqz4wM9B+Li9N+yq3sVHd2MkrhzTnRx+0yu75TdXOp52jtpRvlYm60J3Fsim4xHzmGCHMsnDU3nLxOdZXQpoebR03fDGdX1cUywckulMS4m4XfCdkGtCNtMa/uneSix2ZmTtNfVFkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555907; c=relaxed/simple;
	bh=QIrVZMczagBTvof5i0vLEiBsxfC4p/oi6Uy6k2pAimc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqY+rTaA6SdRzsr5MHiw/XX7RCQqLxQzR8DTz0wOAZgiWjaiReIT28+/E9Pq+m0yYsn0Xd6+K/gcat2KmnFPHDXGaxgOFgXpdsrd01gvDPY+HG2ONPvTV9UP2wS2vguxWh34K36Df5K1eDZg43PkJq+36wvx32Ye2zHZrhH+51M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGj0naQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGj0naQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A311F00893;
	Fri,  9 Oct 2026 14:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555905;
	bh=94IVVBRCBM9wnFYVXTxcJVhGq84Fw85ZTeyFKxYjF80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGj0naQ9n1eAcMnyUgmWafUANOIQUMSAqJbB0t1H2mIjcdXmm7Xm2n+Mtf4Pb4/Ug
	 hQN9V0xVdbYaRHuDg4Bfz21iH2uz22zj+S0qmOdDLi48YvREqB14oROk7uoq4p1cNF
	 AGaG2dubO84G3rfY/CPd8J5w72s9eoJa8FqwM02A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 137/403] drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend
Date: Fri,  9 Oct 2026 16:08:18 +0200
Message-ID: <20261009140955.278411041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3266,9 +3266,14 @@ static int dm_suspend(struct amdgpu_ip_b
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
 
 		res = amdgpu_dm_commit_zero_streams(dm->dc);
 		if (res != DC_OK) {


