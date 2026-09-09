Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D6557F724;
	Wed,  9 Sep 2026 14:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964322; cv=none; b=AANOoGOk3/pgw7bHC9E1bBlBls8jInMpCF8Es71QP87Fy8607mPeaEAEqYEEt1Tq2uoI5Z61MJe5uOe361vnsNnbhjzPrPVt8+PtTPDR+GzOUS7mrcKxHuwbjRs+e6Z90D+0fThhWQTxyrV97/1HQfgnEAd62udEHSGOD6U+2x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964322; c=relaxed/simple;
	bh=+kmX9dQUWgxdeSA5Cnb/apbqdgHFMTWfmBa1vuM7Cz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmAIa81HgE3uF8ghQtWTFRd/k+gJgef+YaKnvoOe/W82dibVW4s6GLdrR9oqnbyTOljX8Z8eAcfejIbgDnJbwd9tDul+YObHQsX5mVSqumC8Fyvn1McuSgIzldvAvLfRKfCw6hnqxgG0S80UKpiA/o7C3+NmZgmnObEPEymVKOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V76rZzXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V76rZzXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFDC1F00A3E;
	Wed,  9 Sep 2026 14:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964321;
	bh=cCyPyccSHg20X38IuHYV+f3ACkB1wCTwQjgMGQ1O2wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V76rZzXc+vMwxPKY293w7bu7VgMx2BK12dw4s9OcD7iQl+ZiVdKwk3VfF4NdiBO36
	 AUBbVD8GptskD0gFy6n2ZrCctmF/QIsN+5xvJxsoYYS5U2lpmkar1IiwTK37ZNjeUj
	 CKkIxzlJxR4MjYv8myhdAy0pRJxiGrfAWtTyTDQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 383/583] drm/amd/display: avoid divide-by-zero in __is_lut_linear()
Date: Wed,  9 Sep 2026 15:41:08 +0200
Message-ID: <20260909134251.271435922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit 4f40873f8a4107df2b9c8e68c947c4fd0cd519d2 upstream.

__is_lut_linear() computes the expected value of each entry with

	expected = i * MAX_DRM_LUT_VALUE / (size - 1);

If it is ever called with a single-entry LUT, size - 1 is zero and the
kernel takes a divide error (#DE). A LUT with fewer than two entries
cannot describe a linear mapping anyway, so return false early instead
of dividing by zero.

Fixes: 086247a4b2fb ("drm/amd/display: Use 4096 lut entries")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
@@ -360,6 +360,12 @@ static bool __is_lut_linear(const struct
 	uint32_t expected;
 	int delta;
 
+	/* A LUT with fewer than two entries can't be interpolated and would
+	 * divide by zero below (size - 1); it can't be treated as linear.
+	 */
+	if (size < 2)
+		return false;
+
 	for (i = 0; i < size; i++) {
 		/* All color values should equal */
 		if ((lut[i].red != lut[i].green) || (lut[i].green != lut[i].blue))


