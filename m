Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC0A1E7C30;
	Mon, 21 Oct 2024 10:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507912; cv=none; b=EjYg1rSU/mNFkzjCycXMswAsM5pU8ukv9FCwFgfwR1szr9u32XaHg6NV3HXdGfnFM8ZocUsOKF3qndBkbZlPDrhWQMiLLXGSuZ9c9Mo2J6QGfKO9c291+Q+XOoSNA4F+PCFxXfhh4amg5bKn9sXwhUiYxlzYdTOKdgkhtjR4Pwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507912; c=relaxed/simple;
	bh=VyOyzRQK8E8vndkmLFPuQshkWcffwSXnT/ZeE0PnmlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBrVvJ93LfQ/WHtwropFEQRrBxnM1vQybzMC79ct+tHZwST8XJSpWS1zoAyhkpH5pYyvzUsGpxLXDm37qM+O5Qr73Mhnc+TOHLqzRYJdP51RHJ2aAuND7ZPh/rumiuiZxl60zS9OOL2WCLbeHIfcsxMS+wMw60I/YV651nOgqqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ox6kGG6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ox6kGG6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3BCC4CEC3;
	Mon, 21 Oct 2024 10:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507911;
	bh=VyOyzRQK8E8vndkmLFPuQshkWcffwSXnT/ZeE0PnmlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ox6kGG6HAJCyizfAbUxDznQXal1bYB6smXreOmUhHmACTTZhv3dgCgKz4KAr8Sr4d
	 9U6Rn1Dy1tzNMKPu2uxmrfaFaiStsLveme1xPIEAqZmVbD32bFU8/SiGaj7YV+4Dhn
	 5dPPoQ7qVLm6lES2PY9Gwop2Z9kkqpdD0mlog+xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Erhard Furtner <erhard_f@mailbox.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.10 24/52] drm/radeon: Fix encoder->possible_clones
Date: Mon, 21 Oct 2024 12:25:45 +0200
Message-ID: <20241021102242.573708060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -47,7 +47,7 @@ static uint32_t radeon_encoder_clones(st
 	struct radeon_device *rdev = dev->dev_private;
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 	struct drm_encoder *clone_encoder;
-	uint32_t index_mask = 0;
+	uint32_t index_mask = drm_encoder_mask(encoder);
 	int count;
 
 	/* DIG routing gets problematic */


