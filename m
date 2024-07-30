Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDD214831F;
	Tue, 30 Jul 2024 16:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358126; cv=none; b=E8/az0P84XN8qGC9txDwQ5NZGcQ03Fu/H73K81cfchuLPbRwxHVKlnKA1QrMeyALByzPXif9TaAOntYUqnh8eEEs8r3xxNQPtTzTBhSZRMjZtM0xNp78ZSxInUFnAXfQ+nrLkp0vkZlSp3U98D4763DQX07F/2UbjKlDQMfMZjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358126; c=relaxed/simple;
	bh=Mz5BI1bWeg0IVdOPJNVl/fYCrY7dGJZS3i1S5u0dmQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTmXfNazvPspbYEQTucjfxa3RtU1sqZ89dYVSc56+rEUWFG2CTP5/Seq8bJB7SglHTfkrn/SsfyvE3lm2qXf2QbiLyskcHDqo+C+rY7WJvFvk37+Tk8BStEkikH1zfGy2oUkq24Fv26b+8uagy18lXktxMzW/0tKis7CdpaPK08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8OppjsA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8OppjsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4186C32782;
	Tue, 30 Jul 2024 16:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358126;
	bh=Mz5BI1bWeg0IVdOPJNVl/fYCrY7dGJZS3i1S5u0dmQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8OppjsAy3epO9C3fbCaNjr5ph2VENeWIgCRA6vdlsVmeggWfFjXH2fw6+NHgTrx4
	 q53QRH24QdqhY1BnUZip1Zm7yolLoVIqImHTnyjg0XWuFFpVMOoyVBY/Sr5CmBGS/W
	 Aq9OHYWg1pt7h9InypbmVKaU3iqbE/Ypr+IayGug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Friedrich Vock <friedrich.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 359/440] drm/amdgpu/sdma5.2: Update wptr registers as well as doorbell
Date: Tue, 30 Jul 2024 17:49:52 +0200
Message-ID: <20240730151629.837603794@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit a03ebf116303e5d13ba9a2b65726b106cb1e96f6 upstream.

We seem to have a case where SDMA will sometimes miss a doorbell
if GFX is entering the powergating state when the doorbell comes in.
To workaround this, we can update the wptr via MMIO, however,
this is only safe because we disallow gfxoff in begin_ring() for
SDMA 5.2 and then allow it again in end_ring().

Enable this workaround while we are root causing the issue with
the HW team.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/3440
Tested-by: Friedrich Vock <friedrich.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
(cherry picked from commit f2ac52634963fc38e4935e11077b6f7854e5d700)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -241,6 +241,14 @@ static void sdma_v5_2_ring_set_wptr(stru
 		DRM_DEBUG("calling WDOORBELL64(0x%08x, 0x%016llx)\n",
 				ring->doorbell_index, ring->wptr << 2);
 		WDOORBELL64(ring->doorbell_index, ring->wptr << 2);
+		/* SDMA seems to miss doorbells sometimes when powergating kicks in.
+		 * Updating the wptr directly will wake it. This is only safe because
+		 * we disallow gfxoff in begin_use() and then allow it again in end_use().
+		 */
+		WREG32(sdma_v5_2_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR),
+		       lower_32_bits(ring->wptr << 2));
+		WREG32(sdma_v5_2_get_reg_offset(adev, ring->me, mmSDMA0_GFX_RB_WPTR_HI),
+		       upper_32_bits(ring->wptr << 2));
 	} else {
 		DRM_DEBUG("Not using doorbell -- "
 				"mmSDMA%i_GFX_RB_WPTR == 0x%08x "
@@ -1705,6 +1713,10 @@ static void sdma_v5_2_ring_begin_use(str
 	 * but it shouldn't hurt for other parts since
 	 * this GFXOFF will be disallowed anyway when SDMA is
 	 * active, this just makes it explicit.
+	 * sdma_v5_2_ring_set_wptr() takes advantage of this
+	 * to update the wptr because sometimes SDMA seems to miss
+	 * doorbells when entering PG.  If you remove this, update
+	 * sdma_v5_2_ring_set_wptr() as well!
 	 */
 	amdgpu_gfx_off_ctrl(adev, false);
 }


