Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A7535957;
	Mon, 23 Mar 2026 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278759; cv=none; b=VxXatTPU1M9rQhxWS3DJ5g3QraQuAZv+SGuejpdNP5KJJ3RrTmRANPqel9bMcx2TlQnSkwHkMUTKa1OQJ+xhNu94Zbwmz6ntW87bmisogs3c0RiDcWcWsHizsJMC0Kya1zmANxBUaxwPYWeIX+Unzyry8UNjV2J1W62CUdhFFs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278759; c=relaxed/simple;
	bh=SBuRcldFa7m/pSdo9Au6dSFzs3vwMGpbX5ohhyoJHUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAUL3Eo7EZ1bj5BufAf+iuFyG7q2d6FiBLRhIyRL3sZLOv4dGFevFEIXdK/sXmXg/HbAJx3jZNnU0FmlYWKVqyPF8NeEOKA/fwtUC6g+cyWVrfaP8Vt1upRvvM2kxczsFnHvk70uewZiqQf3oYU+iBzCnjrHdERqKojTqv+OUfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtUgDk5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtUgDk5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122CCC4CEF7;
	Mon, 23 Mar 2026 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278759;
	bh=SBuRcldFa7m/pSdo9Au6dSFzs3vwMGpbX5ohhyoJHUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtUgDk5dbFtsvVVWWPELLrrdnt+etN84CoHzrcQgXzOjiv5WFLLuFwaR+5b73Er+f
	 QO6UQofg+PK2Uy9Qt+FuNuyKV17nsOqocKXwlEb/rk5R26w0xbR2XnOCgqNX9d9u3z
	 gK4MBvRWbdxFxqB9DozMO7GORcBvhCAO46N6cyl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 373/567] drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink
Date: Mon, 23 Mar 2026 14:44:53 +0100
Message-ID: <20260323134543.057952822@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
@@ -164,7 +164,7 @@ struct dc_stream_state *dc_create_stream
 	if (sink == NULL)
 		return NULL;
 
-	stream = kzalloc(sizeof(struct dc_stream_state), GFP_KERNEL);
+	stream = kzalloc(sizeof(struct dc_stream_state), GFP_ATOMIC);
 	if (stream == NULL)
 		goto alloc_fail;
 


