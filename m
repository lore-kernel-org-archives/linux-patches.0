Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514F41DED74;
	Tue,  8 Oct 2024 12:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390174; cv=none; b=A8SH+56ZbbEUiz/Y1isyPzV7cAF3B3Ogo+P0PonnwTwK4UXN8TL3tpV05qlnF0q3DSkFRL/f4kA4v7wNSWJ9oG5zEtpd9J3KmuCTcBlEC914uNgEdvCx9X9yX46a/mzE5yjWmZlG09cz10Ea1ktFypERGjDVcNU/y6hoIeUrSvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390174; c=relaxed/simple;
	bh=CVIYPIo3KfdMZCXNbfC3vpCUfqvWWt1hqn/ENp4MoFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGZ0uIqVtqulYOd5Ompa8SdSv0dMfyb7xmOwcYSy4APNf5bbln2ryyFBcmmMWHU4gK5Spfp3pBx5xypi9kQ6v454jL+TggNPc5guh7BDRhjo8pkZgsM+QTLz+EpwmL+R5nXJjeq3cKy9Jc/PryjmVxTwaG3dWYFUZAFR4CeGAqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzDPFVFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzDPFVFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C6DC4CEC7;
	Tue,  8 Oct 2024 12:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390174;
	bh=CVIYPIo3KfdMZCXNbfC3vpCUfqvWWt1hqn/ENp4MoFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzDPFVFBvFL6Fq8x/anGSSFSvElUEUwlGB95XOUUxfH3osi28w7Cb6DM4erz0w0fg
	 WA9carnTz6sjeE6h6W9tm54J1VH9mm9rOJ8bN/vvDwLMWjxIPjUdR9CWKhK7VTDJt3
	 eH5ectfntR1sQEG8u8pk0GLB86KQZflCBFJK3KNs=
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
Subject: [PATCH 6.10 212/482] drm/amd/display: Check stream before comparing them
Date: Tue,  8 Oct 2024 14:04:35 +0200
Message-ID: <20241008115656.654841152@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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
index 7462c34793799..58f6155fecc5a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -3134,6 +3134,8 @@ static bool are_stream_backends_same(
 bool dc_is_stream_unchanged(
 	struct dc_stream_state *old_stream, struct dc_stream_state *stream)
 {
+	if (!old_stream || !stream)
+		return false;
 
 	if (!are_stream_backends_same(old_stream, stream))
 		return false;
-- 
2.43.0



