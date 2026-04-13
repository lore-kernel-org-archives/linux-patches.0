Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D12130ACE6;
	Mon, 13 Apr 2026 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097697; cv=none; b=lD6K6q17G7HJ/bS4lUkGH5Tb/+PC1ReQtD2D4wcDqFVfTC6+Lck0T+AA/iYpr3bkyKfLmbVbL4xcuAuk/pVWvguN5o+cXjkPQBI36KGl/hTd+c6bKg1A5MNrPD4SaXsHvv1mgPwEkC1AHu+O2BR6coiWcJfqZWETFWAVf5oNA9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097697; c=relaxed/simple;
	bh=I0JKeJPt6KFiZ9Y1TjErgIjE5lpHPzCI/thof5ycNGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhBAyUPKdzvvfFfCkodx5maJXSSQ0D/6SxG0Du+OEmQaTEVGlRFoUtodqiL/7s1EgyZ/0PZ75CZHwSHcnYSeAFdL4w4sGPehycThXxFH9Au4jm6Z+Du7d1wc5ykhjPx8WEP2b5kekt5P2+TzteK4Uz3Wa/oz4msONjI4LzIIQf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZiOxgW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZiOxgW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C08C2BCAF;
	Mon, 13 Apr 2026 16:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097697;
	bh=I0JKeJPt6KFiZ9Y1TjErgIjE5lpHPzCI/thof5ycNGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZiOxgW3x4eYbC7cyAZ+QhVoqkhyY0nDDndre8kkzH68w8qcln1wczNxqJqKwf0qK
	 1dYjUy0q8raMsk/bgs4AO/6jGjv9r4nAlJTvF1CRrhC28DIp7EAvNYv70wq5DBy7GE
	 Niuh88wPrm0h9d8xxWA2m+wIWlbvpCT662C5TFzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/570] drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink
Date: Mon, 13 Apr 2026 17:56:09 +0200
Message-ID: <20260413155839.382202166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Natalie Vock <natalie.vock@gmx.de>

[ Upstream commit 28dfe4317541e57fe52f9a290394cd29c348228b ]

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
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -167,7 +167,7 @@ struct dc_stream_state *dc_create_stream
 	if (sink == NULL)
 		return NULL;
 
-	stream = kzalloc(sizeof(struct dc_stream_state), GFP_KERNEL);
+	stream = kzalloc(sizeof(struct dc_stream_state), GFP_ATOMIC);
 	if (stream == NULL)
 		goto alloc_fail;
 


