Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE971A08CA;
	Mon, 12 May 2025 18:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073015; cv=none; b=jSnxusF2ulruIoIJSoz82V2VbzdM+YkqBrd6LxzxUowllvVpnEWjBedn2/mkaerKRNKWV15PYyeVAsZMsZcs1LVRAEaS3E9IaakH6+pbz7PznpKl1r12j8FMrxMBU4/7jzeYJQS17WezyOsV7utnnRhguSLYZtDserPwlS60FTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073015; c=relaxed/simple;
	bh=D1t69JbnBDFbtOZiJj7usr9DBFd0lgTCboA94TH/s+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtgVBj0NXeGqOBhxZ4CG5VmWHoz+RgsttqGW0ebqfKVTuvS7oCnAS1gMsgMP1/QmyZCZa+DymuD3ivuaivmSy5E1UHTQGpJSc+fyRPytvWjZa6sLBxsfOeWoctV7t9CvXcSwLNtp1gWJv6o8Z3l27JnZdt8MD9oabczVmsF/290=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOWzR7rM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOWzR7rM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BE5C4CEE7;
	Mon, 12 May 2025 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073015;
	bh=D1t69JbnBDFbtOZiJj7usr9DBFd0lgTCboA94TH/s+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOWzR7rM5FEM/0zBERPIbl0gKcpd//KtF6cF9YCnQv+7PLYWgK5Qar+4+ylRJHKyu
	 dFqA51XjX15sw/V2E50qcvjGffN1614ZEQE1WjGWkZxPvMCnpNQANax/SCu/upMQ4t
	 9SvOwAbzJvblWVssyJ3RhLvuFswIpvciTFrX/SEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 098/184] drm/amdgpu/hdp5.2: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:44:59 +0200
Message-ID: <20250512172045.815556141@linuxfoundation.org>
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

commit dbc988c689333faeeed44d5561f372ff20395304 upstream.

Reading back the remapped HDP flush register seems to cause
problems on some platforms. All we need is a read, so read back
the memcfg register.

Fixes: f756dbac1ce1 ("drm/amdgpu/hdp5.2: do a posting read when flushing HDP")
Reported-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-April/123150.html
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4119
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3908
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4a89b7698e771914b4d5b571600c76e2fdcbe2a9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c
@@ -34,7 +34,17 @@ static void hdp_v5_2_flush_hdp(struct am
 	if (!ring || !ring->funcs->emit_wreg) {
 		WREG32_NO_KIQ((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2,
 			0);
-		RREG32_NO_KIQ((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2);
+		if (amdgpu_sriov_vf(adev)) {
+			/* this is fine because SR_IOV doesn't remap the register */
+			RREG32_NO_KIQ((adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2);
+		} else {
+			/* We just need to read back a register to post the write.
+			 * Reading back the remapped register causes problems on
+			 * some platforms so just read back the memory size register.
+			 */
+			if (adev->nbio.funcs->get_memsize)
+				adev->nbio.funcs->get_memsize(adev);
+		}
 	} else {
 		amdgpu_ring_emit_wreg(ring,
 			(adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL) >> 2,


