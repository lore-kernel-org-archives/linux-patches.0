Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021075232
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76982C433C7;
	Sun,  9 Jul 2023 11:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901830;
	bh=dWnzD2/iUoxtbUo7QQ3iDRvj6259MIwDkp1LaI1spEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntAqZm2oHGNf3agCScFtM+UfJZFPwJE1ylBXFeZWiAqRbTFZXJS4TevcgxV3Hq3m6
	 SKehUgHUBJaVEKx0bUmAX9BcGcCEoJhLRnWewV67LRc+ZS1nfZSAsad+7knvHxzp4+
	 BPrmx3CzH+Zq4GaQwycM7+Uru6PUyaSMazjvJwyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 160/431] drm/amd/display: Explicitly specify update type per plane info change
Date: Sun,  9 Jul 2023 13:11:48 +0200
Message-ID: <20230709111454.918521072@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 710cc1e7cd461446a9325c9bd1e9a54daa462952 ]

[Why]
The bit for flip addr is being set causing the determination for
FAST vs MEDIUM to always return MEDIUM when plane info is provided
as a surface update. This causes extreme stuttering for the typical
atomic update path on Linux.

[How]
Don't use update_flags->raw for determining FAST vs MEDIUM. It's too
fragile to changes like this.

Explicitly specify the update type per update flag instead. It's not
as clever as checking the bits itself but at least it's correct.

Fixes: aa5fdb1ab5b6 ("drm/amd/display: Explicitly specify update type per plane info change")
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2540,9 +2540,6 @@ static enum surface_update_type det_surf
 	enum surface_update_type overall_type = UPDATE_TYPE_FAST;
 	union surface_update_flags *update_flags = &u->surface->update_flags;
 
-	if (u->flip_addr)
-		update_flags->bits.addr_update = 1;
-
 	if (!is_surface_in_context(context, u->surface) || u->surface->force_full_update) {
 		update_flags->raw = 0xFFFFFFFF;
 		return UPDATE_TYPE_FULL;


