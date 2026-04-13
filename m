Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53643168EF;
	Mon, 13 Apr 2026 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098990; cv=none; b=WEA7G7qCgizRGlGVx7gTWOLc2dgnVRyN5BkkDdaroJ4rl3PIlPmlpEPIEpd3weiKEz6NLOMiR6kH4cJvASO03h8geqDMITORV8Pw8bE8YUMeIe1hkLKS3lUfndyAXj6sPyceljqYpyf76ytpKaBUvVcQBOzm00HoOvaANRlRPvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098990; c=relaxed/simple;
	bh=U3C5BovV19G7Md03wGzAzD/QjWoxj+KV2+v0pXyqv7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wlthfn1zCqtpOWApS1Lcsvs5gZt+gzetUtE29pHUSB2PLTSRXVFoj6ORx0D6RR0O4QuJXHCTm9xvYTzqGt9ZCuyN9CEb1SfALi6eStBY18EqSQIu+dDDCFD0Mci8S7p+3yrSFFc8ZzPVCSzwZgsM9cUakM9kYhIfuRYn11lSLr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZ4Okxlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZ4Okxlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7C1C2BCAF;
	Mon, 13 Apr 2026 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098990;
	bh=U3C5BovV19G7Md03wGzAzD/QjWoxj+KV2+v0pXyqv7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZ4OkxlmP5YDY9Jfpcsg8OqKRoUMMvAo0WPd4NQWmWlTfdufN9MxjL13COMqRURNQ
	 KDuWuwuY0ST8p1lGGDksCmDzt5UcsHYvJjRBAjQfFZyPIMyv/uaAcqMx0rrrPd0Z3q
	 neiGZ5JjCtqiG3FL8X3QZqTwqsv3n76TZUG/u3HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/491] drm/amd/display: Use GFP_ATOMIC in dc_create_stream_for_sink
Date: Mon, 13 Apr 2026 17:56:52 +0200
Message-ID: <20260413155825.293224481@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


