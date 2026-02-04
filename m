Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953162D8798;
	Wed,  4 Feb 2026 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219232; cv=none; b=K2+3waamZUlXPe0uyqUK+CE3ieSgyT+4VzjU0ubHBcGW3+DeGMhHu6CXwCYFFSC2nGrjrBDllpC+kM0ySI2tUj6wp6JMsOtRU0N0j4ZQt8V/4UG0D6e7mpFdXZPiBQf8imqToM+AgvMMf0c/0IqPnD2KZlYk1wqtmZ0Gjzgh0jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219232; c=relaxed/simple;
	bh=onCuazh6dKoBcRJFaqsbNngjaJBFVrc/0zEgYpyS/8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+6TGTxruujrhifRlRwzBylJyFwdbV5GPoAwf8PMC8AgGfUvJ3WHeNVB8RWXupRL12LjTtLJ7m1Fl2a3w8YXQOKP0+rDvINhspOpFKly/cMwJSeCRjache5+xGcnb4r0xqLmC/OQPyp/orA2TNczZqDrJTeBmI9wu/oGF+RtuJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLBlV4Kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLBlV4Kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0333BC4CEF7;
	Wed,  4 Feb 2026 15:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219232;
	bh=onCuazh6dKoBcRJFaqsbNngjaJBFVrc/0zEgYpyS/8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLBlV4KgeGKDwjKZqd5hbh1eWqdsH5bEebtzR6MNBdyOkH+bL+nRooQlRj5d6O+Rp
	 inw9QIJpPVl6Kt9Y0NaJq+o5T3cKAbP3bWPUe1VtwkaG3LPbbz9jJ8W2PqkmS/qKqN
	 h3R9shpSOQEhUxihl58shEK6o8IGzrS0kqGlOqs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 107/122] drm/amdgpu/soc21: fix xclk for APUs
Date: Wed,  4 Feb 2026 15:41:29 +0100
Message-ID: <20260204143855.702830926@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -225,7 +225,13 @@ static u32 soc21_get_config_memsize(stru
 
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
 
 


