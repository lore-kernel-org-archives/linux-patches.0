Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212F537C925;
	Thu, 20 Aug 2026 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238369; cv=none; b=ur4tyPqpIoFySnCqbOpfQDXQwNUkyNbuvabWPdpILcmXPs5yjECKtZIsRcTWLa7ieXfSrZJOF0A24VL8KsqnxPV/eBcs6zO71t7mmHmfUtCG/euz0P0sub94dWitTqN2RkE2RsXRpSgwcibyoiWcosuWrhwd4cZV9oCQvqg5tT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238369; c=relaxed/simple;
	bh=Loswl7QxSbY6r8plB7UckjNUZK4Sk8pD4rtDwY+JllU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsf9ZiiGxhV7NFciDfoX5Q8VDvLaEWpq9ubhN+PFdvHdVIY2TtlHEcNrMOCmMAK/A9FN34PhjWg/ePudmifdkWRxn/YGvfZgR/Qwy51nYAnaCltI66k2NggXMsQxroVnNHQORJwZki9JKSCHiI/VWwk2P7TZHLbGn4Fq5HvBrGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuNMIY7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuNMIY7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B5A1F000E9;
	Thu, 20 Aug 2026 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238367;
	bh=rp2dgduQt62ty1RKj/d5QZ9XLCSqueXSIjRF7C8qtTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuNMIY7Akbo6L+e/bZ2D0qaJkskSJa6jLHmT+ubzvhRYFumgnnujMUy6/aM80r/x2
	 0FhsuvZhYodoGQjUvP78Zos6yGjLp6TdP7miwP6+NY+Y2CfEeRrg3W5cx8X21LgA8O
	 9jINXakQOUqxbEQB+5uyxroSVTYFVPAnrm2IPOt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 123/228] drm/amdgpu: Fix UVD decode image min size calculation
Date: Thu, 20 Aug 2026 16:54:25 +0200
Message-ID: <20260820145248.362422154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit b8bb9ba3f101a1b0011f785a577a4a0a38371174 upstream.

This needs to use pitch instead of width. Also reject pitch
over 4096 to avoid overflow.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b41c8cb12e202b220353332ab87dc01a11f69304)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -762,7 +762,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		return -EINVAL;
 	}
 
-	if (width > pitch) {
+	if (width > pitch || pitch > 4096) {
 		DRM_ERROR("Invalid UVD decoding target pitch!\n");
 		return -EINVAL;
 	}
@@ -774,7 +774,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	}
 
 	buf_sizes[0x1] = dpb_size;
-	buf_sizes[0x2] = image_size;
+	buf_sizes[0x2] = (pitch * height) * 3 / 2;
 	buf_sizes[0x4] = min_ctx_size;
 	/* store image width to adjust nb memory pstate */
 	adev->uvd.decode_image_width = width;


