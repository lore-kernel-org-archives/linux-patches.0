Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF83A291;
	Fri, 21 Nov 2025 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732421; cv=none; b=nXR94BFynANsY1OOh3OO20IUerBCzwB1NrUElDBTZ9Ep3ye3fv39MnnRmoPRPpA/bEm0/StImi7qHJzw/LnMcL4Gk2VuIEj08qFWQmdp52ixlzrp0uFjjh7oEuUSFBGlTKBIbEtF73i5B1TA8ABpzUxktbjMLAuVhyZ0e583yrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732421; c=relaxed/simple;
	bh=xY8M9XPxDgshxdZXLZgZE6d8mI5zEPQXe8i1PBT0sWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hbe4fCqXMqv+xmCVYyywdcglRnNZ/oIHBjQVehnbfbBtlMSVnIVMmhRynEMZHWKFHZo+sDblHseTfPZpwqFprh3xylIAnNjFQOPTVCh5+WRIUulJx8bpEuuMfrptp0mxP1RnfORc3nTuoUYJSwWSrohAUPRUidKbBeFvk22eXzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5TgE+O9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5TgE+O9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E89C4CEF1;
	Fri, 21 Nov 2025 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732421;
	bh=xY8M9XPxDgshxdZXLZgZE6d8mI5zEPQXe8i1PBT0sWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5TgE+O9ev3pic+TAcoSCqwwF0x3X3mZ+y/XCUFWCAzRXBXAV/fuRQnKvTO/YxL5b
	 MahKDjE5KFfvanKCB2i9Rj2bAK6bp9BfV6A0eDqiy6F9nfecOwSJGfHWwlUrNtgVXL
	 WhvGEgXCnv/b8pUbKS+ZROC8zJR2g0gLzNhN2GyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Clay King <clayking@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/529] drm/amd/display: ensure committing streams is seamless
Date: Fri, 21 Nov 2025 14:06:54 +0100
Message-ID: <20251121130235.116389535@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Clay King <clayking@amd.com>

[ Upstream commit ca74cc428f2b9d0170c56b473dbcfd7fa01daf2d ]

[Why]
When transitioning between topologies such as multi-display to single
display ODM 2:1, pipes might not be freed before use.

[How]
In dc_commit_streams, commit an additional, minimal transition if
original transition is not seamless to ensure pipes are freed.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Clay King <clayking@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 640d010b52bec..eb71721dfb715 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2068,6 +2068,18 @@ enum dc_status dc_commit_streams(struct dc *dc,
 		goto fail;
 	}
 
+	/*
+	 * If not already seamless, make transition seamless by inserting intermediate minimal transition
+	 */
+	if (dc->hwss.is_pipe_topology_transition_seamless &&
+			!dc->hwss.is_pipe_topology_transition_seamless(dc, dc->current_state, context)) {
+		res = commit_minimal_transition_state(dc, context);
+		if (res != DC_OK) {
+			BREAK_TO_DEBUGGER();
+			goto fail;
+		}
+	}
+
 	res = dc_commit_state_no_check(dc, context);
 
 	for (i = 0; i < stream_count; i++) {
-- 
2.51.0



