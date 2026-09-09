Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C73C56E070;
	Wed,  9 Sep 2026 14:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963007; cv=none; b=knkEAucqkHNvgMHQUfhWtnyL4IXH+46buWCZRHPGCVqxYiqMrW5yzXbawNo90ehnp9mbGnr254uOF8Cp1VJtfWHI4b+O1Iz5NhquJeoPj3O5s5gh1N8WxjwMgwHZzhYAhYgLRjS1YcrpEdWpIv2fS7OCwTH0okUIH/nhMhmGCXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963007; c=relaxed/simple;
	bh=xg2722W/00icGIqDBQ1t66Pvbt5R8IYSONNkGNaC3nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdGVS0tpzXat8t6sLLR8Rs82XBdM3o9DLvCVqJ+gmSa92yHw+nnWLroDnytXV5PHHz8FrgZgw11ZXeOwiDUpui8CPMJjeOF21C1DuwijedkCdAhEd/R1g6I7lLoIwM2D++sCTwDsXFRayAgUjZRG06c7Q4durjPMCDlkfKxMdeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxAnRp7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxAnRp7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4901F00A3A;
	Wed,  9 Sep 2026 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963006;
	bh=Uxpy9D/YF/gd9xnytYI5Nkbfq918Dnnq+n4KLm9wzrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxAnRp7+urSQXF4gWWl1fICNNo1MBYOH/J4889mAVhpRVqhPh4wdeCjFInrK34kxq
	 YICEI0vnGvc90b8bpXwsUDe839nMhfd6ei7Ebc7Ik315Q7qv8GXrRyA0nKa1rH1HyN
	 E5rYIU7j4thoA9aMDAlloRiAJmplkRsyRtu+20eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 488/556] drm/amd/display: avoid divide-by-zero in __is_lut_linear()
Date: Wed,  9 Sep 2026 15:42:48 +0200
Message-ID: <20260909134247.665729599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -470,6 +470,12 @@ bool __is_lut_linear(const struct drm_co
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


