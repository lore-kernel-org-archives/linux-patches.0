Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999041C0DE7;
	Mon,  1 Apr 2024 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989079; cv=none; b=FJ5viEIhJg07BuRCU0WYN96GUuzS3iCdB0iVM5/FcwW2+yUTevAdaM3brCBoxdyF14nD51R8oDgqwbwEUFdG5p+LzrZCXWrJnGhGQTJyNJ9AHxLF4VJ9TGAY5IckOIB9WJtZOBWttWCfsb4wDgy+W3adXHjc39ON3JLjV5Em5T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989079; c=relaxed/simple;
	bh=V2hXdiGvkEFz5ndiO81ImvbzvOKUyf2rhtY3lGf4Ws8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nT8KtRkJxGFpdOKHjw1YrL56tpw85hZoXdcK0Q2EeuywH3KuOklglVFCjkuv2cl4FJoFhRH97tc16xRv8wfcr3GNFhlrrUNmc8NYM1dYvWydHTNGfmzjoYc/yAK5FCyFBW1TFfsXXtNQzxg1Z7HWfGzwKOPeXrO6Orij4rA4uNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW49GGa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW49GGa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07214C433C7;
	Mon,  1 Apr 2024 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989079;
	bh=V2hXdiGvkEFz5ndiO81ImvbzvOKUyf2rhtY3lGf4Ws8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW49GGa4FZfY7NRZ4uCUvBrjb0mKE7POLSmche/nUBaAyvoEf5f+MhqPpMD0hxKQV
	 WoGpyEfkbLIvM1qM2TNFDxScx+d+U0myow2nXaPKW1L6E0igTXjQ9e9xHnWVQFBwW+
	 oTdzuEfzIUO3d1kioXX/9CFtnnx5xv6Blqe1nel4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.7 374/432] drm/i915/dsb: Fix DSB vblank waits when using VRR
Date: Mon,  1 Apr 2024 17:46:01 +0200
Message-ID: <20240401152604.439895749@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit f12751168f1a49ebb84b8056cf038973c53b284f upstream.

Looks like the undelayed vblank gets signalled exactly when
the active period ends. That is a problem for DSB+VRR when
we are already in vblank and expect DSB to start executing
as soon as we send the push. Instead of starting, the DSB
just keeps on waiting for the undelayed vblank which won't
signal until the end of the next frame's active period,
which is far too late.

The end result is that DSB won't have even started
executing by the time the flips/etc. have completed.
We then wait for an extra 1ms, after which we terminate
the DSB and report a timeout:
[drm] *ERROR* [CRTC:80:pipe A] DSB 0 timed out waiting for idle (current head=0xfedf4000, head=0x0, tail=0x1080)

To fix this let's configure DSB to use the so called VRR
"safe window" instead of the undelayed vblank to trigger
the DSB vblank logic, when VRR is enabled.

Cc: stable@vger.kernel.org
Fixes: 34d8311f4a1c ("drm/i915/dsb: Re-instate DSB for LUT updates")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9927
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240306040806.21697-3-ville.syrjala@linux.intel.com
Reviewed-by: Animesh Manna <animesh.manna@intel.com>
(cherry picked from commit 41429d9b68367596eb3d6d5961e6295c284622a7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dsb.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dsb.c
+++ b/drivers/gpu/drm/i915/display/intel_dsb.c
@@ -339,6 +339,17 @@ static int intel_dsb_dewake_scanline(con
 	return max(0, vblank_start - intel_usecs_to_scanlines(adjusted_mode, latency));
 }
 
+static u32 dsb_chicken(struct intel_crtc *crtc)
+{
+	if (crtc->mode_flags & I915_MODE_FLAG_VRR)
+		return DSB_CTRL_WAIT_SAFE_WINDOW |
+			DSB_CTRL_NO_WAIT_VBLANK |
+			DSB_INST_WAIT_SAFE_WINDOW |
+			DSB_INST_NO_WAIT_VBLANK;
+	else
+		return 0;
+}
+
 static void _intel_dsb_commit(struct intel_dsb *dsb, u32 ctrl,
 			      int dewake_scanline)
 {
@@ -360,6 +371,9 @@ static void _intel_dsb_commit(struct int
 	intel_de_write_fw(dev_priv, DSB_CTRL(pipe, dsb->id),
 			  ctrl | DSB_ENABLE);
 
+	intel_de_write_fw(dev_priv, DSB_CHICKEN(pipe, dsb->id),
+			  dsb_chicken(crtc));
+
 	intel_de_write_fw(dev_priv, DSB_HEAD(pipe, dsb->id),
 			  i915_ggtt_offset(dsb->vma));
 


