Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D1015821A;
	Tue,  9 Jul 2024 11:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524073; cv=none; b=QPe9GpqzT9EAy0MCqm4DHWoG2R2SIenmoMO5HMHS72k4CawuHMsu9tyxVxaIAmnO4SX62WErIx3InnC122fZRpI9HyQazzhWqvYVxWSO1/zaeJ8iOoNOdgJVZ1nt0fHxgjElufuqjYo9ZDcVUl3YsPCsXMe/K9M+1aXo3aDS4k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524073; c=relaxed/simple;
	bh=WFEJgfxnNTU27cOSHWmFIxjT/tJezfuQs+l7DQ2x1oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCOdozGBb07vN7hoWhg0fFvFbSdXV/Sus2J6+B3FB2BG074s2q7ZAYKQRYuF2Tbz1dN8m1K3j1VT8mRsiQP90dgmPVzS333Z+mQkvfk7Ar0iVoxFyrBLlXGAAwoRtU6rdyo3FR4rkqGmN50RGgJbIcDq/cvMTZHEeAORRP+FCqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iplsRiAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iplsRiAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936A6C3277B;
	Tue,  9 Jul 2024 11:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524073;
	bh=WFEJgfxnNTU27cOSHWmFIxjT/tJezfuQs+l7DQ2x1oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iplsRiAsWDSu5864CExLZnmLlimkTwmm0lhgBuNlmYZW+RA6XKiiTMxrIHQzFyHnH
	 XrXoJK+KkqR9XYn4fk0xhmI0I7a6UGnPlC/kevSilDo6yeK1Jp75jhvyAoYv7pniIB
	 miuUcG54xaDv9ZNInWZxHmG+TPce3sJj2K8yYKFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 031/197] drm/amd/display: Skip finding free audio for unknown engine_id
Date: Tue,  9 Jul 2024 13:08:05 +0200
Message-ID: <20240709110710.122919527@linuxfoundation.org>
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
index ec4bf9432bdb1..37a8e530cc951 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -3117,6 +3117,9 @@ static struct audio *find_first_free_audio(
 {
 	int i, available_audio_count;
 
+	if (id == ENGINE_ID_UNKNOWN)
+		return NULL;
+
 	available_audio_count = pool->audio_count;
 
 	for (i = 0; i < available_audio_count; i++) {
-- 
2.43.0



