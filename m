Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910621E0488;
	Wed,  6 Nov 2024 12:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896516; cv=none; b=YS8Cb/eLcXIec81VgHRpEuU/k5fHVYHMiTbKVCkPperM/l3J6/5IsuWyZXSFGguNFX/pd/sXLSYHGPDcvWxIUrzOSryDt8VpYju8nei7NrqVyWc03mHhP69qSDe2XYFpnktAyBK9h0OBh3sF/l4OXmwVjzftGCQmXuU85kaHP8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896516; c=relaxed/simple;
	bh=VGONr6K9TmGbiXtr9hfpI9Lyz+sNywJh0EkSBZJGsEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTe2+5npmJjp+z903vSi4otmDVY0K9KnNCw8rVf6wXLqeqxDjW1StBJQhP+dkKITBosCUimeVEMifL7KqCaHKQyfXNWKOlSwrg0i9iW5ZOPctLwT5W+jfxXpz0/qDaoYiL854AUU+cd9IUwJrKY32FyRZ7ZpOE81w5pLedPKYY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m732c/uo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m732c/uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185E1C4CECD;
	Wed,  6 Nov 2024 12:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896516;
	bh=VGONr6K9TmGbiXtr9hfpI9Lyz+sNywJh0EkSBZJGsEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m732c/uoYhNWREknvcrpLA0hFZwtM56heJEidj/CSFXavof03ef6LwRHqIpt073ur
	 XDjkHyrd45D9YGCkhkb1tWRy2dEPmFzGsrcwNM3Yh/+DnVnbVvzi3PwGr1Ho3qxp5M
	 SfHuYZ3FrVbvqCq9otkH43io5E9r3IzlyO0+pxy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 227/245] drm/i915/dp: Clear VSC SDP during post ddi disable routine
Date: Wed,  6 Nov 2024 13:04:40 +0100
Message-ID: <20241106120324.849059030@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

commit 3e307d6c28e7bc7d94b5699d0ed7fe07df6db094 upstream.

Clear VSC SDP if intel_dp_set_infoframes is called from post ddi disable
routine i.e with the variable of enable as false. This is to avoid
an infoframes.enable mismatch issue which is caused when pipe is
connected to eDp which has psr then connected to DPMST. In this case
eDp's post ddi disable routine does not clear infoframes.enable VSC
for the given pipe and DPMST does not recompute VSC SDP and write
infoframes.enable which causes a mismatch.

--v2
-Make the comment match the code [Jani]

Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240724163743.3668407-1-suraj.kandpal@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4393,8 +4393,11 @@ void intel_dp_set_infoframes(struct inte
 	if (!enable && HAS_DSC(dev_priv))
 		val &= ~VDIP_ENABLE_PPS;
 
-	/* When PSR is enabled, this routine doesn't disable VSC DIP */
-	if (!crtc_state->has_psr)
+	/*
+	 * This routine disables VSC DIP if the function is called
+	 * to disable SDP or if it does not have PSR
+	 */
+	if (!enable || !crtc_state->has_psr)
 		val &= ~VIDEO_DIP_ENABLE_VSC_HSW;
 
 	intel_de_write(dev_priv, reg, val);


