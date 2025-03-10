Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5654C1A7264;
	Mon, 10 Mar 2025 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627964; cv=none; b=irsE2X+8PkRMMGTCnBSUaTHTv2uvg8lWXlnSzR7E0EM+uBhc/iFx48dJ4SDbFtFFGCSxGzLqBWohMyLL8ZWgUgEnFyIUTzgcdRA9Qdg9e8PC1sB0GwWVkcL1C3V/ElpvmMtMX7VzBHtfu11sXY5teeX9vMr/lChNJJZnIcflWgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627964; c=relaxed/simple;
	bh=QSJqXEUJXVeqai6DUnTNFCuXfFavGtIiYc48KkmXvtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bIkgGY/JVEHsrbe/hJD1wdL+8dFq9Jp+qFyVB+iCYL88S5Xu5aVSx8ClRRpmzV0UHS+akwTPf6nwUuVZSi7j+sApXq/yAgKFRk6haVtq629Vc/xX/JU03+K7rzjKYiHPL+lm7HDJ8IQmmeFTsXw4ZIt41s2/80ics47HOogs9c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7+Se5/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7+Se5/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0580C4CEE5;
	Mon, 10 Mar 2025 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627964;
	bh=QSJqXEUJXVeqai6DUnTNFCuXfFavGtIiYc48KkmXvtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7+Se5/q0cFhl4JBWFdrHU4/+8FjLLV2jMW6gpYGJ9Q1KAe/uQ/5bGM6NtzMYDeHC
	 4S9Otbw7IjWM0nm2PIWpmXSEO8HLHlGufmFkbyGAAqaYeg7zj/U6Dp8MV/+A6LaL/f
	 2eD/TxF5gzK7eRSeY2pOSjQ2qEaN4PHTn1t3sKr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Richard Thier <u9vata@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 041/145] drm/radeon: Fix rs400_gpu_init for ATI mobility radeon Xpress 200M
Date: Mon, 10 Mar 2025 18:05:35 +0100
Message-ID: <20250310170436.395542603@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Thier <u9vata@gmail.com>

commit 29ffeb73b216ce3eff10229eb077cf9b7812119d upstream.

num_gb_pipes was set to a wrong value using r420_pipe_config

This have lead to HyperZ glitches on fast Z clearing.

Closes: https://bugs.freedesktop.org/show_bug.cgi?id=110897
Reviewed-by: Marek Olšák <marek.olsak@amd.com>
Signed-off-by: Richard Thier <u9vata@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 044e59a85c4d84e3c8d004c486e5c479640563a6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/r300.c        |    3 ++-
 drivers/gpu/drm/radeon/radeon_asic.h |    1 +
 drivers/gpu/drm/radeon/rs400.c       |   18 ++++++++++++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -358,7 +358,8 @@ int r300_mc_wait_for_idle(struct radeon_
 	return -1;
 }
 
-static void r300_gpu_init(struct radeon_device *rdev)
+/* rs400_gpu_init also calls this! */
+void r300_gpu_init(struct radeon_device *rdev)
 {
 	uint32_t gb_tile_config, tmp;
 
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -165,6 +165,7 @@ void r200_set_safe_registers(struct rade
  */
 extern int r300_init(struct radeon_device *rdev);
 extern void r300_fini(struct radeon_device *rdev);
+extern void r300_gpu_init(struct radeon_device *rdev);
 extern int r300_suspend(struct radeon_device *rdev);
 extern int r300_resume(struct radeon_device *rdev);
 extern int r300_asic_reset(struct radeon_device *rdev, bool hard);
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -255,8 +255,22 @@ int rs400_mc_wait_for_idle(struct radeon
 
 static void rs400_gpu_init(struct radeon_device *rdev)
 {
-	/* FIXME: is this correct ? */
-	r420_pipes_init(rdev);
+	/* Earlier code was calling r420_pipes_init and then
+	 * rs400_mc_wait_for_idle(rdev). The problem is that
+	 * at least on my Mobility Radeon Xpress 200M RC410 card
+	 * that ends up in this code path ends up num_gb_pipes == 3
+	 * while the card seems to have only one pipe. With the
+	 * r420 pipe initialization method.
+	 *
+	 * Problems shown up as HyperZ glitches, see:
+	 * https://bugs.freedesktop.org/show_bug.cgi?id=110897
+	 *
+	 * Delegating initialization to r300 code seems to work
+	 * and results in proper pipe numbers. The rs400 cards
+	 * are said to be not r400, but r300 kind of cards.
+	 */
+	r300_gpu_init(rdev);
+
 	if (rs400_mc_wait_for_idle(rdev)) {
 		pr_warn("rs400: Failed to wait MC idle while programming pipes. Bad things might happen. %08x\n",
 			RREG32(RADEON_MC_STATUS));


