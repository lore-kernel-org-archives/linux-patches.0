Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7302512F1;
	Mon, 12 May 2025 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073018; cv=none; b=BkLV0J1WaB1cGLialC9xhK491x2sVxLDZdAHzcRPXQVjDDWqwFLvLx/XzHh9JeyN8trIxcVqxXBTJ2say+ytmryfPpwdWkDCK5w3ErTjN5AiGMYiT6d00RGI3nZUiKgjQ0wlHVlwSVpZGxgcXJ62WzA+VbFWnaV4iGb5DAmxmeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073018; c=relaxed/simple;
	bh=ZkkaKjaS+17UjUz9wDUKy+udxjFLffnsum5nAA8S0tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCXF2NtG9XxwAYiuyFfP+k9stDoWI6XtqrkjIffRiypxOXcjorA3BuCs+BsYLuOIeh/0tgkb4bek0MPWsJ7aaC6AowR3gqg1cLh3LoVtjO57PdYZ95gTt0Mv+2SVY2FdFPPSYpVo/Gt5JIaC0uxmALBM6+DkupkzBouSuidyLjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKf2VDR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKf2VDR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3A8C4CEE9;
	Mon, 12 May 2025 18:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073018;
	bh=ZkkaKjaS+17UjUz9wDUKy+udxjFLffnsum5nAA8S0tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKf2VDR0/D/XKRUR3+sL+eSALKlciDyWad9tLQa/iiXXHmN3PmiMlQkasxQEIAygQ
	 LAJJU0PNttaNqYjEVOuvN5N+uPz36S8VEIR9CPXcj2EKnAGy/UNtC8ly0DDN6PFsig
	 xMvqu3/F5OqXmeYx9ylsSxy6QMcKJ3c1uneA+uVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 099/184] drm/amdgpu/hdp5: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:45:00 +0200
Message-ID: <20250512172045.857263179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0e33e0f339b91eecd9558311449a3d1e728722d4 upstream.

Reading back the remapped HDP flush register seems to cause
problems on some platforms. All we need is a read, so read back
the memcfg register.

Fixes: cf424020e040 ("drm/amdgpu/hdp5.0: do a posting read when flushing HDP")
Reported-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-April/123150.html
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4119
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3908
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a5cb344033c7598762e89255e8ff52827abb57a4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c
@@ -33,7 +33,12 @@ static void hdp_v5_0_flush_hdp(struct am
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


