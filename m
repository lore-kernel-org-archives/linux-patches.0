Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBDC19049B;
	Mon, 12 May 2025 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073021; cv=none; b=Kka79HMJDSvSbrD/qYGG57h90mELNvHk0dbRx/7FpZX63ZsEZtufxZgkhMOaswvguDXBWLrkHzrjR7xfc7z7Bp/QaXCrkJO/hviMhvplUuRyABfVP8rQzFGc37MSlXtjac/hZWp1gWJKrJC5PMbY7z9XLofs8kG0blyGuFehfrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073021; c=relaxed/simple;
	bh=GPvaLTbfXVXgbIUzy6xz5hWHsnQzqGKS8+c0ekYmOaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrk1AWCT9LCewGHQn5QmI7u/sEUAAHs9/TXWZdmZPYH84vjan1cea0alc/tHJIK+K2kf4xWBDQZmxfxMgWHdCP6OD+Od7F0n7vyZFn/BEkSCm0HohRiS0TfdVqpnpfmpj/lx9pjQBbc6j5GXHVulkFWZnfVRL1Hiq5msu2O1N/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hK3i4B48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hK3i4B48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF42C4CEE7;
	Mon, 12 May 2025 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073021;
	bh=GPvaLTbfXVXgbIUzy6xz5hWHsnQzqGKS8+c0ekYmOaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hK3i4B48dcmCbH9q46gefYJUsCWQhQW+Iyg7+qvtmlm/iTRnOOt1oG9QzoJ23OB4q
	 vkw5K1C1RzkYRcQlmoqwXFeti9s3ytg9DifFzP/5dBx/KwODxX2dqBJm0PO2p2NtDj
	 FwDFChbO9ofajQycF6G+LizDHwDixFbmWDFVMP5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 100/184] drm/amdgpu/hdp6: use memcfg register to post the write for HDP flush
Date: Mon, 12 May 2025 19:45:01 +0200
Message-ID: <20250512172045.897251398@linuxfoundation.org>
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


