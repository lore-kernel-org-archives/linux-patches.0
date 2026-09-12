Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED630376A18;
	Sat, 12 Sep 2026 11:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214150; cv=none; b=hg7O51N1xKcc18MuV3YtNkJjMw4lvx5c+qR9OC9pQTeq2RzVxZA1PU2PLHMtqQGicqNyEWdA9XAMgkghjfKXUCT36CD90Ws6tmJGRQKuTwGSWf6TlW2L7lkQh1Pptnr6cWPX25pgZlVjhCnN3yjNPhvkGWqAfP5tTipZmzgK52o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214150; c=relaxed/simple;
	bh=OVvPMMSHnVInhIzsC+wFhjrdKzo/04HRjSPCedctwo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGCZDtz34Mqun34S7+RFJt0I+N7/Lsb/01aP7v0FfiZbjgeUzrSnBsP3nTlIJdPjN5EMc7H8Bnjf1DRDUHOuG//PsATpTiomjKgHEj/zYb20QvRtz9N0MIHRbKjbkMwv8A8gVjR5Hr6H67mqnhfZcP0d3fxk4AOm01t1QEAVHZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okS3Mo1M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okS3Mo1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77CF1F000FF;
	Sat, 12 Sep 2026 11:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214148;
	bh=3aGBvpnkCRuJEwbxGDvn1ppVmakcqySQJsycnm5UmmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okS3Mo1Mj4M68EjaQPB+BW7Ljt2hqYIaWWD6WTKOCajurQDpBO8atCiNI895Pc5X5
	 SxbfdrDiyX62HYJANXzbmd6S9z3ZYh+XiT0PPn+SisCtLLvyyKv12Ys5VaUy3a7jXu
	 PATuwq6684l1i+490NPjuz5bpB77B+9pmLi9ZgPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 0268/1376] drm/amd/display: avoid divide-by-zero in __is_lut_linear()
Date: Sat, 12 Sep 2026 08:44:54 +0200
Message-ID: <20260912065613.517569198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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


