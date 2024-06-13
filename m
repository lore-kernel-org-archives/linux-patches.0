Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E04DDB1;
	Thu, 13 Jun 2024 11:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278610; cv=none; b=fLGskRwaDFqC69nFnGPe7JFDnCBEDwtRktWU1qJw+NzbiVybqHrEEqXIrzj+ens6FY7yUt95UiJ6Q/ZT3Lt2Vil8NVviyUksrUPbSOGq3KvMLt0XX73vFOnDjRFf1aoTqzLrGuvUWTR1pqezXYor8hvw5IPIavv8w9YX9RJVQG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278610; c=relaxed/simple;
	bh=HwHJnATovnAQOkHhdCmX/wl8Bad/RW+2ftCxX+KkwnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2KOpIZ4+Jjmp7wrGWWVquFAf+8dQDIzIPKuqugsFPinNiQVMBkTBCm4GLxIsZM73qMJhDHeczLRJllbMqJJZmX+DPwRB29/W9LW5CI3SBfVcT5C9KC1Uljf4kulpgO5WAL8RfpAMCnUrLgoX4LXG/pyJWQY2geh/ZfgfldZ1HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaBS8ODF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaBS8ODF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03363C2BBFC;
	Thu, 13 Jun 2024 11:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278609;
	bh=HwHJnATovnAQOkHhdCmX/wl8Bad/RW+2ftCxX+KkwnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaBS8ODFlLprPw+2fSW5jhnRnrzy2cxPgfIesFVGadhNz/9gRr3uqXXD2pTXbLJea
	 fnT1VJvu/vYL4AZ3/4hIEHVq9mLrRuOyX5CR0UldceHZMa6Du0ERXJ/DpoLHOY3foc
	 Bh18l+GyN5Gp1rf3hXrVkPRKC/Ap+pCMlJy49skU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Ashton <joshua@froggi.es>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/213] drm/amd/display: Set color_mgmt_changed to true on unsuspend
Date: Thu, 13 Jun 2024 13:30:58 +0200
Message-ID: <20240613113228.378463747@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Ashton <joshua@froggi.es>

[ Upstream commit 2eb9dd497a698dc384c0dd3e0311d541eb2e13dd ]

Otherwise we can end up with a frame on unsuspend where color management
is not applied when userspace has not committed themselves.

Fixes re-applying color management on Steam Deck/Gamescope on S3 resume.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 98d51bc204172..e4139723c473c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -816,6 +816,7 @@ static int dm_resume(void *handle)
 			dc_stream_release(dm_new_crtc_state->stream);
 			dm_new_crtc_state->stream = NULL;
 		}
+		dm_new_crtc_state->base.color_mgmt_changed = true;
 	}
 
 	for_each_new_plane_in_state(dm->cached_state, plane, new_plane_state, i) {
-- 
2.43.0



