Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91879755FB;
	Mon, 29 Jan 2024 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548600; cv=none; b=UfWhpjJdm0B0+BZ7GAPlqkF6JmmZ8tyfeB9jxcovcmrzsL1TU/9TMyS2Wqpd2UV/TyDnrCvzRXUkHQuGG8Hlwlrq6VoTXyaIJ/KNkS+x1MroYuacJh+zS5MIPNK0urvODj9uM0jxx60+fRr73HJXHa1rHRqnlo6S+N/QpwtmhEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548600; c=relaxed/simple;
	bh=PeSbk1mwBtahwZ5rXertr6lIVsJ4nteRGuONcQlQK0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWs4/pQFQSM+wUUe3NnljH8kE1kGrQEkL3IGI6blYp9ohjLTHqtrMVrBss2ALgMXobB6/H6GhlPuGXMjEg8lzcq2Tbj6PnCJQR5DwjEoQUE1rBtwu7VRhlYTgWF6utawFjF8RXB6PswhVWpEVYiP/w3lIBeyO+2OXWZu8+WGFIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffIU9BxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffIU9BxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D84C433C7;
	Mon, 29 Jan 2024 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548600;
	bh=PeSbk1mwBtahwZ5rXertr6lIVsJ4nteRGuONcQlQK0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffIU9BxEXQyXr9eAfObdWLIOJf8qu2+qA4vt3BrDuERdcpfrW0jK/5meZjyF9yKkU
	 NO6L9j9PaHvw/c3jUggX3ntFq2v5C0eO1ie0eb/IwI+um5N+wnY2icDnCwZNSfhiVV
	 FFxP3CRLsJicn1cBGgJLazirn+ZCK/EXuApafxsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 262/331] drm/amd/display: fix bandwidth validation failure on DCN 2.1
Date: Mon, 29 Jan 2024 09:05:26 -0800
Message-ID: <20240129170022.538612945@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Melissa Wen <mwen@igalia.com>

commit 3a0fa3bc245ef92838a8296e0055569b8dff94c4 upstream.

IGT `amdgpu/amd_color/crtc-lut-accuracy` fails right at the beginning of
the test execution, during atomic check, because DC rejects the
bandwidth state for a fb sizing 64x64. The test was previously working
with the deprecated dc_commit_state(). Now using
dc_validate_with_context() approach, the atomic check needs to perform a
full state validation. Therefore, set fast_validation to false in the
dc_validate_global_state call for atomic check.

Cc: stable@vger.kernel.org
Fixes: b8272241ff9d ("drm/amd/display: Drop dc_commit_state in favor of dc_commit_streams")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10400,7 +10400,7 @@ static int amdgpu_dm_atomic_check(struct
 			DRM_DEBUG_DRIVER("drm_dp_mst_atomic_check() failed\n");
 			goto fail;
 		}
-		status = dc_validate_global_state(dc, dm_state->context, true);
+		status = dc_validate_global_state(dc, dm_state->context, false);
 		if (status != DC_OK) {
 			DRM_DEBUG_DRIVER("DC global validation failure: %s (%d)",
 				       dc_status_to_str(status), status);


