Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727ED2C3746;
	Mon, 12 May 2025 18:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073464; cv=none; b=ccvfTuANDktHqiEkyheB1vxq2kJUukxEJRIRDXTc6Ci8fO6DqaqG3NNN48S3qcn1j/Ar2kiY39KQA0EmF1OqRn2IoBpvN59gtdVxjiycGoz24WxmTRg+9apzTS9T7FFUeeFeokJEnEOmn5SBzdCqi2OG0819H6fpR6uuVxa2RwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073464; c=relaxed/simple;
	bh=8aUfGnDUAkPXvqElvcJszNxmgOgSO9JkJ2DCYmpj4KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQN5D1/82YS4fwh3oVC9oLZ6YrWdBEzScWcn7Gb3B/o9L/0ZCEW7NZV2BCTwlU7Z/Yfx28gqwSegs8G4E02p/2ikYHjyEZQnYa8h5dkupFJMLIDKOVaQAl0E65nZ+Y1eveFACzFNGx3PNjUv6oEMf1IpY4hk2Kl5GVm9Jobe8ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ud9WQCl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ud9WQCl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765A0C4CEE7;
	Mon, 12 May 2025 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073464;
	bh=8aUfGnDUAkPXvqElvcJszNxmgOgSO9JkJ2DCYmpj4KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ud9WQCl4dpT9g2wJMFxAXvL0JmgKUq9hg+ajIHHnVg1z/yiuUjeV58x50iSXHaBj6
	 moqA5fABwoTJ280GOXXwT6tlv+nA+468ufIPSggEoAVwGH0BhGbOMO8KJn1zDRAtsa
	 FBL2ELFSlI02+nvfac+lFW+gT2mm+0ijI2SJapCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 054/113] drm/amdgpu/hdp5.2: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:45:43 +0200
Message-ID: <20250512172029.869426364@linuxfoundation.org>
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


