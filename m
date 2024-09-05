Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470AC1991B0;
	Thu,  5 Sep 2024 09:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529699; cv=none; b=nhYl2BcDb8mFfEryxeJBQ9MQB2/xFz/8rws8+p2U/hxNYa+JOhrba90hgoVtkAKoF80e9F+hfNj3gyuurOVv5hlmqZVsS3cEiKY9bUySop/ch4D6nGXO0J6GGGaSUMJGR4wVUVzMX4ypGSbVj2d0Co+Q8iet4/Xkl0byrmKYcBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529699; c=relaxed/simple;
	bh=wZb9XL46k4EAL2vtjk0ljwcGrSVaUUzN6hL3A6gc+5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwg0yCFtAtQ83gA/WBi52T24hthW1eyLTHsh1+C/dIvuSUJ3gZb5OqN5rj43j/kmyAKcgzfLhZVE6Bw0RsKdcmZvWiS718ayNzyNFneDGQCglnZTVpyNp8r7DO5fgzc3q1+HC0smzIvsFopUAZ931XbRcrsQJvFWa7/P4AApHF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1/hwrTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1/hwrTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50D9C4CEC3;
	Thu,  5 Sep 2024 09:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529699;
	bh=wZb9XL46k4EAL2vtjk0ljwcGrSVaUUzN6hL3A6gc+5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1/hwrTg7IT/jRlk/z7poo1cqpk95qQsfiVQTUzsLDau9i+KPeGX1m8irqVuYUVkz
	 wtREAaHqc808rTiM4ki9yuMODK/yTR8e1yMEYZO9JUXXbqtqnMA2VGgu5nuM2sPEUB
	 8x0M7WipF3gNCe88+6Pjw8Dw0kk27h7X6BeOLMZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Roman Li <roman.li@amd.com>,
	Nicholas Susanto <nicholas.susanto@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 115/184] drm/amd/display: Fix pipe addition logic in calc_blocks_to_ungate DCN35
Date: Thu,  5 Sep 2024 11:40:28 +0200
Message-ID: <20240905093736.721511564@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Susanto <nicholas.susanto@amd.com>

[ Upstream commit 3aec7a5af4d6248b7462b7d1eb597f06d35f5ee0 ]

[Why]

Missing check for when there is new pipe configuration but both cur_pipe
and new_pipe are both populated causing update_state of DSC for that
instance not being updated correctly.

This causes some display mode changes to cause underflow since DSCCLK
is still gated when the display requires DSC.

[How]

Added another condition in the new pipe addition branch that checks if
there is a new pipe configuration and if it is not the same as cur_pipe.
cur_pipe does not necessarily have to be NULL to go in this branch.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Roman Li <roman.li@amd.com>
Signed-off-by: Nicholas Susanto <nicholas.susanto@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index dcced89c07b3..f829ff82797e 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -1077,7 +1077,8 @@ void dcn35_calc_blocks_to_ungate(struct dc *dc, struct dc_state *context,
 			continue;
 
 		if ((!cur_pipe->plane_state && new_pipe->plane_state) ||
-			(!cur_pipe->stream && new_pipe->stream)) {
+			(!cur_pipe->stream && new_pipe->stream) ||
+			(cur_pipe->stream != new_pipe->stream && new_pipe->stream)) {
 			// New pipe addition
 			for (j = 0; j < PG_HW_PIPE_RESOURCES_NUM_ELEMENT; j++) {
 				if (j == PG_HUBP && new_pipe->plane_res.hubp)
-- 
2.43.0



