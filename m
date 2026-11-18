Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053861;
	b=oA8DSQWJPdWBYf3MRz6qjv7rEzOj5q/ppBlY/HdFLUPgxVde/jHDRAXk7bDlwCH0xJ9e
	 iAYtmgmq0ZPMaudz41FKIm64Uon4ff2u3JHXSZQ9x2uh56D6iwyKhmXIJCD7c86LkMESH
	 9xzxLv06U6A9V9bkMjozdwKV1bJ0gNuVOp3kiU+Skjxiy29ia8ZNy7WUBvtBwesz3dbRA
	 pSqQCxg441vskwLFbGFKl819GJTO/h6DEPeSbI8w7XAC3sq665xx/Mk8cS1dBnQx51Gj6
	 ub4Wg26xwsnG2OpjzZX6MJA8Z9K1iHZYx//i8zivFBkTYvL9Tcun/5sa6Z14LmY7jWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lSuSFtdcPoZ9f/HSUYFsHRwhawtXf0rT2fYdJRbtdeA=;
	b=NNBrGuRQThlm1I8kyP/XrotEfoKrEzG00OTpVNpx7Ca23ZhZLBxaTvryGQMdmmqLkOfl
	 nJ0wHEJe2ne7qRBU3b4418llgbitBAS8rZ2to1nJbvw1YNFu5SA4TJ7QmHpaNr71ndp8+
	 5023hit3wGp8PXJyiu5Eiqs2lnklM6kRKsT0JZeWlOA4/xrCKDbQxPAcuZPYT8gvRHJO/
	 LeJbrFGCgZWHzlDr0Po078hbJbxzR4O4+hQwQ2WOprriMojy8lOdte9iliehxS0knvwfP
	 aNTFNJo4uP7RABPhJ0g/fkzbVyIVuZDdeAOyV5VBOW/90H2I95geliSfV6S+SI7hW5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lMM8kPsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554F3606A31C;
	Thu, 19 Nov 2026 02:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lMM8kPsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93051F000C4;
	Thu, 19 Nov 2026 02:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053861;
	bh=lSuSFtdcPoZ9f/HSUYFsHRwhawtXf0rT2fYdJRbtdeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMM8kPsf60ui/5N9O8sS/pt1Rl3GfJa+n/gAUWX5iJBh6kiawn2iMqRLHQQBg9BHZ
	 b9thWCb335nj9N6xk0lsAHPpD8AiDhI/CvSyMllcLWux3jmTHbA0mxNnEWr1vU0SZS
	 aJfPJ5geN7UTyI3K8eDNQKM/USdUR7q/AGoL8Ww4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jiang <jiangwang@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1028/2214] drm/amd/display: skip pre-flip post_update on DCE
Date: Wed, 18 Nov 2026 15:45:04 +0100
Message-ID: <20261118150053.459988699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Jiang <jiangwang@kylinos.cn>

The v5.15.119 backport of the dc_update_planes_and_stream series
(commit 3c1aa91b37f9 "drm/amd/display: Add wrapper to call planes and
stream update", upstream commit 81f743a08f3b) made
update_planes_and_stream_adapter() call
dc_post_update_surfaces_to_stream() before every UPDATE_TYPE_FAST flip.

In mainline that series was merged in the same cycle as commit
32953485c558 ("drm/amd/display: Do not update DRR while BW optimizations
pending"), which restructured dc_post_update_surfaces_to_stream() so
that disable_plane()/optimize_bandwidth() only run on DCN, retaining the
legacy behaviour for DCE.  That companion commit was never backported to
5.15.y, so on DCE every desktop flip now runs disable_plane() for each
unused pipe - an ATOM enable_disp_power_gating VBIOS call each - plus
optimize_bandwidth() immediately before the new surface address is
programmed.

On Carrizo (DCE 11) this occasionally wedges the active pipe: the
surface update stays GRPH_SURFACE_UPDATE_PENDING set forever and is
never taken, GRPH_PFLIP never fires, drm_atomic_helper_wait_for_flip_done()
times out and the desktop freezes.  When it hits the first desktop
commit after boot, the pipe scans out zero data, which shows as a green
screen on YCbCr 4:4:4 HDMI outputs (black on RGB/DP).  A VT switch
recovers because the full modeset reprograms the front end.  Wedging
boots also show "atombios stuck in loop" in the EnableDispPowerGating
table and smu8 message timeouts.  Later modesets can deadlock in
dce_mi_free_dmif().

This is the same class of regression that commit 62e5a7e2333a
("drm/amd/display: Fix surface optimization regression on Carrizo")
fixed for the previous call site in dc_commit_updates_for_stream(),
which the new adapter path bypasses.  Mainline is not affected (DCE is
guarded inside dc_post_update_surfaces_to_stream(), later cleaned up by
commit 9571dbaf98c8); 6.1.y, 6.6.y and 6.12.y all carry the guard.
Only 5.15.y is missing it.

Restrict the pre-update call to DCN, matching mainline behaviour.  The
full mainline rework does not backport cleanly; this is the minimal
equivalent for 5.15.y.

Tested on LENOVO 90K7S04400/3141 (Carrizo, Wani [1002:9874], DCE 11,
BIOS M25KT37A): without this patch the wedge reproduces within minutes
of desktop use on 5.15.120 and later; with it (and on v5.15.110 which
predates the series) it does not reproduce.

Fixes: 3c1aa91b37f9 ("drm/amd/display: Add wrapper to call planes and stream update")
Signed-off-by: Wang Jiang <jiangwang@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b1fab9ba82963..91799bdb83ef8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -376,7 +376,8 @@ static inline bool update_planes_and_stream_adapter(struct dc *dc,
 	/*
 	 * Previous frame finished and HW is ready for optimization.
 	 */
-	if (update_type == UPDATE_TYPE_FAST)
+	if (update_type == UPDATE_TYPE_FAST &&
+	    dc->ctx->dce_version >= DCE_VERSION_MAX)
 		dc_post_update_surfaces_to_stream(dc);
 
 	return dc_update_planes_and_stream(dc,
-- 
2.53.0



