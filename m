Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A312AF0E;
	Thu, 12 Dec 2024 15:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016858; cv=none; b=o3qD4CuoOg4LinxmQFfg51BQ/HpueuC7X70c3/RPU5B6zkbgZyYp+2vniwWcC8Zb4iqW00Tdny3Zg3leHPwUOhAwgCYUXpOT35lrZE4X7j27z1uabePfo0AwWtB/HgPdfaJ295MBuR/GFd8At5+ds22iutXpr4NTpFObvtwQhoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016858; c=relaxed/simple;
	bh=3FGnKoXK0tpP80XL9ZjSqt+KA2n6+svViAvJ0AW9ED8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6dI6nMtj0Isw38CceruJec0XhQw18CBkqANpP5Ew6xneEuTs7AmLi4pS1IhJew1uqItD/Hbss0NaNT7/XwJCe7dN5RJxSB3iCSSswbv5XVcXYIxYXFAK780kY1EJ4iQDC1EDr1g2B6PBCMpcEE2AdJi5ieN8RU4qMB4o/IaIYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIcbz8Qk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIcbz8Qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A809AC4CECE;
	Thu, 12 Dec 2024 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016858;
	bh=3FGnKoXK0tpP80XL9ZjSqt+KA2n6+svViAvJ0AW9ED8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIcbz8QkCaxCap9rFYDKzrGB+03ry2FoABHn2hvQlJR9wRjsI4tS57mE1JsIehaUH
	 L/A/IGBJcJt9Ns6ny+lfcRDJn73CCUH9IL/D9L25luDVKNHAaPjy4HElB4CrMo2re9
	 +buGufcJ8uDVWfbL9U1JG43vtsPabB2sZnWF/HuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Leo Ma <hanghong.ma@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/466] drm/amd/display: Fix underflow when playing 8K video in full screen mode
Date: Thu, 12 Dec 2024 15:58:05 +0100
Message-ID: <20241212144319.283571146@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Ma <hanghong.ma@amd.com>

[ Upstream commit 4007f07a47de4a277f4760cac3aed1b31d973eea ]

[Why&How]
Flickering observed while playing 8k HEVC-10 bit video in full screen
mode with black border. We didn't support this case for subvp.
Make change to the existing check to disable subvp for this corner case.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Leo Ma <hanghong.ma@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
index 4d6cf856cc96c..8dee0d397e032 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.c
@@ -882,7 +882,7 @@ static void populate_dml21_plane_config_from_plane_state(struct dml2_context *dm
 	plane->immediate_flip = plane_state->flip_immediate;
 
 	plane->composition.rect_out_height_spans_vactive =
-		plane_state->dst_rect.height >= stream->timing.v_addressable &&
+		plane_state->dst_rect.height >= stream->src.height &&
 		stream->dst.height >= stream->timing.v_addressable;
 }
 
-- 
2.43.0



