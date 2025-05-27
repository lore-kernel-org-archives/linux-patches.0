Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465EF42A9B;
	Tue, 27 May 2025 17:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367782; cv=none; b=QMYSr5dD81MQkQxhYkW80jwrvpQq7MLvDI2KiDthtYHmKRApAfcoMQyxuezPqzq75nqLgPGygWEnNoWo45HB3LMitrak98Kh+b4/06x8pnlFYen25aFJGfWCkKFG5tLVrtsXh8XH843Yonuay3m8cMFhVL53NHmQ5RSgVzyJ7lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367782; c=relaxed/simple;
	bh=FOardvH8DJTVPIlrtKujE+cQ2lKXh97rxUTH9FT3skg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt+5FU6fs/Cw17anDHvlFfom5I6OeyQ6SOL+/PIxU7FgAJE2pNR021hWjlif6lX75hohYqQV3PpNiAOALp98IR/X7pxn6doxuTVVvAUW0SOPfzy68opPsjicnaJrHaltOZnu29L257QwMJjBUvZ514bSJ1KXnoLOfr6lNfL26uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jqq4BnQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jqq4BnQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0437C4CEE9;
	Tue, 27 May 2025 17:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367782;
	bh=FOardvH8DJTVPIlrtKujE+cQ2lKXh97rxUTH9FT3skg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jqq4BnQrx25kidX5tE2koWqEyYqmDOu1pQmXdJY+Mgg5Kb4EeOW3mHXAgVrkN1AIq
	 JiTxfmImFAtekvWEnjRdVJkJrrVXkEGwzhfj1wPBuL31RZ9/SmQCDOjOQCEQH9jgqy
	 sCD/x8vLzapmZPmNNWAbtvWYlYxUSixQONTbyEFw=
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
Subject: [PATCH 6.14 497/783] drm/amd/display: Increase block_sequence array size
Date: Tue, 27 May 2025 18:24:54 +0200
Message-ID: <20250527162533.372419851@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index d558efc6e12f9..652d52040f4e6 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -627,7 +627,7 @@ struct dc_state {
 	 */
 	struct bw_context bw_ctx;
 
-	struct block_sequence block_sequence[50];
+	struct block_sequence block_sequence[100];
 	unsigned int block_sequence_steps;
 	struct dc_dmub_cmd dc_dmub_cmd[10];
 	unsigned int dmub_cmd_count;
-- 
2.39.5



