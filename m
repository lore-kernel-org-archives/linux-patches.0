Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF05158201;
	Tue,  9 Jul 2024 11:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524082; cv=none; b=GK5QH+iDjksl1uBngPhWaOiJX/afcvpSomKpBkUKL9mppE0X6WnTYaVHmsxXrgU3ZG+3Dgw5ImBwNNV9H6HrrgK9QRMfEZGTy7Z3HlJfXMAhIYKPHN12ROFYXBiZBrUtIPdpEdJnY2cyf4NoKvSq5+lb5u+Ed0tjm5AieOsAinw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524082; c=relaxed/simple;
	bh=3b8X9k3qACtLYwdXSwgU7Q4kaNIlqHXj2N6cw7k5fGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwezM1MAkC9LswMbQ1PpNRfVlbxHEotMcyAyreAK+CSJkOlN0FDcdzFwr1WynSUn3Wa0RyPbn/npIW5Ns97Wz3ZCTuMXcv0WTUUJIVLYFHHorVL2PxnrqrvhiLdA2RQJdwYCR6otNDEHw0UjDR7hy7N+ZxO//l/u9W6lR721tC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmPpM3eE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmPpM3eE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ED7C3277B;
	Tue,  9 Jul 2024 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524081;
	bh=3b8X9k3qACtLYwdXSwgU7Q4kaNIlqHXj2N6cw7k5fGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmPpM3eEHjD4f9Hb7JTVwelLe78THf8vYa79kFjly16M1AmpSxgqWNzxj1m41rbjA
	 qNb8RaiRvWyPYBb66E1T+ZFDx8p0gPdR4+U5VEIGmln6If4PP6PGE8NraPT39a7otl
	 CI1HXVfd9B7U2NvzHew5biN5WR/3CrtgHKpOMGsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 034/197] drm/amd/display: Do not return negative stream id for array
Date: Tue,  9 Jul 2024 13:08:08 +0200
Message-ID: <20240709110710.240252882@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 3ac31c9a707dd1c7c890b95333182f955e9dcb57 ]

[WHY]
resource_stream_to_stream_idx returns an array index and it return -1
when not found; however, -1 is not a valid array index number.

[HOW]
When this happens, call ASSERT(), and return a zero instead.

This fixes an OVERRUN and an NEGATIVE_RETURNS issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index d0bdfdf270ac9..ab598e1f088cf 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2216,6 +2216,13 @@ static int resource_stream_to_stream_idx(struct dc_state *state,
 			stream_idx = i;
 			break;
 		}
+
+	/* never return negative array index */
+	if (stream_idx == -1) {
+		ASSERT(0);
+		return 0;
+	}
+
 	return stream_idx;
 }
 
-- 
2.43.0



