Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406A522910F;
	Tue, 15 Oct 2024 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998078; cv=none; b=XAXirG3T8xzu6OiaDEFWFOLa056urQJJALo3OHDD/KrEkyzp6TZnyqnmmH+1uWUXPnYf0PRsPNIlN0UWX3hQP+OJJQDII/Xb8WmnRhGAlUHJW3tGwpJGx4MeR8ZjbmltF2peWC8bJ+eayKMKQYl+N3q+8C8QkLFN15mB1N2tqdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998078; c=relaxed/simple;
	bh=xmgE3/mw75i4Q+D5EwHvbEwEqisJhn64T/O9jWZmtRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lzz0R0xdWKr4TzKYs9B8dOMpbLVnY23JPSW5htm7Bxe9j809jA2KORCepROCm9+Pg3o6xUhlOwJEjwgF8fLDvVVxuCo0XhVQaa0I5PHID/6fNq7u00jxyQST+C5SlM9fB39W7KdlEQKtAfLRgNGwBoCh+HvcqmLq97iKlDuyvRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a54tgx/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a54tgx/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0A4C4CEC6;
	Tue, 15 Oct 2024 13:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998077;
	bh=xmgE3/mw75i4Q+D5EwHvbEwEqisJhn64T/O9jWZmtRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a54tgx/37W43ro97LouvUG114MQMPGoz4CzHYpY9NzAN51dfO5kfvVwafSjMCle5p
	 zlTx6LGHlkVH25HcxpZcdNG2Sb+9dAy6LpUV1w0RoZY/Q32ov5TqoqSPaQ8NPYX0Uh
	 yxa0+mqWEfO/MNFGaSTAFoDOBoQUk4ztaivQO3Y0=
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
Subject: [PATCH 5.10 341/518] drm/amd/display: Check stream before comparing them
Date: Tue, 15 Oct 2024 14:44:05 +0200
Message-ID: <20241015123930.132333439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0a13c06eea447..3af9591baa767 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1697,6 +1697,8 @@ static bool are_stream_backends_same(
 bool dc_is_stream_unchanged(
 	struct dc_stream_state *old_stream, struct dc_stream_state *stream)
 {
+	if (!old_stream || !stream)
+		return false;
 
 	if (!are_stream_backends_same(old_stream, stream))
 		return false;
-- 
2.43.0



