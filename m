Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACD61DF754;
	Mon, 12 May 2025 18:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073012; cv=none; b=QXNQGrcSLC6uS5ZUoIoGpPff4rqMtPjesMdhHeUDbaUB+xsuxRfE3/2UDriBroMLI+ZXAcmnRVqIjmjHCcKHwtzQaKZ9kj3dsAOVJH4VIWV4FNDTMuSzOFCzqseCao6IdWvCBl+IeXVl0B+IoiyXkqssUcse6hr4X20+JlYGtMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073012; c=relaxed/simple;
	bh=QvHIdjj2MemaHUO2f7fg9Kooaos7+1vEBHbTtUPYKVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i23DFxy22T5EyToIWdLL5Ybn6jVRU4t3UwemQuK0+U6WwB80k5FIz/P+EOhVY9oyWwRzBtVWcrtJhFEp9TaO9vSTXO4YaCfbiHPEzncAHnclpqkwGqdqy+O36rB2XFOuQ1byMj+PKCl4ohmHTyJ4uigEQjH+Om4XC1j9JvbhwRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPcJz3WE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPcJz3WE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761C5C4CEE7;
	Mon, 12 May 2025 18:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073011;
	bh=QvHIdjj2MemaHUO2f7fg9Kooaos7+1vEBHbTtUPYKVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPcJz3WEWGMipt50C9QfMlyc6awrs+K9gysYlczAAXk/Z1e8z2e6DcVarvckn4cix
	 JJU/iPjMSdCwvvJE3o1RfteKRoGj5XheZHRMkxAAk1TX7LU9VCzT/M0g3h48lr/3QH
	 qbKuxGdrBVVU1kB4y8IJvk0VOenF1EP46199y3Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 097/184] drm/amdgpu/hdp4: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:44:58 +0200
Message-ID: <20250512172045.776246938@linuxfoundation.org>
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

commit f690e3974755a650259a45d71456decc9c96a282 upstream.

Reading back the remapped HDP flush register seems to cause
problems on some platforms. All we need is a read, so read back
the memcfg register.

Fixes: c9b8dcabb52a ("drm/amdgpu/hdp4.0: do a posting read when flushing HDP")
Reported-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://lists.freedesktop.org/archives/amd-gfx/2025-April/123150.html
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4119
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3908
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5c937b4a6050316af37ef214825b6340b5e9e391)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c
@@ -42,7 +42,12 @@ static void hdp_v4_0_flush_hdp(struct am
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


