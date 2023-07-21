Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC4E1F923
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFCFC433C7;
	Fri, 21 Jul 2023 18:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965743;
	bh=QyGMg3/D6zoMi381xYFdlUCXAKM924Oz8dTLCs//7o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMs4wg0fWgPDHDtdv9OOAohD3ILFRzrXaNKiEhjQ2gTpe2dibnwtV+dpcYv46N7gA
	 30cB1zpAetP7jj+MBTCsDZtLUe3QoZ/04ZmqgH96QQS3sTpD60FeDvHIRYvnCMAwzn
	 Avi4EPzdkB+2jqJR1oe4K7yZwumebMOKY2hHuGzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/532] drm/amd/display: Explicitly specify update type per plane info change
Date: Fri, 21 Jul 2023 18:00:01 +0200
Message-ID: <20230721160619.832493950@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 220a26e45a284..634640d5c0ff4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2111,9 +2111,6 @@ static enum surface_update_type det_surface_update(const struct dc *dc,
 	enum surface_update_type overall_type = UPDATE_TYPE_FAST;
 	union surface_update_flags *update_flags = &u->surface->update_flags;
 
-	if (u->flip_addr)
-		update_flags->bits.addr_update = 1;
-
 	if (!is_surface_in_context(context, u->surface) || u->surface->force_full_update) {
 		update_flags->raw = 0xFFFFFFFF;
 		return UPDATE_TYPE_FULL;
-- 
2.39.2



