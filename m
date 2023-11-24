Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECA52E40E;
	Fri, 24 Nov 2023 18:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="If2H1ec3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBA1C433C7;
	Fri, 24 Nov 2023 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851558;
	bh=MYVjT8AwbArXwZbXRlLBWUu4Jgm9KNiZOl83XeX7yGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=If2H1ec3VZpgKbN5BYlg9AzbktemlH0TUjlETS8Fapf42WAXnMkdMTLwCszMJa3b8
	 sKR7F7WR8xmKElY3JTzVH+A9ar6t3BERmXKPVhuHNEAY0fI1PRtVDtO3YR0evQ10VD
	 kh5EWKEd3lPPDPaREfqvyLLVWZ/a+1dOW1xuosBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tianci Yin <tianci.yin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.5 488/491] drm/amd/display: Enable fast plane updates on DCN3.2 and above
Date: Fri, 24 Nov 2023 17:52:04 +0000
Message-ID: <20231124172039.297700541@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianci Yin <tianci.yin@amd.com>

commit 435f5b369657cffee4b04db1f5805b48599f4dbe upstream.

[WHY]
When cursor moves across screen boarder, lag cursor observed,
since subvp settings need to sync up with vblank that causes
cursor updates being delayed.

[HOW]
Enable fast plane updates on DCN3.2 to fix it.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Tianci Yin <tianci.yin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9507,14 +9507,14 @@ static bool should_reset_plane(struct dr
 	struct drm_plane *other;
 	struct drm_plane_state *old_other_state, *new_other_state;
 	struct drm_crtc_state *new_crtc_state;
+	struct amdgpu_device *adev = drm_to_adev(plane->dev);
 	int i;
 
 	/*
-	 * TODO: Remove this hack once the checks below are sufficient
-	 * enough to determine when we need to reset all the planes on
-	 * the stream.
+	 * TODO: Remove this hack for all asics once it proves that the
+	 * fast updates works fine on DCN3.2+.
 	 */
-	if (state->allow_modeset)
+	if (adev->ip_versions[DCE_HWIP][0] < IP_VERSION(3, 2, 0) && state->allow_modeset)
 		return true;
 
 	/* Exit early if we know that we're adding or removing the plane. */


