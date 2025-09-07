Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D1221ADAE;
	Sun,  7 Sep 2025 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277849; cv=none; b=HfDrA8aL0AwG+XFldcJPovR/tt2jBu9vQ4cX+dAebidfPDwS7uJkVfBb+R69iZEjL9Xuu7SZOobmnQMyVfFKclpoaUshFTcamjanCnuUkxGJ72maGVqJUl1pVpGVJlKmotMAJPIBXoQ50q3ZBPyGFsSnYzdk5oCjp9aEGbm0Rso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277849; c=relaxed/simple;
	bh=HDC09LjMaDExjsCNwZk4bYVXHOUq6q6byKpy1zIysYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=exmo2Q2LUNKZzB4t7lYSfvF/zi8cY9wM5x4+yEeRx1FbBRtoP7u/8hQIcFhmGn9KI1FqtdPl3gtYVfDmz7NgzztXNBDEuNldgVUph2DR3K51o3Pbqvsz8v+OFwHHDrIRAgL3aJ98jB6sEk0HyC/GAVBkoOeFT21RXKnyweXxc8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppxTPN8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppxTPN8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FFBC4CEF0;
	Sun,  7 Sep 2025 20:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277848;
	bh=HDC09LjMaDExjsCNwZk4bYVXHOUq6q6byKpy1zIysYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppxTPN8J4pPG9BKY6LC02fO/wLVTlP26gO1Kq5wvLXi7qdDPThuxxxmB37og5uZQu
	 8MJo7BGYzgpNVC9AlbqoEcyg76NGrZbOJ+epq7tdKB+gJydOkhCbuKXL2wmcaBiJNA
	 m+Z5CG2dN/roHt63HGQEe8I9r8mZDYQIKJROLD9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH 6.16 142/183] drm/dp: Change AUX DPCD probe address from LANE0_1_STATUS to TRAINING_PATTERN_SET
Date: Sun,  7 Sep 2025 21:59:29 +0200
Message-ID: <20250907195619.174453855@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit d34d6feaf4a76833effcec0b148b65946b04cde8 upstream.

Commit a3ef3c2da675 ("drm/dp: Change AUX DPCD probe address from
DPCD_REV to LANE0_1_STATUS") stopped using the DPCD_REV register for
DPCD probing, since this results in link training failures at least when
using an Intel Barlow Ridge TBT hub at UHBR link rates (the
DP_INTRA_HOP_AUX_REPLY_INDICATION never getting cleared after the failed
link training). Since accessing DPCD_REV during link training is
prohibited by the DP Standard, LANE0_1_STATUS (0x202) was used instead,
as it falls within the Standard's valid register address range
(0x102-0x106, 0x202-0x207, 0x200c-0x200f, 0x2216) and it fixed the link
training on the above TBT hub.

However, reading the LANE0_1_STATUS register also has a side-effect at
least on a Novatek eDP panel, as reported on the Closes: link below,
resulting in screen flickering on that panel. One clear side-effect when
doing the 1-byte probe reads from LANE0_1_STATUS during link training
before reading out the full 6 byte link status starting at the same
address is that the panel will report the link training as completed
with voltage swing 0. This is different from the normal, flicker-free
scenario when no DPCD probing is done, the panel reporting the link
training complete with voltage swing 2.

Using the TRAINING_PATTERN_SET register for DPCD probing doesn't have
the above side-effect, the panel will link train with voltage swing 2 as
expected and it will stay flicker-free. This register is also in the
above valid register range and is unlikely to have a side-effect as that
of LANE0_1_STATUS: Reading LANE0_1_STATUS is part of the link training
CR/EQ sequences and so it may cause a state change in the sink - even if
inadvertently as I suspect in the case of the above Novatek panel. As
opposed to this, reading TRAINING_PATTERN_SET is not part of the link
training sequence (it must be only written once at the beginning of the
CR/EQ sequences), so it's unlikely to cause any state change in the
sink.

As a side-note, this Novatek panel also lacks support for TPS3, while
claiming support for HBR2, which violates the DP Standard (the Standard
mandating TPS3 for HBR2).

Besides the Novatek panel (PSR 1), which this change fixes, I also
verified the change on a Samsung (PSR 1) and an Analogix (PSR 2) eDP
panel as well as on the Intel Barlow Ridge TBT hub.

Note that in the drm-tip tree (targeting the v6.17 kernel version) the
i915 and xe drivers keep DPCD probing enabled only for the panel known
to require this (HP ZR24w), hence those drivers in drm-tip are not
affected by the above problem.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Fixes: a3ef3c2da675 ("drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS")
Reported-and-tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14558
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250708212331.112898-1-imre.deak@intel.com
(cherry picked from commit bba9aa41654036534d86b198f5647a9ce15ebd7f)
[Imre: Rebased on drm-intel-fixes]
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo: Changed original commit hash to match with the one propagated in fixes]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -725,7 +725,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_probe(aux, DP_DPCD_REV);
+		ret = drm_dp_dpcd_probe(aux, DP_TRAINING_PATTERN_SET);
 		if (ret < 0)
 			return ret;
 	}


