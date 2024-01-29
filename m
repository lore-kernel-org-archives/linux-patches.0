Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC2D159578;
	Mon, 29 Jan 2024 17:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548228; cv=none; b=NygmXTdInZMhfKwnqC/CQVC3FqH4C7Dxzyc8cKEHCw9VY1v38BGEeT5sCNuXCSx7HF18fwMRmTttUuavsGA2E6LzkKjuppYk1+sNgocAjD4FNR4Ta94liH9Y8LXcpQS9vuFObfECm01pVbxqU5Q+ZYRSOmWJN7P7UayMyq1/rOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548228; c=relaxed/simple;
	bh=/k2dAEFEi1m9U6XRKMKnqf8Gkarm5Xy00V0jWUAtOms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+z+Z+9/HqUk1v7IKcjsFODejj3ivGjy5qCnrw/zA/mgpQo57ff52KE2NK/68guW75ZVZqxHBYhLR3AfZBRt5/8YgVb1uyYsvYgwv6YAF5dKzA494gjRAxh7GdqHrPkrvKujGLcdLDXudFq04nt4cCqKlcuZxGz8dNtrEHaWc8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLUrHx+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLUrHx+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94195C43390;
	Mon, 29 Jan 2024 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548228;
	bh=/k2dAEFEi1m9U6XRKMKnqf8Gkarm5Xy00V0jWUAtOms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLUrHx+/cBpvvuVPB/3ERIHuF1W5/tCnmMdljsbIRpthVypUSlNQHgrnEvwcmeooN
	 F30nP22IeljPPhav7ELtJjni7bXxtQKWDe3ZI0kUqyv2KVwDyGtraPCvrhkCKbJpEF
	 D337cITWY5gaGWgQ7y1DCm1btbU+5+/vvs/1ki/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 256/346] drm/amd/display: fix bandwidth validation failure on DCN 2.1
Date: Mon, 29 Jan 2024 09:04:47 -0800
Message-ID: <20240129170023.927555704@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10479,7 +10479,7 @@ static int amdgpu_dm_atomic_check(struct
 			DRM_DEBUG_DRIVER("drm_dp_mst_atomic_check() failed\n");
 			goto fail;
 		}
-		status = dc_validate_global_state(dc, dm_state->context, true);
+		status = dc_validate_global_state(dc, dm_state->context, false);
 		if (status != DC_OK) {
 			DRM_DEBUG_DRIVER("DC global validation failure: %s (%d)",
 				       dc_status_to_str(status), status);


