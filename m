Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF01D1E764A;
	Tue, 15 Oct 2024 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993606; cv=none; b=pGH+eAYxsLx2PvEXaPQ/MTDejd5OrBzk6eVgCA3LE5efhG+PS70n4FeWGkv+J67x8YaDaUiClIRy6tuQwS6ZYpM9vR2UZ1qIwcy/xJ9/8G38DHp+XpSnQJ8gZRhT9ypiVMSn8pVhg6MKKo/uxfMx9IsyiuqkPtgXyeFh70WRatI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993606; c=relaxed/simple;
	bh=uXj8oVATLe8cgaEkUMYmXHAg5sGEobpLLb2O7P5b9zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XivTIjwYRmb+QLf85bx2hQm+l2EFgjmRGKu5RSJrijLE5d9JUfEACj3tsa0/E7+pNrdXos+0qidyiLjo3cZt/43GyGqHiBI8M+TTZYnJEvztbCe9pRQAyUXlGs/cIOrCfE8ReQWlv4v+F+fJffMAhQMUUUMevh8+C7Sp/FlO05o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFRjGddv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFRjGddv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D870AC4CECE;
	Tue, 15 Oct 2024 12:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993605;
	bh=uXj8oVATLe8cgaEkUMYmXHAg5sGEobpLLb2O7P5b9zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFRjGddvQRQsLK26plM/WyI/rFJTe/c0Qwkf+12YnEaVtyw8jveFs5kP2y5IX6LY5
	 xPE9a031qIHmI0Dl+dW7eIfikvOCEB67fWARmQuHVWsVlyiV6EZUwxqab0ZsgBLI/g
	 TggA/JR2cUVQzLAfOMa3SuAA2yXBtTE1TlvMF9uw=
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
Subject: [PATCH 5.15 462/691] drm/amd/display: Check stream before comparing them
Date: Tue, 15 Oct 2024 13:26:50 +0200
Message-ID: <20241015112458.681599815@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 42432af34db29..3d126acaf525e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1623,6 +1623,8 @@ static bool are_stream_backends_same(
 bool dc_is_stream_unchanged(
 	struct dc_stream_state *old_stream, struct dc_stream_state *stream)
 {
+	if (!old_stream || !stream)
+		return false;
 
 	if (!are_stream_backends_same(old_stream, stream))
 		return false;
-- 
2.43.0



