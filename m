Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBE31E0B84;
	Wed,  6 Nov 2024 13:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898542; cv=none; b=Dk7WzQnyf58oyykPXDW3roC/7jnHuzfSL8gpQZ2n2Uw6SeeI63bCJyFtHg+Pc7fvONOUzsh0NZP7JwbCGy54c94y+BDWQ6/7INLkvDKqY82H9YqqQG3sJ6iqGFEmzzo3iABq3RI9nqyyk2yRQn8uiVZfC9uZnbitbaxJcVvuPRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898542; c=relaxed/simple;
	bh=WjhvC65vtgyja0bzu5MikGHgiw89ac/I8LMKsBRKnt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Br5tgMyG6o4WNgRL9KTiBJU0O4uwzA1cEjt160dhBO6V9GmQJXKE66n4TBqUcgfVkyWkf6YTBx+a8U7A/ehydCy4sWN3GFZUmKAbLNGnRSOe6HqO2HjJCO05MiuWURNNvKyX91VYRRtEJdZgjrDiPwcN/YNXMR0D47NkOSE/OOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDDVD276; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDDVD276"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA648C4CED3;
	Wed,  6 Nov 2024 13:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898542;
	bh=WjhvC65vtgyja0bzu5MikGHgiw89ac/I8LMKsBRKnt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDDVD276ukp917dtb0Opm//VLuEwEUIdB1xfzHLaSlu/lvtQLACPkJ1UrQEC5Ptp+
	 ywVoIM04TN0yRVnzyBrAJCoNF2MddBOQ7S2Xts92sa40BvVczlgbs1tG/PPJmKoIBG
	 KoE5aYCUH9jlcRbD0UIcVVuGEiadyMr7SjqbxtC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 226/462] drm/amd/display: Check stream before comparing them
Date: Wed,  6 Nov 2024 13:01:59 +0100
Message-ID: <20241106120337.103314286@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 35ff747c86767937ee1e0ca987545b7eed7a0810 ]

[WHAT & HOW]
amdgpu_dm can pass a null stream to dc_is_stream_unchanged. It is
necessary to check for null before dereferencing them.

This fixes 1 FORWARD_NULL issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 2f56684780eb5..b498f2f485820 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1542,6 +1542,8 @@ static bool are_stream_backends_same(
 bool dc_is_stream_unchanged(
 	struct dc_stream_state *old_stream, struct dc_stream_state *stream)
 {
+	if (!old_stream || !stream)
+		return false;
 
 	if (!are_stream_backends_same(old_stream, stream))
 		return false;
-- 
2.43.0



