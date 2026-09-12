Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AF630DEA6;
	Sat, 12 Sep 2026 16:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228825; cv=none; b=JTJaIqEwjt+awJETQiOrKiMdc+mNi3ClqmTk/JjIvAmxv9IKUHAJUU/hLM8BLJ8rd7p6fGA+xfRsvd6EKEiWzWsVek8hKPklUi3IWsUhvBDcDR4U5onJMSVFcsUJ3OoXTYBer9d+bakdryX8595jX8sPieabHOE3rJt3h0G7O58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228825; c=relaxed/simple;
	bh=hD5KxNaroYL88ukJeNOYP0eYrtwC3Ej8wdtkPBMOlVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUAf/Caf6676wE/Qg/Q7/HBO16X467G7unSNC+Rw2aunhzb1zRZnQjS0Bn+XD3gtA4ucuoO7eCf/LbtFLNS3hndhFeAauXHpfJo6RxAAQU9gaOZ5658FW09xOugD21lokGMSL05/qClsMAMboD2+I/l5o4TyBJG9/1kiYW/yILY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2kbXsVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2kbXsVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1559D1F000FF;
	Sat, 12 Sep 2026 16:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228824;
	bh=hhwAy094qKYn9G2HMtOGbwNlpOTajgnsxpJZnsC7rpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2kbXsVLREPp68ZHBKrGQE8ae0fELqODCY9VaChSrY0SqRonE5shNf2dMjDYTs79W
	 70WW/APBlWQvJXABUF+SPBpsY/G0+fP8jDzMkWZUGtTRg/UaPkHpfhQHNerOocsT9U
	 MwT8EUWIFA7GQ4JBw+RhYXCU3LVnoxQy0ciJ75EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0421/1191] drm/amd/display: avoid divide-by-zero in __is_lut_linear()
Date: Sat, 12 Sep 2026 08:52:29 +0200
Message-ID: <20260912065557.697241555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -118,6 +118,12 @@ static bool __is_lut_linear(const struct
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


