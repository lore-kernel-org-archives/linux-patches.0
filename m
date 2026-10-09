Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC2F2AF1D;
	Fri,  9 Oct 2026 14:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556408; cv=none; b=OZEvx2H5a0doVgsaiE4pKJVnEBGhDNaGBwdnXiEeoZFH3Fe03UZx4J+LIe717dTbaoAkkQmQbDpw0DnBAWBWrL25GQnERGETfBUO4Nh7MbtWN1AJFNg7GrO8XMjjpAvWNdfT+E9N7MLk9uZXFqWbPv3Bz/m6QEtiln87hBehMRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556408; c=relaxed/simple;
	bh=HhcpPzF+sMvenAru6C0XwOT76Fz/PMQWcEom2tVs0Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgsI663YRJbCudhLJdAXKc18/L89e83ZfLNjmBW82ZF9CrHqpvnhF5DlhqVvDhNVlgM33d93PSYHOFE3vcoJSXYL9ET39oi//Pi2fpygUFkbmFS8xX7PzL07g/2iX9UPJXf6eO/YnCMtsgK7vTowiR7j8/VYs5HAb+5t8CIZink=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0r/mJ4q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0r/mJ4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EF21F000FF;
	Fri,  9 Oct 2026 14:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556407;
	bh=LxuLAk6I7M/y3xp2eT51IX9CpxPrfWWzq5y7YI1Oqys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0r/mJ4qCIbMigJVvlug2M7IVHnQO0M6BZRmnLf7/yIn0YuCYwUaFshXWoNETUZHf
	 nrFc/ztReyY51K1o7nIDuGjQ43Ni4akAanYBFQOwKdrt92VxfwTrsTsInqm3DjTetN
	 naJ40EM/LKkDcYgVB3OJAxAcrxxQMJMERaDsQvPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 171/428] drm/amd/display: Fix fast updates on DCE 6.x
Date: Fri,  9 Oct 2026 16:08:28 +0200
Message-ID: <20261009140949.910497311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 88427119e1f039c8cdffd63726c136a986ef519f upstream.

DCE6 should use legacy fast updates, just like all DCE8 - DCN2.
Set that flag for DCE 6.0, 6.1 and 6.4 (all DCE6 versions).

Technically DCE6 should have been included when the fast update
code was refactored, but it just happened to work until now.

A recent commit "Attach only plane updates that actually changed"
has exposed this issue because with that commit, DC accidentally
took the new fast update code path for DCE6 as well, which caused
it to boot into a black screen with a flip done timeout.

This fix should be backported to all kernel versions that
have "Refactor fast update to use new HWSS build sequence",
but this patch won't apply cleanly to older kernels due to
another refactor in "Remove dc param from check_update".

Fixes: 0baae6246307 ("drm/amd/display: Refactor fast update to use new HWSS build sequence")
Fixes: 9ec11bb842b6 ("drm/amd/display: Remove dc param from check_update")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923122033.1046651-1-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 698fda6e360625850413a2d1a90b72ae5f03073d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c |   12 ++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -448,6 +448,12 @@ static const struct dce_abm_mask abm_mas
 		ABM_MASK_SH_LIST_DCE110(_MASK)
 };
 
+static const struct dc_debug_options debug_defaults = { 0 };
+
+static const struct dc_check_config config_defaults = {
+	.enable_legacy_fast_update = true,
+};
+
 #define CTX  ctx
 #define REG(reg) mm ## reg
 
@@ -937,6 +943,8 @@ static bool dce60_construct(
 	dc->caps.max_cursor_size = 64;
 	dc->caps.dual_link_dvi = true;
 	dc->caps.extended_aux_timeout_support = false;
+	dc->debug = debug_defaults;
+	dc->check_config = config_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
@@ -1134,6 +1142,8 @@ static bool dce61_construct(
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
 	dc->caps.is_apu = true;
+	dc->debug = debug_defaults;
+	dc->check_config = config_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
@@ -1332,6 +1342,8 @@ static bool dce64_construct(
 	dc->caps.i2c_speed_in_khz = 40;
 	dc->caps.max_cursor_size = 64;
 	dc->caps.is_apu = true;
+	dc->debug = debug_defaults;
+	dc->check_config = config_defaults;
 
 	/*************************************************
 	 *  Create resources                             *


