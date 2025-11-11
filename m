Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C017D248F6A;
	Tue, 11 Nov 2025 01:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823108; cv=none; b=SIYKnrJtp4ManDA8fwq+qb/wduk15wpRRq2BEWnsojNihYCou+2SmhDpiBOmnr5gTXN1d/Su9BDggoyuw5DgPnAvppt6HXTyvrKXR8HSpavC/DCwyjQvPdJGCpajWCidpxq9YKYeXpZkhEsp8utIH+PZBVl3mYTt/piydTb63Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823108; c=relaxed/simple;
	bh=asCV9lEZjK5pDHWDwa69hnRQwPLpN6TuToUo3/sVF0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qgi1SKXuTwKjbXrkNBH3JTtdiY0yHsG3lcg120S0OYSd6+MzmD9wb8IJgY0pFjWaF63mVKc+cv4twDiFR07ED8kWMs4TLommjqQ/ZJy10jNpzeA9PaRQ/ppzATkSQV50h/7Smc7ClfFmIXD+LsN2tBx0ARQBYd5IGpwtOSt88/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNO1dBle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNO1dBle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49563C19421;
	Tue, 11 Nov 2025 01:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823108;
	bh=asCV9lEZjK5pDHWDwa69hnRQwPLpN6TuToUo3/sVF0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNO1dBle3ml0uMIovIRX4B83RZqu1XNzYOAc0tKdBAR2egP5CwCiJVnLD5oIoda3y
	 7HjHSIkQpKuTgZrDoDGZPynnmtZPi7gPdhWfRbiGliW/xDgfIfpkN/Ue1EMgqAMQ9B
	 vmdHZ19JenX6pr14hRMAKJekgYM6qM1XQ5OPMjOc=
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
Subject: [PATCH 6.12 173/565] drm/amd/display: ensure committing streams is seamless
Date: Tue, 11 Nov 2025 09:40:29 +0900
Message-ID: <20251111004530.827229913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 13d5f0451fecf..bdcbebd5722d4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2182,6 +2182,18 @@ enum dc_status dc_commit_streams(struct dc *dc, struct dc_commit_streams_params
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
 
 	for (i = 0; i < params->stream_count; i++) {
-- 
2.51.0



