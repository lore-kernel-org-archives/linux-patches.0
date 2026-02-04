Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF1E2C08AC;
	Wed,  4 Feb 2026 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218473; cv=none; b=T399+ycl1wLRI7F6LGmLRz1Dg9Fu33dxakA+7NqRwgo053SKEwZJUZP79WpqVdMjuIt3a7dikrc7VgTxyeoM6dABlliBeJ5Bw3Czu0DJO+XwfM6PVjcibekdp/i7722kG6s3KVqciP227x0dBG9bAxB7IZKf0zcLMVyO3ZEFzPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218473; c=relaxed/simple;
	bh=IvAZDp7R4+Xsf7bFwWVCTirHuOk+ja6Llf/Dyz7u1D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGYv+nx5P2hMtLcDL/697m7V4shltuXgKbuVexe71wVER2h0U2gU/pLoa764IuWOxtsmbe6TW3RK8bC5Xa/HNpCvCoIEejW9BZJStQ661vYjM5GbnINz/7JXd+7L9hluvSHP/q4pujVWFXQ3nEi2CKmuRNeSJrcOSTVrSG0J1Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K37M/pOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K37M/pOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7064DC4CEF7;
	Wed,  4 Feb 2026 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218472;
	bh=IvAZDp7R4+Xsf7bFwWVCTirHuOk+ja6Llf/Dyz7u1D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K37M/pOHiOxGOyXfY+irPTjfWmi9KNshLx2QJoWhFNP/kigHJmXDUO8EgGP+QOVIt
	 82Ru08Q7khAhTGotgbzBsYm1yq5aVj61ZuEEHq7P+C7EVLYMJLAK1WJXchOFe3qEV8
	 a2uK78zSXDz+fiPbKH7Iako0lihi9oCJCZ8f9eZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 39/72] drm/amdgpu/soc21: fix xclk for APUs
Date: Wed,  4 Feb 2026 15:40:42 +0100
Message-ID: <20260204143847.043345495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e7fbff9e7622a00c2b53cb14df481916f0019742 upstream.

The reference clock is supposed to be 100Mhz, but it
appears to actually be slightly lower (99.81Mhz).

Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/14451
Reviewed-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 637fee3954d4bd509ea9d95ad1780fc174489860)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -218,7 +218,13 @@ static u32 soc21_get_config_memsize(stru
 
 static u32 soc21_get_xclk(struct amdgpu_device *adev)
 {
-	return adev->clock.spll.reference_freq;
+	u32 reference_clock = adev->clock.spll.reference_freq;
+
+	/* reference clock is actually 99.81 Mhz rather than 100 Mhz */
+	if ((adev->flags & AMD_IS_APU) && reference_clock == 10000)
+		return 9981;
+
+	return reference_clock;
 }
 
 


