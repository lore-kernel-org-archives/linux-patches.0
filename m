Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2732D2797B5;
	Thu, 27 Nov 2025 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254929; cv=none; b=a4C5zyIT0o3ar1QpRgOgNwtxsdSoT7bVh003ZKTNc6HQZzcNEiyqimu4Ujs0jqEmh4LNarlYXYmY+TLK5W9zZ+6OOXfzWE6z84Y7sQz+FSPdanVnQMVybji33YtxihD33DCC2CcAWjQFsslN9u/rHD+yI85fmI3CwbytkI6ppqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254929; c=relaxed/simple;
	bh=59FC7jnlIjZp1yDBaB3aHI1YIKGSJMcj8BuUtYdgav0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCSYJn/r3TikAiOb4899jQ9eS0CRxWVAOsviS7+fIdsnJmNfHUxUof25FIzXhYStnaPQH+8PNlqnRVhpJSW4UJDYjYkHy+aGCRpVNg4oE5lqwOcI15SBYWAT9L5jwzzpCbsitMB0vE8iVvBrNqbGm6YeT37CfC5NyZ0L5GmgTnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6m8XfEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6m8XfEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1000C4CEF8;
	Thu, 27 Nov 2025 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254929;
	bh=59FC7jnlIjZp1yDBaB3aHI1YIKGSJMcj8BuUtYdgav0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6m8XfEizd22msY70FSfIFHPVBNjv5qht72xuIH/pD/dUwCbEW7HP+H4+69G5XpCy
	 khiT1W2TxYaz5eKCwim5H30wNOKTBuUkSb0zmDoErIIIfOaGAqSr+AYqKN26/+PKPN
	 N9/Iol9hPFuHMl/HCag2DrWEjdHv022f2J1Vcr0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zha <Yifan.Zha@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 35/86] drm/amdgpu: Skip emit de meta data on gfx11 with rs64 enabled
Date: Thu, 27 Nov 2025 15:45:51 +0100
Message-ID: <20251127144029.108129745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

From: Yifan Zha <Yifan.Zha@amd.com>

commit 80d8a9ad1587b64c545d515ab6cb7ecb9908e1b3 upstream.

[Why]
Accoreding to CP updated to RS64 on gfx11,
WRITE_DATA with PREEMPTION_META_MEMORY(dst_sel=8) is illegal for CP FW.
That packet is used for MCBP on F32 based system.
So it would lead to incorrect GRBM write and FW is not handling that
extra case correctly.

[How]
With gfx11 rs64 enabled, skip emit de meta data.

Signed-off-by: Yifan Zha <Yifan.Zha@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8366cd442d226463e673bed5d199df916f4ecbcf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5296,9 +5296,9 @@ static void gfx_v11_0_ring_emit_ib_gfx(s
 		if (flags & AMDGPU_IB_PREEMPTED)
 			control |= INDIRECT_BUFFER_PRE_RESUME(1);
 
-		if (vmid)
+		if (vmid && !ring->adev->gfx.rs64_enable)
 			gfx_v11_0_ring_emit_de_meta(ring,
-				    (!amdgpu_sriov_vf(ring->adev) && flags & AMDGPU_IB_PREEMPTED) ? true : false);
+				!amdgpu_sriov_vf(ring->adev) && (flags & AMDGPU_IB_PREEMPTED));
 	}
 
 	if (ring->is_mes_queue)


