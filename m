Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EDD38A712;
	Tue, 10 Mar 2026 11:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142116; cv=none; b=Cfi8N/J8zkQa498DrWG+fWQO4QXLDlKnFuNrpvjLv1iCZMjsfluhRISspFXmodGwqdZ6gE4OpEugI+7K2HSB0BDqOPYEqpFfZp1hzoW/OEBzZRfSPEzfsYVr0yEnZgfKEDG0vnfLtoCNd23Yi05VdQRqG/X0IwcyI384Iz4NFAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142116; c=relaxed/simple;
	bh=XqceXG1jBO/Glu/GWF8N0srAbVTh3ESW50L1th2EcIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgbW0JeYZ008Y+0svxIrhvebmJGwhH5lxe54nwBXu9k5DKHXqHMFWaaeBqLv1GRCBMREpHlvzoPrjb7LFP99ZxayQSJvEzYGRE99ygXT3cJMrxPCM90srNnuKwk2/hZlDLZESVGMNYVt2No8q0ZY9ojt2PI/WhBrn7rehjow6cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESy0Wh4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESy0Wh4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F1AC2BC86;
	Tue, 10 Mar 2026 11:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142116;
	bh=XqceXG1jBO/Glu/GWF8N0srAbVTh3ESW50L1th2EcIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESy0Wh4pgCo7O+V9Au8ZKzTxN236PkA5EfZVGcfzOXIHsWkwuwkNjb1p2SI+LQCfe
	 VUmWt07LBHIF5syPKB0K6PBmhagflMI16uzLty7x6wGSuP9evTZvSVwlfzqKCuUd2Q
	 mEUsRSuL+N9vhjwOkEdz36BMpRVxR4xv0DRkCtAiLKy3f9NvRMdDHv4wTY7MkEt/OP
	 goojcWPbwKCtlrIVwoTALrhQbRNkq7u7hO18H8LG6gzRJrpVeo8D66H7SxgCcilJ25
	 AI7NFhrgK3ZBJp7+LnPmha615jQw2xr+VGzH+comTEcieJ29SaCcGjSao4kAtF5hcq
	 3EUeER1e5HwtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 204/314] drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink
Date: Tue, 10 Mar 2026 07:17:43 -0400
Message-ID: <63390c864fae59e9ff49328fb75cd8800d53410f.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Natalie Vock <natalie.vock@gmx.de>

commit 28dfe4317541e57fe52f9a290394cd29c348228b upstream.

This can be called while preemption is disabled, for example by
dcn32_internal_validate_bw which is called with the FPU active.

Fixes "BUG: scheduling while atomic" messages I encounter on my Navi31
machine.

Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b42dae2ebc5c84a68de63ec4ffdfec49362d53f1)
Cc: stable@vger.kernel.org
[ Context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index 0a46e834357a1..0886bef32a5de 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -169,7 +169,7 @@ struct dc_stream_state *dc_create_stream_for_sink(
 	if (sink == NULL)
 		return NULL;
 
-	stream = kzalloc(sizeof(struct dc_stream_state), GFP_KERNEL);
+	stream = kzalloc(sizeof(struct dc_stream_state), GFP_ATOMIC);
 	if (stream == NULL)
 		goto alloc_fail;
 
-- 
2.51.0

