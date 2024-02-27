Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C7713B2B3;
	Tue, 27 Feb 2024 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041124; cv=none; b=Du3fFFfXz4ZKDe0ZEq6k1LrJhC562MEDpOXw1PufqaehG7aGegVSZyEOaYtm9DfaLW+EEUDJVBYP5a5Zhp2gdmxV2NYcHQQpvgvrzUj0yx9u8BeuVe1iEey7wDesL2XV5V0CYJzp4nJ9SYwhcIsaHwcXztxmM0pNnUSuq1oGVyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041124; c=relaxed/simple;
	bh=9770UkrV3bupLekcnOiypFP2yMhzfd3+oL5c9lqfnyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5OvKZ/CWfQLlTsYEHGJfWqAOervCQA2jh6WVqStqB5du6aldMNEiil8vjMr3QY4uXsSsnXOrkCh0z4rtt4uzOQ0vnkdIfy4/DDTE+jZlshtFtOLtTTbjT8icMBoCXLuc/m4a5BcyLKsBzpLiVmj17X6EQlaic0AtB/EYc1yBXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hB6M7rDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hB6M7rDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6173C43394;
	Tue, 27 Feb 2024 13:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041124;
	bh=9770UkrV3bupLekcnOiypFP2yMhzfd3+oL5c9lqfnyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hB6M7rDC/fnmZMiFp6zOmF6BAkCQhwTF0lwHh5tgi6MgKU1TuWdAglbp0WB2y50sz
	 3h+0CfdIUrgqu3aEDJ/ckNYR9JJToItLZXLUuLwNhM4g8sY9ILgBTYaBFEGlRcEXv7
	 uzVY+ESj6hNC5JmcrjsudVZyIlovLHIrhNOIKYrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 229/334] drm/amd/display: Avoid enum conversion warning
Date: Tue, 27 Feb 2024 14:21:27 +0100
Message-ID: <20240227131638.194841104@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit d7643fe6fb76edb1f2f1497bf5e8b8f4774b5129 upstream.

Clang warns (or errors with CONFIG_WERROR=y) when performing arithmetic
with different enumerated types, which is usually a bug:

    drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_dpia_bw.c:548:24: error: arithmetic between different enumeration types ('const enum dc_link_rate' and 'const enum dc_lane_count') [-Werror,-Wenum-enum-conversion]
      548 |                         link_cap->link_rate * link_cap->lane_count * LINK_RATE_REF_FREQ_IN_KHZ * 8;
          |                         ~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~
    1 error generated.

In this case, there is not a problem because the enumerated types are
basically treated as '#define' values. Add an explicit cast to an
integral type to silence the warning.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1976
Fixes: 5f3bce13266e ("drm/amd/display: Request usb4 bw for mst streams")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
@@ -544,8 +544,9 @@ int link_dp_dpia_get_dp_overhead_in_dp_t
 		 */
 		const struct dc_link_settings *link_cap =
 			dc_link_get_link_cap(link);
-		uint32_t link_bw_in_kbps =
-			link_cap->link_rate * link_cap->lane_count * LINK_RATE_REF_FREQ_IN_KHZ * 8;
+		uint32_t link_bw_in_kbps = (uint32_t)link_cap->link_rate *
+					   (uint32_t)link_cap->lane_count *
+					   LINK_RATE_REF_FREQ_IN_KHZ * 8;
 		link_mst_overhead = (link_bw_in_kbps / 64) + ((link_bw_in_kbps % 64) ? 1 : 0);
 	}
 


