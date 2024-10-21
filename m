Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AB31D07B1;
	Mon, 21 Oct 2024 10:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506602; cv=none; b=iRcLqf+N5XUoqXHwOCLMpfPanh4D1rrbcvXqc22NzGbZdPPjv3EXEuJeM9SbP2bhu7VBpP9NeIuiOp+gLOOc+mCPyvrVuV9PcfaMZIPOHyhyTT0Bn+DbQqdbDQzmg/ZdLfKfwoJWIKY5XZ01O43HS2uMD296W88VZ5cw0CG6CKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506602; c=relaxed/simple;
	bh=aajy0ciFapoZIi+Rdm8tI2/ZNdQmHIiwr9ESeZ68U0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ks/lcY6IFd/BzMc6THOm46Q4EoA04qm1qKy8HaOz6hD6wjixSO4e+NOiAoRkIYAfNwpJeRmXwdoimLJtb2AZRyxG3JsYSUSEA/veD/wLhM2Fl6H8NXTDc2uAREMZtG+Ya2/uJciCs6ajIne2kJeqvtYcSDSJcGn2WuMOnwJOX3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IURMCoJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IURMCoJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CA9C4CEC3;
	Mon, 21 Oct 2024 10:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506602;
	bh=aajy0ciFapoZIi+Rdm8tI2/ZNdQmHIiwr9ESeZ68U0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IURMCoJpQDsL//BM/pzzdiSYAINS66ubjl1Wc+kaQlhJUBsAjgBKFqPbFCIczUapx
	 R400U9UmOCKO8/Uli5aKWvHVkwn+kJR0pC99VR/FHssyUIG7xc4UsitiLqIqjNO3yz
	 Sui1+vYJqEvWGRfP8+GWEAWIONbc6ZPLMCY58EQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Erhard Furtner <erhard_f@mailbox.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 6.11 059/135] drm/radeon: Fix encoder->possible_clones
Date: Mon, 21 Oct 2024 12:23:35 +0200
Message-ID: <20241021102301.636004012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 28127dba64d8ae1a0b737b973d6d029908599611 upstream.

Include the encoder itself in its possible_clones bitmask.
In the past nothing validated that drivers were populating
possible_clones correctly, but that changed in commit
74d2aacbe840 ("drm: Validate encoder->possible_clones").
Looks like radeon never got the memo and is still not
following the rules 100% correctly.

This results in some warnings during driver initialization:
Bogus possible_clones: [ENCODER:46:TV-46] possible_clones=0x4 (full encoder mask=0x7)
WARNING: CPU: 0 PID: 170 at drivers/gpu/drm/drm_mode_config.c:615 drm_mode_config_validate+0x113/0x39c
...

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Fixes: 74d2aacbe840 ("drm: Validate encoder->possible_clones")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/dri-devel/20241009000321.418e4294@yea/
Tested-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3b6e7d40649c0d75572039aff9d0911864c689db)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_encoders.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -43,7 +43,7 @@ static uint32_t radeon_encoder_clones(st
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_encoder *clone_encoder;
-	uint32_t index_mask = 0;
+	uint32_t index_mask = drm_encoder_mask(encoder);
 	int count;
 
 	/* DIG routing gets problematic */


