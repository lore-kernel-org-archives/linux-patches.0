Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6140B641;
	Tue, 16 Jul 2024 15:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144286; cv=none; b=EFQlwieU/I67CRkrYaHwIn539IHoYaOeM1uCvrQ2bbrB0fw+pAoWSoYsV5czahz0c0yRxRl/39ShwIvS1q9cwV4t5MTtWTKlLhODLoxPoMDiS/8pOzz4TmegP2krhW3KDQm4+vQSBl/GMiU9GkOU5B+5mh7hhsGOZKjWTI3cSo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144286; c=relaxed/simple;
	bh=K1HFRG3GNTK0JsCbHxcZxOj/F7KbX6aCeC2/WVYabVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dh137KzCfhQPf6PhniBoKH+qOB0pZ42P1lsYZC2zOa8WfWcGabAy+UgbgNGTCoFbYA/bXfE0S+9m1KUjku2AdhgF7NyN7mYCZtsqZdNKR3wNik8G46R4NrcHcSozsUsL9YRHCKvXL5dlbU4UBSVgNtxK5Ebsu/cGHnxm3naApm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k0CCCbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k0CCCbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D79C116B1;
	Tue, 16 Jul 2024 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144286;
	bh=K1HFRG3GNTK0JsCbHxcZxOj/F7KbX6aCeC2/WVYabVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1k0CCCbP8WDsa/3k9qqXBbHHt0i59IVpfwDuphJ9dY+LapARdyuf2X7LdYfrCA45D
	 imWfs0UxsIHhkjh6+cxLA7hl69TI+GZRC9xvjietNc3MLNbCSL/YAbR9RaWK35w1Kq
	 vF4OawOafb16yXC2VK22/uzTvPWqjl0BzA6DPjGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/78] drm/amd/display: Skip finding free audio for unknown engine_id
Date: Tue, 16 Jul 2024 17:30:39 +0200
Message-ID: <20240716152740.913274434@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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
index cdcd5051dd666..2f56684780eb5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1646,6 +1646,9 @@ static struct audio *find_first_free_audio(
 {
 	int i, available_audio_count;
 
+	if (id == ENGINE_ID_UNKNOWN)
+		return NULL;
+
 	available_audio_count = pool->audio_count;
 
 	for (i = 0; i < available_audio_count; i++) {
-- 
2.43.0



