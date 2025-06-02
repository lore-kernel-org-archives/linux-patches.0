Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D1821CA1E;
	Mon,  2 Jun 2025 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873774; cv=none; b=EQmXizQ2PB4JFxBzcCmhzp2ScBKMrNv6kEeUDYtUqf81RdE3lDlTS0TXB91lFhYK9ANlG/TottH/GjZRqQ4xhns9gXOvjNVJO+4zMjNIn3EbgbK6AQPC/RAxyQbgEJoKDeb8lJsoKyRMjfemOC2HSiiwjhMh3m9QYvmf0YLt80g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873774; c=relaxed/simple;
	bh=KVCWJ5tRbVnZ4zEnwtgEdn/jw5AiZtMTMT9HEeqp8H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJtBIKW48tygWLeba2/9HBfyGKc3iwJDYuEhxmXtECJw4pvkME3OQLnzk80pSArI9cn6g+/ZC4y3t/79LCvJcOqgCioWsZjwy0UxdfGzVQAwRcpJWwBGykJGbqSFNXHeRn43d78Hr4EjnusOlJeVY/sxe83E4JM6lGKp5bU1Gd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0BJr/LE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0BJr/LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A5EC4CEEB;
	Mon,  2 Jun 2025 14:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873774;
	bh=KVCWJ5tRbVnZ4zEnwtgEdn/jw5AiZtMTMT9HEeqp8H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0BJr/LE+8wK1nvefWae22lG6fHjZ/7bGxE4aWsyjZOkSIZO/FNYn4t5oFdiwah51
	 DDCTL2LFNHUr9wqETYw/Bin/F6Nwn46DDA3hrWX/93/V/x3t08WnoL34DnQCGdIB/F
	 exI2egAMHS8yhnFHsTAyVPsEBP2JM2zYS0/q7LTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Joshua Aberback <joshua.aberback@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/444] drm/amd/display: Increase block_sequence array size
Date: Mon,  2 Jun 2025 15:45:12 +0200
Message-ID: <20250602134350.982512803@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Aberback <joshua.aberback@amd.com>

[ Upstream commit 3a7810c212bcf2f722671dadf4b23ff70a7d23ee ]

[Why]
It's possible to generate more than 50 steps in hwss_build_fast_sequence,
for example with a 6-pipe asic where all pipes are in one MPC chain. This
overflows the block_sequence buffer and corrupts block_sequence_steps,
causing a crash.

[How]
Expand block_sequence to 100 items. A naive upper bound on the possible
number of steps for a 6-pipe asic, ignoring the potential for steps to be
mutually exclusive, is 91 with current code, therefore 100 is sufficient.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Joshua Aberback <joshua.aberback@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/inc/core_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index eaad1260bfd18..4b284ce669ae5 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -532,7 +532,7 @@ struct dc_state {
 	 */
 	struct bw_context bw_ctx;
 
-	struct block_sequence block_sequence[50];
+	struct block_sequence block_sequence[100];
 	unsigned int block_sequence_steps;
 	struct dc_dmub_cmd dc_dmub_cmd[10];
 	unsigned int dmub_cmd_count;
-- 
2.39.5



