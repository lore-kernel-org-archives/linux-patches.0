Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F982931C0;
	Thu, 20 Aug 2026 17:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247467; cv=none; b=eYs/h77sd/DaJJNx75xsVxwBx8/WKKyAgAgK4FPy1Ot6ED2jHvHpYJbgwBh712AdieBQ0/doS/mMHI92gM5fgPx6FpCt2+ala5vYJ1Wks4G/rTEvmMIPz2RrFAcVwLC5OlSJmJIVMjVvO2U5vzId6oWyrNb8yqQMgWpr2eHko78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247467; c=relaxed/simple;
	bh=i9ZMQKmu23SEk4lYyuYieDdikRPLc2D1xNHfL2K5p2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNKcpbUVd0lnvBlqfrncbb2UVZyzodUWxSUKKI3rKMY1EB3wJ2EVFxjEqfpYkWgt21Up7P/ynU0I2Y/tvYNX2qGGCyq5xgYxxga3QO3JM+fs2HeWrdKfrmt8svpDBFnvVwfrBpqFYlgLlt/eVTEorOSS7fOfoYgCC1BYqtgRRUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgGWKltn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgGWKltn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A561F000E9;
	Thu, 20 Aug 2026 17:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247466;
	bh=1nHwMFjwciuJqDN7InHebYlOSU75++D8ir9i2j3fS7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgGWKltnVyE5BA2ONg9mRSWf3ofPqzHFilvUiz8vVucxmzfcF1hBY05oSVAQI2bab
	 TVBVg3AOqWHx6NGNx2bxDgL+vcz09d7J5szLPiCrRCZyf6/yxIquB8YpRPApawmORx
	 pRoq6L7p77UVKwBKhjvWz+jhCFuq3aR9Co4zXkKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 056/166] drm/amdgpu: Reject UVD message with invalid number of h265 refs
Date: Thu, 20 Aug 2026 16:55:15 +0200
Message-ID: <20260820145212.840260584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit 9fca434208f1f9ab977feac62df8ebb1cc7ce893 upstream.

Same change as for h264, avoids overflow later when calculating
min dpb size.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a4b0720e4f1601f97f59a2be9c1b4b94fa6527d5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -795,6 +795,9 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		image_size = ALIGN(image_size, 256);
 
 		num_dpb_buffer = (le32_to_cpu(msg[59]) & 0xff) + 2;
+		if (num_dpb_buffer > 17)
+			return -EINVAL;
+
 		min_dpb_size = image_size * num_dpb_buffer;
 		min_ctx_size = ((width + 255) / 16) * ((height + 255) / 16)
 					   * 16 * num_dpb_buffer + 52 * 1024;


