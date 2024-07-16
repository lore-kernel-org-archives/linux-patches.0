Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9926A1DDCE;
	Tue, 16 Jul 2024 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145950; cv=none; b=QO33u9WJtcHVnuol9bvcCVqc4EYp4kzlXL+3FolRlUALzKcdROVycWFWdL+YNh3QVDtTiJO57r8UCNIGrlVspqdMt3rFntEPRDDRtxDcVYqXehcEbkzAmOSGMljlOuzrc/e/Vp1eW+NN7J47VRt6SrXWh0iq2g1x+eMbMSsfQiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145950; c=relaxed/simple;
	bh=HXRPvZ1mxKdujYM5KjL0rkKQ/yP6scu9Kf7n3o2G6kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASYAuQ+rKGpPcFAPIDV+RnzMpEconoKgYFu7V1yWuMnigLOlAUib1mDa5Hrvtl6e+xWzwT5ucWlb++8N6L1ySPpi9cAHLEMmqV/L1hh/5Kwt4xIS7y7IJ0L2wnybiGY/F3AkIrGFUzCQqwulda3xp+VexBmyCLg7JsjoGcUTgyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3VqhDK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3VqhDK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4F0C116B1;
	Tue, 16 Jul 2024 16:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145950;
	bh=HXRPvZ1mxKdujYM5KjL0rkKQ/yP6scu9Kf7n3o2G6kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3VqhDK9B93l6A/MWbc97QsujalrC+8x+l2JT+dLT1vWgxTi8U8NJMBzvFUB+HpNb
	 hQZO/xnjP0JBAhH5Ip3keiR8Yct0VRGSu3ZwwZ7gncr9aphHsjUtpsScjcBvwxB13o
	 Q3NXxREtcF88UKyag4msG9wYJiJg1QqtYg4ERQ4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/144] drm/amd/display: Skip finding free audio for unknown engine_id
Date: Tue, 16 Jul 2024 17:31:20 +0200
Message-ID: <20240716152752.966294330@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

[ Upstream commit 1357b2165d9ad94faa4c4a20d5e2ce29c2ff29c3 ]

[WHY]
ENGINE_ID_UNKNOWN = -1 and can not be used as an array index. Plus, it
also means it is uninitialized and does not need free audio.

[HOW]
Skip and return NULL.

This fixes 2 OVERRUN issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index fa4d671b5b2cc..42432af34db29 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1728,6 +1728,9 @@ static struct audio *find_first_free_audio(
 {
 	int i, available_audio_count;
 
+	if (id == ENGINE_ID_UNKNOWN)
+		return NULL;
+
 	available_audio_count = pool->audio_count;
 
 	for (i = 0; i < available_audio_count; i++) {
-- 
2.43.0



