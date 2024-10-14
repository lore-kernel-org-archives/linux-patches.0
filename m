Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C741AD9F9;
	Mon, 14 Oct 2024 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919031; cv=none; b=NmOF43aUEUTCkX3te8A3VzvgWRZKTrMbrVyvqp+6xo0s6ro7sK8IxkOiHKINI/Feqxo2IY7+hRVOzYV+uKzCPx1y/6JIgYqURCqucWHR+sPEj0D5PhpS2nU33GTVJZSsiamMn/2/uU+KGgs58MjIWsmMWFtECJorXF4hEOj/KcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919031; c=relaxed/simple;
	bh=yH0LwOTIG2oIltcRxrn2UrOLgTZMd5zD6FuMbJQ1E5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYA6jxlNefrb3EYErCj3TAuS6ufmTCYifwrYER7nRO+B41UnV+Dc5HrZ862dzRERzQc43GUOUmCmYVW1AePkWr/U4WWNHDkQbV0t/WQok/4UbGduw74G/jvCbTDFgNR037fC90w7KE1P2ojANnM117kJi0hZoEV2rggzjWCDD2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHKaiCVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHKaiCVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79722C4CEC3;
	Mon, 14 Oct 2024 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919031;
	bh=yH0LwOTIG2oIltcRxrn2UrOLgTZMd5zD6FuMbJQ1E5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHKaiCVExAgp0xL2tMAA4gusOmFdKFBENTh+t/j2yFHoaxxKI0aJ9DZye8LC3Fpou
	 yod2GmnTnojMhm7jxl4UDIdw6wkF6N652c2Rj0t9wQtWhuSUvhTo1dW37b96vlu8QP
	 cFHS5lx7BN0gOl1x8f08aT+Cy+3FGXUZkLtA4oy8=
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
Subject: [PATCH 6.1 491/798] drm/amd/display: Check stream before comparing them
Date: Mon, 14 Oct 2024 16:17:25 +0200
Message-ID: <20241014141237.260816908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d4ba81f36ded1..8b27fe2f5ab19 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1915,6 +1915,8 @@ static bool are_stream_backends_same(
 bool dc_is_stream_unchanged(
 	struct dc_stream_state *old_stream, struct dc_stream_state *stream)
 {
+	if (!old_stream || !stream)
+		return false;
 
 	if (!are_stream_backends_same(old_stream, stream))
 		return false;
-- 
2.43.0



