Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFACE1E500C;
	Tue, 26 Aug 2025 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219401; cv=none; b=YBuzECwMmREBl+ZePK9Do6SGbWfUyt2+DRP+7E8OooSFVZHSWCiv+pWCvBLF8XuaHii8LDPIXHFE6g7KQtSA43nTKIVxOR9YeBWNwziiyexrS4JSeZ8POiF87+5wsD2dcuVuj8lqfeK8lEEW9DwmtJnfEO2kZuxrlStNIWtRO6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219401; c=relaxed/simple;
	bh=bM7xvsWM+kpriBdUkr2q4K6QLpy+5z/aTy8yaG5bYV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X/UBecKmQdWFpI5khzvbprEFZ34nbnCfO0DBSyvs8qcUz3fSMgoERxOD5J0myYaHS65OKT8z81rZ21gKhETUqECk3lzj5UMkhvRyOTYl3a6CdVe4N32OrxhWY2HYfDAnZkqY9TBZRQff4NataeyQGOEYbls93KOj2Xu5D5R+Tm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4Zk+e32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4Zk+e32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F094FC4CEF1;
	Tue, 26 Aug 2025 14:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219401;
	bh=bM7xvsWM+kpriBdUkr2q4K6QLpy+5z/aTy8yaG5bYV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4Zk+e3225W5FH4MI7pL8bNzBCSNRTyGpPF2w46wy+x/oKbREx+o58SluBDAxzQwJ
	 JWUBexSd6e+2TnJgXvDcVxw5mxEsob20jD5SwgqEdhywhdHu9W0CGKluLBQbswj0GI
	 2YSTqM6ROzPQcb6kwuYM5HgQlpluXDNTh/DYslYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 368/403] drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS
Date: Tue, 26 Aug 2025 13:11:34 +0200
Message-ID: <20250826110917.171626200@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f ]

Reading DPCD registers has side-effects in general. In particular
accessing registers outside of the link training register range
(0x102-0x106, 0x202-0x207, 0x200c-0x200f, 0x2216) is explicitly
forbidden by the DP v2.1 Standard, see

3.6.5.1 DPTX AUX Transaction Handling Mandates
3.6.7.4 128b/132b DP Link Layer LTTPR Link Training Mandates

Based on my tests, accessing the DPCD_REV register during the link
training of an UHBR TBT DP tunnel sink leads to link training failures.

Solve the above by using the DP_LANE0_1_STATUS (0x202) register for the
DPCD register access quirk.

Cc: <stable@vger.kernel.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250605082850.65136-2-imre.deak@intel.com
[ Call to drm_dp_dpcd_access() instead of drm_dp_dpcd_probe() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -280,7 +280,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * We just have to do it before any DPCD access and hope that the
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
-	ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_DPCD_REV, buffer,
+	ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_LANE0_1_STATUS, buffer,
 				 1);
 	if (ret != 1)
 		goto out;


