Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C2F1586D0;
	Tue,  9 Jul 2024 11:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523526; cv=none; b=nhT/io0gwA6HhQUd5d8jP9+S8wCE6zp8VNPgFu54eVynFjr+R8iRAREYyZ151Lg8RkdPsn2lUDF+BiOGgv7mYGE4jYBI6rz4Pk5k7z9RXV91U1E62uIxUkIDa0ZN55JSZce3AR9X89IJJfge/KVCBcvv0rIxREhBN1w4uZNGDX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523526; c=relaxed/simple;
	bh=CDuboVZXoYGYxlzQIcIN/w7qtoNKDkmxT/qi/2Ot5fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCjlfOsgbKjN7f6hVGGOAk6ir7oIagGCXSMnCEIEzBONREnfu5tavofYLn7Efd1HZwP0XaNhaqh5GMH0hi6AvTfvfBw/tsoNdW7lTaJ/xzr7hZ7M9EUGSMeDya0dxO6h5H3bFd/xscNfV/lQ5mv59x48Vyn3A8+PDpeyL0K1PVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrR4ZoCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrR4ZoCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791DBC32786;
	Tue,  9 Jul 2024 11:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523525;
	bh=CDuboVZXoYGYxlzQIcIN/w7qtoNKDkmxT/qi/2Ot5fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrR4ZoCZ4GQw10ihM3bViT+Sf/B6AnKV8jXbicQZ62c5jzYenX6Qyp2z9FIuhaqP7
	 QDcFdiNEiZQJXczHBTTyZTgOvhgUK58JkqOYNkyscXjFXcxfJdURFtptd6h5bCg9ha
	 V/C/ChxY4gi8M2pHmJTLEE45oGON/Z4NnfGNGqik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/139] drm/amd/display: Skip finding free audio for unknown engine_id
Date: Tue,  9 Jul 2024 13:08:42 +0200
Message-ID: <20240709110659.021597064@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8873acfe309c8..84923c5400d32 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2385,6 +2385,9 @@ static struct audio *find_first_free_audio(
 {
 	int i, available_audio_count;
 
+	if (id == ENGINE_ID_UNKNOWN)
+		return NULL;
+
 	available_audio_count = pool->audio_count;
 
 	for (i = 0; i < available_audio_count; i++) {
-- 
2.43.0



