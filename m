Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F98A25A62B;
	Tue, 25 Mar 2025 12:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905831; cv=none; b=B4yrt5QMqSOXnyFJWe4XMQnM5/PPrjdwkpBSLFYk63QZ9ImpnCj2w/Krc6gBR0dVKd4uCsPNYEw6dXnvBGdqIhgHwBWZyy3VSWWU21PYAAwsxknjcHhAw2tUxSiys6MvNPLa2iH58s5ZN6rgypU2PzzwSf4isypcEms7X085n7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905831; c=relaxed/simple;
	bh=9WCI+Wyo5oCQXgbvYLel7+AA+hZAW7D15j7CL45xwTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSIEjrdzxllkHB6zj1QU+wMzzAsmfNakcwdXVKTtEEi2do68GCh+xgUi2N2jSJQp1suyBL6Is6zDmNPaJwmBeH7FueeVd4plZurLVUQ6QUQJEstCl9vfsaZiRA7//1DkBiMRrIxWv2j5t1zfG7cYYi6HTVe6hKnbZhGAmbqL5VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmxuob+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmxuob+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449E7C4CEEF;
	Tue, 25 Mar 2025 12:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905831;
	bh=9WCI+Wyo5oCQXgbvYLel7+AA+hZAW7D15j7CL45xwTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmxuob+xo0IjBERAeMLidmtspTVlyBanmFTmxZv3OKE3TtAreo00Wdfia1WgYNiwi
	 b5Op02R/P/UMtkNBDtjeVB5KW2T4D8QxW9K0ZcvW411pDSu3TlTKtB+g1ot9AAID3E
	 xNKsWxwHSPxyiBUlx9ai3lrliH34oksam7XNkaBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 188/198] drm/amd/display: Use HW lock mgr for PSR1 when only one eDP
Date: Tue, 25 Mar 2025 08:22:30 -0400
Message-ID: <20250325122201.581000380@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit acbf16a6ae775b4db86f537448cc466288aa307e upstream.

[WHY]
DMUB locking is important to make sure that registers aren't accessed
while in PSR.  Previously it was enabled but caused a deadlock in
situations with multiple eDP panels.

[HOW]
Detect if multiple eDP panels are in use to decide whether to use
lock. Refactor the function so that the first check is for PSR-SU
and then replay is in use to prevent having to look up number
of eDP panels for those configurations.

Fixes: f245b400a223 ("Revert "drm/amd/display: Use HW lock mgr for PSR1"")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3965
Reviewed-by: ChiaHsuan Chung <chiahsuan.chung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ed569e1279a3045d6b974226c814e071fa0193a6)
Cc: stable@vger.kernel.org
[superm1: Adjust for missing replay support bfeefe6ea5f1,
          Adjust for dc_get_edp_links not being renamed from get_edp_links()]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c
@@ -67,5 +67,17 @@ bool should_use_dmub_lock(struct dc_link
 {
 	if (link->psr_settings.psr_version == DC_PSR_VERSION_SU_1)
 		return true;
+
+	/* only use HW lock for PSR1 on single eDP */
+	if (link->psr_settings.psr_version == DC_PSR_VERSION_1) {
+		struct dc_link *edp_links[MAX_NUM_EDP];
+		int edp_num;
+
+		get_edp_links(link->dc, edp_links, &edp_num);
+
+		if (edp_num == 1)
+			return true;
+	}
+
 	return false;
 }


