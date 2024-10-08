Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12FB1DE894;
	Tue,  8 Oct 2024 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391927; cv=none; b=Lq7YnQ58vSxdy75KkWnAtQ16vdbScBxAQjeKu7faP+esoO66arU87XZdz1qrCcrC+1ak/VUmLI1YGnpqfw3AgTG2ysz5f2ASQydoqFVL1QJ6PnfIa8C+FvsSMA4r12aGOv8DSk5Bkc0nfOh0YNa+J/vuQVOWNm9pjfPz58bK4J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391927; c=relaxed/simple;
	bh=1u+0ttHz+7NDENB79nkC/dtUPm2OA1tYYkVBizwFKtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd1H8pWEyF+wLmw4Lmuh3KjEgu10kTYxAeSF3tfs4cavhHyNx4NGycRdLKmte/I/qg0+LrtgJCJt6BAjPsr+1+7+wovyl3Ut46HHT4tGsg5jYHQjNjtD88TrbGb96SRROGhB6pN2tTQUCYOpWmx4X7T8Oy+mL2rbfk5bQNwp/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZ2mAX0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZ2mAX0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEDBC4CEC7;
	Tue,  8 Oct 2024 12:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391927;
	bh=1u+0ttHz+7NDENB79nkC/dtUPm2OA1tYYkVBizwFKtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZ2mAX0XcSXYgz/y3VINZEhAG2pH/C83eAdmx4Guigmrcv0xn7uir8puWApYhJfl0
	 7kJedBAFKJLagNJATp7jgjX81ftgJQWSkzDluoGyyIyre5z3/sbkoLBoA7GW+/U7dA
	 hWMDd9+ISvkHrAzPqefnwRNYvF+J30elPpqsYbEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 264/558] drm/amd/display: Fix possible overflow in integer multiplication
Date: Tue,  8 Oct 2024 14:04:54 +0200
Message-ID: <20241008115712.721823692@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 3f96f545f877ac59d0c967f52d760b4b2b3b9a47 ]

[WHAT & HOW]
Integer multiplies integer may overflow in context that expects an
expression of unsigned long long (64 bits). This can be fixed by casting
integer to unsigned long long to force 64 bits results.

This fixes 2 OVERFLOW_BEFORE_WIDEN issues reported by Coverity.

Signed-off-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/resource/dcn32/dcn32_resource_helpers.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource_helpers.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource_helpers.c
index 47c8a9fbe7546..f5a4e97c40ced 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource_helpers.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource_helpers.c
@@ -663,7 +663,7 @@ bool dcn32_subvp_drr_admissable(struct dc *dc, struct dc_state *context)
 
 				subvp_disallow |= disallow_subvp_in_active_plus_blank(pipe);
 				refresh_rate = (pipe->stream->timing.pix_clk_100hz * (uint64_t)100 +
-					pipe->stream->timing.v_total * pipe->stream->timing.h_total - (uint64_t)1);
+					pipe->stream->timing.v_total * (unsigned long long)pipe->stream->timing.h_total - (uint64_t)1);
 				refresh_rate = div_u64(refresh_rate, pipe->stream->timing.v_total);
 				refresh_rate = div_u64(refresh_rate, pipe->stream->timing.h_total);
 			}
@@ -724,7 +724,7 @@ bool dcn32_subvp_vblank_admissable(struct dc *dc, struct dc_state *context, int
 
 				subvp_disallow |= disallow_subvp_in_active_plus_blank(pipe);
 				refresh_rate = (pipe->stream->timing.pix_clk_100hz * (uint64_t)100 +
-					pipe->stream->timing.v_total * pipe->stream->timing.h_total - (uint64_t)1);
+					pipe->stream->timing.v_total * (unsigned long long)pipe->stream->timing.h_total - (uint64_t)1);
 				refresh_rate = div_u64(refresh_rate, pipe->stream->timing.v_total);
 				refresh_rate = div_u64(refresh_rate, pipe->stream->timing.h_total);
 			}
-- 
2.43.0



