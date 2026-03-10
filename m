Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66274352C4F;
	Tue, 10 Mar 2026 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141175; cv=none; b=cAFPvL5Bj8vovjlVIfOjNpTkWN0SpfLKCVIs90NUkifqew3Ihuc6KluTZdDRXX9404An0gBRubJcHmuSwh5tmpclYh5kkoplFhfKVeFMNVSAnDB4ZJg3m9zvv4id5JspQohQkFuh0hlS1EtqwWOBSx5tZPCC6vG5rw7e7nobYfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141175; c=relaxed/simple;
	bh=9UK7dz07PrhNtjc5epb+b30YnCg1o7r/5mC67hL8OFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMBcel+YSciJ+uTlVCROjst3J1uqM/YK+oZB5OJRKz2zFX20GjH8Tles8hE+trGbrLCYO5KSVBOOQvzYGg5/YVGYMHzq8daZYAnK2/+/GPl14xw+/oOFXabHqQKDxv/E7sT+p8tmV0ZO4zWJgW1DlmHnKV5tsc9xDm2yI1SCTcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbXTR1je; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbXTR1je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D212C2BC86;
	Tue, 10 Mar 2026 11:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141175;
	bh=9UK7dz07PrhNtjc5epb+b30YnCg1o7r/5mC67hL8OFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbXTR1jeV2x+I7r5Mnx+AMBviBbjyOe+1GkbrTB/1wuDaZbyDYJqu1DY68xc4JNp7
	 jAplqoR891nI8jIb0aHFcP1XxvMO004jgBpZadeKr+QBGz0si7J448Z3kB9mx9nOFh
	 rgZP5T/TdfGyytF8kLW/wU/ZNAbnWuTBlqnm6qApC3T3V2/37/zqGyS2roQ+z45Za0
	 Uydhhas/q7LE596kk5fwfeYhuj2bPWat0/BoPZkM/NFBuQ+raPNRoVLkxli8cGmOws
	 6sW0+xzh9ZL9wI0UZhP0tUAnAryp5ftz+BJwKiLNClv5YPhe+E/7YpgnmcPZaPmR+d
	 61Tt/y04PdNRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 176/311] drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink
Date: Tue, 10 Mar 2026 07:03:43 -0400
Message-ID: <f697495a22e454d4f8a653f41c659fc9414e6367.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 129cd5f849837..da44c1f01bef1 100644
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

