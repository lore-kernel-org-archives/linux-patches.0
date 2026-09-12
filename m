Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580CD13D53C;
	Sat, 12 Sep 2026 19:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242193; cv=none; b=un9j2KeQ1017+vlkZQN++MoAk51B8VvY9v05blB8ZqSofDRUbeSH8PvLWXdVKViVnTK5SI8tBY9yEYrH9X1dmNFvRQ2N67kWy2Z759xMwNiZm18oxIgSQgHaJowOtctrLnlYmdQrZWaunoTPrbhcpByBmpIpnJXzPE5dCjTJQhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242193; c=relaxed/simple;
	bh=J0JjTqYXn5BtDbZOx9qcF9svgUbYUazarq0SIgKSo5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiW7VsZKwuzD8fK2ND3iHnntCfwQyxb+rchKKCCwtN2G7EGwRe7XAyMVpri0/kVeKVfUaeZU6cA5Ne9B0S0bgdqFCtpx4d+O2GuG3eAHKhfbXpuLtGJ8S7mjncM4YQh4vajixEiEv1vUg4ZKMFrJ8f4OtrKzbq4QOI89UETdrKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leI81us5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leI81us5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11741F000FF;
	Sat, 12 Sep 2026 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242192;
	bh=/ehf71T+xeedqE6e3nDXgvtdlpC87wZBFPNFJmg5B7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leI81us5QPalS47oEjDuXQ/6RTfNivyJjlN7fddI9p68PH4t/EFrr82ExD8lJ4D+T
	 jDnEKogVBnJd7Dgxo7lFfNO1FBibB1QVTYhsb/a6cD+M/qyzsM6INae2YzbDIn48mk
	 aSTvme+542RpZCLjgA7uIf6BkIz5ZAIoQQabHhrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 317/798] drm/amd/display: avoid divide-by-zero in __is_lut_linear()
Date: Sat, 12 Sep 2026 08:59:05 +0200
Message-ID: <20260912065524.425761102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -104,6 +104,12 @@ static bool __is_lut_linear(const struct
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


