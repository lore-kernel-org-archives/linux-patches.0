Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0F81DEFF4;
	Wed,  6 Nov 2024 12:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895410; cv=none; b=SJ206bHQ44jdL6mBEVqwzUOTBSuPsZWRJf5llAgO3hlcEOdx0Q/OfmldPWVHOkANdro5L2i6X35p3Xm+s+AjKzqmqItMT+r3pnqLmojuG6BqcjStf7XkPnsBh1KcIaaJTSCS2HLfvWwHiIbmo7qZUYjNuJaBSrxYCKAqpJCmEZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895410; c=relaxed/simple;
	bh=7du+VC+lDPuc5kbxizYn7IPi025HijwnWPDt38Mdwuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly5YucPb0VV/eoUq/y9XafdgSkRLecaqEGv5turc7h7pqqt8i9TWMNo9qxEVWRrRtHvwQ6cnBPaCuFc6gCZwg3JGqmVDbXHj3ZBY+j4SHROc4C5sus4GfCQuXa6xa+lbs87E8WzHX7sGdHdxs+EOPyfLpwEgllzZ2JctJDdmynw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Z267HcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Z267HcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF4BC4CECD;
	Wed,  6 Nov 2024 12:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895409;
	bh=7du+VC+lDPuc5kbxizYn7IPi025HijwnWPDt38Mdwuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Z267HcT+ExSW3MLrmmnoA/6TGk8FYO0Zb+hWFh/KoNnieBDFx7c1Tn3uXJwIpVLZ
	 Flc1P7ta/VczO8z/0qzF2gtvIdi9rb5EsBL1twdLn6LAzVuVLhKUdsz+Rl9gSnsMh2
	 Xiz46O6EX6p1c1b3eeAIAEeVCc5sUaUsrn8Vzcqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/350] drm/amd/display: Check stream before comparing them
Date: Wed,  6 Nov 2024 13:01:40 +0100
Message-ID: <20241106120325.177332558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 35ff747c86767937ee1e0ca987545b7eed7a0810 ]

[WHAT & HOW]
amdgpu_dm can pass a null stream to dc_is_stream_unchanged. It is
necessary to check for null before dereferencing them.

This fixes 1 FORWARD_NULL issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 8b4337794d1ef..18ebbbf67f230 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1569,6 +1569,8 @@ static bool are_stream_backends_same(
 bool dc_is_stream_unchanged(
 	struct dc_stream_state *old_stream, struct dc_stream_state *stream)
 {
+	if (!old_stream || !stream)
+		return false;
 
 	if (!are_stream_backends_same(old_stream, stream))
 		return false;
-- 
2.43.0



