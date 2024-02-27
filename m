Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4399C13B2B9;
	Tue, 27 Feb 2024 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042177; cv=none; b=NODOoqXckktttQxQGFVp61wZKUMgLdNgktAe4yjXnk+H6UHeBwkrVj4YJMKgLFiRE/2IQOjyBvy84IhZF9P2NQDfxkujtfg+WkCL2VzTNuLXIqTJ5pW+ryV09G8AxcWE2iF0bBlfbLBpxEvPBtO9ugLyN1lFZD+7qjn5oK4qOGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042177; c=relaxed/simple;
	bh=gJS78PW3o4d4+MUuu/cL+NNLoogLybE5qEBweK76M78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzwnbz06iJs+GPmIFQZG6kYsLE5ZzLweULr6so47qDzHo2pMRLQeugJPgRGvNEqAhhyp4WdOUBUu5ofOwqwUxZEPbHl5MDXXDWydrJaXrfJT3KR91bGNsubmm8rUuqzWxwxSx6jlG0WognNDSqnZzME1bdZj4tb0QnJpcdqyz4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVvFrVWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVvFrVWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F58FC433C7;
	Tue, 27 Feb 2024 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042176;
	bh=gJS78PW3o4d4+MUuu/cL+NNLoogLybE5qEBweK76M78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVvFrVWzt+SNkLk66koZ/R9X+pk3Li/LLSwL/E5eJEb3qWfhkWD9Que+7XOGw9peD
	 QVmldWycoQCc7aI3rAanPuVhWimn8P77ZZP7t87oHAxSkP8B+VAbeLRmgF+CeooVbY
	 S776mCOB1l08zKhvEHFv3jGFwQaCuhvH8YM1heo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 206/299] drm/amd/display: Avoid enum conversion warning
Date: Tue, 27 Feb 2024 14:25:17 +0100
Message-ID: <20240227131632.429653087@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


