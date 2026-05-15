Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FD73F86E8;
	Fri, 15 May 2026 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862469; cv=none; b=EDOE5O0z2A/bIKFdR6hcFUHbBUVB5qJCe70MwQhU/bvnTrArudgVev+NFGj//Yfm0Q+rRsYGQXUyUOyxxxSGu+uiZgcIzJKJ9vVRxjbxd5GlqGhvK1dd9oODTB7ZURs45BwKXofmmx8RgJVwAhvLtwSUbI61mMtMMZ0Z2u9yGFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862469; c=relaxed/simple;
	bh=f4/zRefTq6Jy4LA9fZqAZEPVn0vF3b17dEG3rluqvJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZlN69f4+EVvBUu7NO171yrB72fw1Z3dWP1JM3soIiAg3e46MYHerWIXsSTKkX2OD2crcq1BaU4YGamRnJwrLdlvjDP0Odf2Se8RdVZuEeATqJZHMLCliKeVBvCXyH0o3LiUbSvSpMR1ICoCtJfu2rEL/a/i4saNNHaoU/QcOGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQ4UqbdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQ4UqbdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19301C2BCC7;
	Fri, 15 May 2026 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862469;
	bh=f4/zRefTq6Jy4LA9fZqAZEPVn0vF3b17dEG3rluqvJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQ4UqbdOOuWnyAei0TCl/Rpv+xGPZynJ1MpAwf1OOoRvQVhYTxss93DutNQHRSdmf
	 2gYxUsc9v9CAPqq4iB3u7kqpIZ4fLtSOyHTjkBPIv/MFXdJnv6GeMWIlNSpgo5QYA0
	 vSy7RITAfH/v8p9NfKV3VKQTCIDiSbvyz0ivGi9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Uma Shankar <uma.shankar@intel.com>
Subject: [PATCH 7.0 060/201] drm/atomic: Add affected colorops with affected planes
Date: Fri, 15 May 2026 17:47:58 +0200
Message-ID: <20260515154659.834223908@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

commit 6955d6bca0531ffbbaeecac844b7bae84345b3fb upstream.

When drm_atomic_add_affected_planes() adds a plane to the atomic
state, the associated colorops are not guaranteed to be included.
This can leave colorop state out of the transaction when planes
are pulled in implicitly (eg. during modeset or internal commits).

Also add affected colorops when adding affected planes to keep
plane and color pipeline state consistent within the atomic
transaction.

v2: Add affected colorops only when a pipeline is enabled

Fixes: 2afc3184f3b3 ("drm/plane: Add COLOR PIPELINE property")
Cc: <stable@vger.kernel.org> #v6.19+
Reviewed-by: Uma Shankar <uma.shankar@intel.com> #v1
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260310113238.3495981-3-chaitanya.kumar.borah@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1569,6 +1569,7 @@ drm_atomic_add_affected_planes(struct dr
 	const struct drm_crtc_state *old_crtc_state =
 		drm_atomic_get_old_crtc_state(state, crtc);
 	struct drm_plane *plane;
+	int ret;
 
 	WARN_ON(!drm_atomic_get_new_crtc_state(state, crtc));
 
@@ -1582,6 +1583,12 @@ drm_atomic_add_affected_planes(struct dr
 
 		if (IS_ERR(plane_state))
 			return PTR_ERR(plane_state);
+
+		if (plane_state->color_pipeline) {
+			ret = drm_atomic_add_affected_colorops(state, plane);
+			if (ret)
+				return ret;
+		}
 	}
 	return 0;
 }


