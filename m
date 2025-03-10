Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F74718DB24;
	Mon, 10 Mar 2025 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628418; cv=none; b=pnGS3+vKfTscAJAvEl9DWSH3gbChHwno/fHwG83F48ie2igEyewM7e1LaUSorRcvawzBtQkyk1xRiI5nT+c6LqWoXgZGuVCgKO3w8xhBc9n6SqF4WLALvDw/gp4XKqWW/jDl19fWrGSzl306sqNP7jhp0UE22WBDgT3FvsqXMi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628418; c=relaxed/simple;
	bh=+VTnYKSvKGSEwpXm4LmoLE/1pc3Fh+8cYtdR7L4oBM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKmQzifz46+pH0NZoN8kmGK0sKyl7OkU77JOVUTFdXNPZuk6EmoMBx8C0pT+ZBixb8IoC1DXBq8VWeq71ZNg+1bQ5EOFcK6EaGuHSUYwCbo0PWvEDGM9x6WG/XuDnTQB4qsjE4LSig9Hwwi+H/mKvsqccPH7ba+CoXYtIrlLJcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KngDzQtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KngDzQtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8006C4CEE5;
	Mon, 10 Mar 2025 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628418;
	bh=+VTnYKSvKGSEwpXm4LmoLE/1pc3Fh+8cYtdR7L4oBM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KngDzQtjKVOPcpXT4S5O5qLkR4zOqr3WppuUL1GEIEUbFmzoOtaAMnGWqr7yE/x6s
	 lt0774xCd3auCexrrINBDTpNM2/eezTOlclLhF9QRGYmnZZ3KezI1sfRsNfIygAJad
	 9KXBMrn0cxQHxYn47xO3nBc0vqeaLk2/mVd4S4sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Richard Thier <u9vata@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 020/109] drm/radeon: Fix rs400_gpu_init for ATI mobility radeon Xpress 200M
Date: Mon, 10 Mar 2025 18:06:04 +0100
Message-ID: <20250310170428.355245389@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -359,7 +359,8 @@ int r300_mc_wait_for_idle(struct radeon_
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


