Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6751C173C;
	Mon, 12 May 2025 17:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072032; cv=none; b=VXWBD9JP5xJcaSupbK1i2bt3IBFaGVt6M8MCP2SBqdVlc5jRbcMdCXR3RB4cpzHrTPrJbB86KrHVvcb/AZXwU8K8a6JTKhvWi74YSmW8PLAkOhcc6ZWyMshkW7kwkFpkbthZ64HftUUiVvHzEg1ufM2sljas8122SbySZWYs6Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072032; c=relaxed/simple;
	bh=DLcYGAlVTLOPMBbG5sRCBqC79euKOcXryKMDer0Y1Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBH8KhWtimbQmUFJPXIoMWoghKa+OhqYEZa57xkJ6KLDNvIXzWWdSKQnP0y33+UNO3pHZ66fA3Pna3s7OB/VvDntEAwbd7DjkQG0BoMxrDSdyUmV+MWiyfbopArN0Syru7YMEFCZCbT99GE4oWyfzqaeLRNNeowTxPN3Qfncr9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IycSARM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IycSARM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFF0C4CEE7;
	Mon, 12 May 2025 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072032;
	bh=DLcYGAlVTLOPMBbG5sRCBqC79euKOcXryKMDer0Y1Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IycSARMxOwY3yw6AqUCim6OfEjg54HdOXEpscNR2AAY8ggUyXlH4azumTj9QSXHv
	 TFo66iXOVdQXrrXDhOw1vXEgOgjSbNzASgc1ZOwfniRb5WUZ6P6bnEzNkHSre1BIYk
	 G2mM4K09fnUMwGKv7Bn2ywAgBvBnnrAVuUDnGzJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 115/197] drm/amdgpu/hdp6: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:39:25 +0200
Message-ID: <20250512172049.061230705@linuxfoundation.org>
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

commit ca28e80abe4219c8f1a2961ae05102d70af6dc87 upstream.

Reading back the remapped HDP flush register seems to cause
problems on some platforms. All we need is a read, so read back
the memcfg register.

Fixes: abe1cbaec6cf ("drm/amdgpu/hdp6.0: do a posting read when flushing HDP")
Reported-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-April/123150.html
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4119
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3908
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 84141ff615951359c9a99696fd79a36c465ed847)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c
@@ -36,7 +36,12 @@ static void hdp_v6_0_flush_hdp(struct am
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


