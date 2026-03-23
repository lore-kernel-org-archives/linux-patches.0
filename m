Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711A312CDA5;
	Mon, 23 Mar 2026 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282890; cv=none; b=bnJOXTiB8v7xrUB9Xu3PeJhILHQwfu9vwj/E5rp/5q3cKqfDzxb7P81MLG5SPeQu4Do+PtMiFTqOwbp0M9Oz23LkvG0aURtYP7HR8jbtXoa2ugbXtORsKIfv15mIDpNpmDIsE/22c8ku1SWTKDEmxuMq4oSAktm04dPy6VqpvCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282890; c=relaxed/simple;
	bh=O62EXnr1S+leVGCSh0Tohdlk8I2P/nKu6BMXcatzbkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyn6MXG4v122yrxQWI+nYsXKRTVJ/Sqa5GTGVPzzYwm89+8qs+uJx60bUuN3lYaDdTV935fsh+7BQoGp9Plb4tTiFpT+mO3ASsLrqaybLjHcrh3xAUptJMi2qcgETZ5CSPzpi3NBsBRNU+BXmF94XrMHVH261SvYmQuVqnEXTl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m86UkgWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m86UkgWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FCAC2BC9E;
	Mon, 23 Mar 2026 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282890;
	bh=O62EXnr1S+leVGCSh0Tohdlk8I2P/nKu6BMXcatzbkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m86UkgWHnIyK6Q9IgeJyKOrPw02I5TEGGIqe37241Wu0amIMWuiTuOeJu3snB4V8l
	 aF8UXJvi0T+9AxSnK/rPPAe7+dmkRd+ts+1geFxic7MeO7wGkDmGE7XiL46EF7Ye58
	 lc4V44lg+Sqb2rX87SEcZpaujlIP1anxyAoRAgXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 322/481] drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink
Date: Mon, 23 Mar 2026 14:45:04 +0100
Message-ID: <20260323134532.947312890@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -165,7 +165,7 @@ struct dc_stream_state *dc_create_stream
 	if (sink == NULL)
 		return NULL;
 
-	stream = kzalloc(sizeof(struct dc_stream_state), GFP_KERNEL);
+	stream = kzalloc(sizeof(struct dc_stream_state), GFP_ATOMIC);
 	if (stream == NULL)
 		goto alloc_fail;
 


