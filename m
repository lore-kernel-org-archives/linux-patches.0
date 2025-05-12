Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728971C32FF;
	Mon, 12 May 2025 17:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072035; cv=none; b=crkDwjxKsPPhyYLjLTQ+XhTds0A3oO1VmdFaKrYlMvpaA0lykPG0yLx52qB2zSXmE7KdLHAzQ1ez7awyzaT7hNMuNlt/BcWkjSlFrwcMq5s27GyBbhmW1IUo042bvYXxkM9nAo40c+vG4Ea9Z7H+/CiTXDqZs+r7OKs9ms1HST8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072035; c=relaxed/simple;
	bh=+UVFdQr9ghgckdF8X3qDVEJY99ucwXC3LK293wzaUdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/ZaliCrW/doE7OsHvqkVR+F+wWSZBW+uR/t5X7x8Sq4nKhf2lCn7APs6hXUVKvlRhy3PZEaFvqLloAam/up87Jt2IsoxP8JV+uyWYKk2zQLNEMB8AuGd+7gVELF8OKbhmXkMAlIZuz94ukxspOehjuw5jFFl90L4QDwkPvtTOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgWlMVpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgWlMVpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D18C4CEE7;
	Mon, 12 May 2025 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072035;
	bh=+UVFdQr9ghgckdF8X3qDVEJY99ucwXC3LK293wzaUdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgWlMVpjYkCzQainUmTPpt2+WN0HL/bfwLepOinX128r2XH3ybWW5gNUYi4xg8sMI
	 Al0GmpXDBX17efUtaWiQwGj5VrBKG3oVbbvmrKkb6EnKC/fH5meUIVw5CO0xyG+GHP
	 U+J/0f0ewXu7E/M0r7SWOvYn7bUtMESzgyoWVVyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 116/197] drm/amdgpu/hdp7: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:39:26 +0200
Message-ID: <20250512172049.102674264@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5a11a2767731139bf87e667331aa2209e33a1d19 upstream.

Reading back the remapped HDP flush register seems to cause
problems on some platforms. All we need is a read, so read back
the memcfg register.

Fixes: 689275140cb8 ("drm/amdgpu/hdp7.0: do a posting read when flushing HDP")
Reported-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-April/123150.html
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4119
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3908
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dbc064adfcf9095e7d895bea87b2f75c1ab23236)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c
@@ -33,7 +33,12 @@ static void hdp_v7_0_flush_hdp(struct am
 {
 	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
-		RREG32((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2);
+		/* We just need to read back a register to post the write.
+		 * Reading back the remapped register causes problems on
+		 * some platforms so just read back the memory size register.
+		 */
+		if (adev->nbio.funcs->get_memsize)
+			adev->nbio.funcs->get_memsize(adev);
 	} else {
 		amdgpu_ring_emit_wreg(ring, (adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2, 0);
 	}


