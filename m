Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD26239573;
	Tue, 26 Aug 2025 11:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207533; cv=none; b=fc/qRO9s4c/8ZtjrNduqBcEHgWE+71gesPhM+2F6Xj8uGDdY4N0YH5o+siiWxrKagItN2+Dnf5AGoaTZROKh+Pav77y57o49NX7BoHyCF/1k+vuohN0VEc5pbGV+xo4ji98Qj2lf/SuzyW/gNd0mnfw024za3DLD25ZmT7qx194=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207533; c=relaxed/simple;
	bh=Z+W1ohMcMSdOasWW9zxZjWV5BCSzxEuAnZsySRVNq9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bL0itJnlCCAJdhxDA0+bVz+fGG40Ae8vv9Rc7DohHJYf56xXmXg/3e3+e+usyQ/VZu+hrEBakHTTqRiyjUbvDLQ8dddvjhUlvHTlAv3wyeA4G3Bx83lZ+/AJeaM5e360FC5GRbnLKNPUSGRE4wKSAQH/WET6TyAPcPXsAsl3xhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFeRJHtG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFeRJHtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4ABFC4CEF1;
	Tue, 26 Aug 2025 11:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207533;
	bh=Z+W1ohMcMSdOasWW9zxZjWV5BCSzxEuAnZsySRVNq9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFeRJHtG4pOi0dXsuqI3kRJpxZiKJUmRjJ1mPyY2XmcZcjMexkyBVItdXThl85GaG
	 ZeyP9iRdg5R/Nt/bGsCwm7Clgn/P0JdO0tiKmUqlzAQXl1U/b8wIbGKMRqJUXESad6
	 GbLMEn2HIf1t4tED9ZahETDJ71G4ULOyXZZqmTow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@kde.org>,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 187/457] drm/amd/display: Add primary plane to commits for correct VRR handling
Date: Tue, 26 Aug 2025 13:07:51 +0200
Message-ID: <20250826110941.991312690@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <mdaenzer@redhat.com>

commit 3477c1b0972dc1c8a46f78e8fb1fa6966095b5ec upstream.

amdgpu_dm_commit_planes calls update_freesync_state_on_stream only for
the primary plane. If a commit affects a CRTC but not its primary plane,
it would previously not trigger a refresh cycle or affect LFC, violating
current UAPI semantics.

Fixes e.g. atomic commits affecting only the cursor plane being limited
to the minimum refresh rate.

Don't do this for the legacy cursor ioctls though, it would break the
UAPI semantics for those.

Suggested-by: Xaver Hugl <xaver.hugl@kde.org>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3034
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cc7bfba95966251b254cb970c21627124da3b7f4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -661,6 +661,15 @@ static int amdgpu_dm_crtc_helper_atomic_
 		return -EINVAL;
 	}
 
+	if (!state->legacy_cursor_update && amdgpu_dm_crtc_vrr_active(dm_crtc_state)) {
+		struct drm_plane_state *primary_state;
+
+		/* Pull in primary plane for correct VRR handling */
+		primary_state = drm_atomic_get_plane_state(state, crtc->primary);
+		if (IS_ERR(primary_state))
+			return PTR_ERR(primary_state);
+	}
+
 	/* In some use cases, like reset, no stream is attached */
 	if (!dm_crtc_state->stream)
 		return 0;


