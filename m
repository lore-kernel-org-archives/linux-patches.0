Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597DFF9E8;
	Tue, 16 Jul 2024 15:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144488; cv=none; b=q17e4O+OaEJh1l5iEXX2YXEepiNSMc/HVyDTasYohPFCBF0D5YDP2je3meXpD2Ih4uRAQ8S/Pk1B85M6T2qWPkBtNq+fCzRHVCeN+La7ZwTjXBrgjljVclh3Hq6ky+iMZ2CavhetTNvWwryaX0cYK659k6fIGu3U6B1qFFmzmZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144488; c=relaxed/simple;
	bh=m2a8+2GJ0L/1/sTQC5zoJAHZHlMQTx8+tjWoCvBvpZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fT8MnVv8G/FsPXuwHrB0/IkYpItXoYzYyGFhvt09707UiaURwgPdcn7X7S0nckie1HZnGmEKZnCLkabxtyxWWz4qfEWbOEdZKrIKwjLLKoCix5tfw8Kkuj90wIujXkcrJbYxI+qGNq7TL+zlv62+ed4kTtxxSVO4olyK3gKkfTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YR+FNn5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YR+FNn5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D6AC116B1;
	Tue, 16 Jul 2024 15:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144488;
	bh=m2a8+2GJ0L/1/sTQC5zoJAHZHlMQTx8+tjWoCvBvpZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YR+FNn5oQl0t4yoOiF1wWzsy8OwL16Kg+DuGmcxv5/zFzFRuOipkeO1VTVsMnLmXd
	 3yi8rqg0fzWIGQ1lNvhK30CzspEImvAzVJxbn8AEChtN7FWZ75fMgZ2GJExNjEH7sX
	 xOp99y1OdJ2dpy1FwZRmK9JnBKOtpaJIf4CpvscI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/108] drm/amd/display: Skip finding free audio for unknown engine_id
Date: Tue, 16 Jul 2024 17:30:25 +0200
Message-ID: <20240716152746.393644181@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f1eda1a6496d4..0a13c06eea447 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1802,6 +1802,9 @@ static struct audio *find_first_free_audio(
 {
 	int i, available_audio_count;
 
+	if (id == ENGINE_ID_UNKNOWN)
+		return NULL;
+
 	available_audio_count = pool->audio_count;
 
 	for (i = 0; i < available_audio_count; i++) {
-- 
2.43.0



