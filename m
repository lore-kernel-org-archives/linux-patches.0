Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5AC29AB10;
	Mon, 12 May 2025 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073470; cv=none; b=O8yOV3gU7+q143JNDCH46+Sut3vf57LbK1zPxMoj3Yc9bAjC0JFk3muDHeaTiyuv7KEGyAVZzLcInpCWCwOTqDGicb0Jm4+b6DIl745mO1gaydcEmZKbCd9JRyvLOAhEP12hUIHtoyGBCBLfJj0z4fu8E7et4bIWRsr6kOREiGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073470; c=relaxed/simple;
	bh=iJbDfV9InMGI2hAQifufxv24+4EYjKksiylJlSkjOak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk6D6hkre4sgAtpufTLLdWRDeing4sekYS+MHm6STqjtLU5NW8IBwzsGX6Rb6biZptVErPWe9kMkXqcUvxW7Iooe6nohWboKvmVuncUmSPXoZfVNHBKCz1gKjAZo2iUQtdg5o30f9hy/E9WEFcknC/gYRgBAxsDMEmOmfcO2044=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2bB9ZXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2bB9ZXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56535C4CEE7;
	Mon, 12 May 2025 18:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073469;
	bh=iJbDfV9InMGI2hAQifufxv24+4EYjKksiylJlSkjOak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2bB9ZXChEhG+iM11vpCPOX4mcbBmH7TDy5r98gLq89m50848D2rbdmA7pysWs/zk
	 jaNzPX0LPHzpzCw34fRVWpiuWFkoa0Sj9vtZSFauQ5d08PKGCMzWgHFO/gfgD0PBmr
	 b8D+C4yb7ldpwHDSGkQFhTRUi6nxYD5g47hJsxsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 056/113] drm/amdgpu/hdp6: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:45:45 +0200
Message-ID: <20250512172029.947568565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -33,7 +33,12 @@ static void hdp_v6_0_flush_hdp(struct am
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


