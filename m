Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D709C139D1E;
	Wed,  3 Jul 2024 11:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005318; cv=none; b=eh8iBqylbM38fTJSMwpxBBRDMoLnXNvt5Cdkk0EA+GRhZHxWrr3UmtMthyOPbcbtDEkAWBw8v/W+r+e2x45/sOh1ASy03fpodPHfuC7AtkeLwAJUhomSBCPXbWaK9lwMNtHrMb4aznEibqGy10acYm/vjWsA+ZFdN//BD0Mvv34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005318; c=relaxed/simple;
	bh=+C5FoclgxYAWnFyl5MSEmwazMPulY+rCNX4X4fJDEK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClocyLi+BPEjD+XpDj8E2lxtwbttv6WfDGxBQiTzOpJQinBJD02ZAY8CCNOIzo0TB9P0tv4n0vbtGE02OeL7jM0QkQDiisER9EGMDFdmmHUZmwcI/YWEef2pGwAJ3xHAaKnM5w0QxmJ4jXHx7sxOaArQ6z0vSBx0woiTQyRwyhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGWB5KZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGWB5KZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F35C2BD10;
	Wed,  3 Jul 2024 11:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005318;
	bh=+C5FoclgxYAWnFyl5MSEmwazMPulY+rCNX4X4fJDEK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGWB5KZEjczBcOmpsc0vpVKJ6gyy4po+UYQo0MUipFa0RdpDjnsEwCPpmt4aFkI+P
	 NaQYN0AZnbwgYxbDx2iamULFNECidPz5w550Qkk6SoIJkgMAFiFNU/gtkb+SXmcSDm
	 ST0FY+vWGHHGytWY4EZgebOIq3EklkpT1gKzfgbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Anson Jacob <Anson.Jacob@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/356] drm/amd/display: Handle Y carry-over in VCP X.Y calculation
Date: Wed,  3 Jul 2024 12:36:16 +0200
Message-ID: <20240703102914.612402441@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: George Shen <george.shen@amd.com>

[ Upstream commit 3626a6aebe62ce7067cdc460c0c644e9445386bb ]

[Why/How]
Theoretically rare corner case where ceil(Y) results in rounding
up to an integer. If this happens, the 1 should be carried over to
the X value.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
index cf364ae931386..d0799c426a84d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_stream_encoder.c
@@ -644,6 +644,12 @@ void enc1_stream_encoder_set_throttled_vcp_size(
 				x),
 			26));
 
+	// If y rounds up to integer, carry it over to x.
+	if (y >> 26) {
+		x += 1;
+		y = 0;
+	}
+
 	REG_SET_2(DP_MSE_RATE_CNTL, 0,
 		DP_MSE_RATE_X, x,
 		DP_MSE_RATE_Y, y);
-- 
2.43.0



