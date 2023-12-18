Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1451D136;
	Mon, 18 Dec 2023 14:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FX1g8eb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02424C433C7;
	Mon, 18 Dec 2023 14:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908880;
	bh=U36Fmca3fYV7urzJy3WHYo/KFajkF8j68ZKIuZJP+mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FX1g8eb6Ox3gjKEl9ASn/Ly9CAFFqwzohmyozh0xz6s7CNHnLTOTYzAxWNE6JP9nq
	 uQsSd7qHEhURmaIOiGY8bf7JUDgnqCCIH1goDYyDdHkgI9C5KX/kBaKVDSqTs84OZh
	 8A7QYn8WT0ADSSGWUyStQ6wb0H9/w2nVK/iVLGvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 68/83] drm/amdgpu/sdma5.2: add begin/end_use ring callbacks
Date: Mon, 18 Dec 2023 14:52:29 +0100
Message-ID: <20231218135052.736319722@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ab4750332dbe535243def5dcebc24ca00c1f98ac upstream.

Add begin/end_use ring callbacks to disallow GFXOFF when
SDMA work is submitted and allow it again afterward.

This should avoid corner cases where GFXOFF is erroneously
entered when SDMA is still active.  For now just allow/disallow
GFXOFF in the begin and end helpers until we root cause the
issue.  This should not impact power as SDMA usage is pretty
minimal and GFXOSS should not be active when SDMA is active
anyway, this just makes it explicit.

v2: move everything into sdma5.2 code.  No reason for this
to be generic at this point.
v3: Add comments in new code

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2220
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com> (v1)
Tested-by: Mario Limonciello <mario.limonciello@amd.com> (v1)
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -1660,6 +1660,32 @@ static void sdma_v5_2_get_clockgating_st
 		*flags |= AMD_CG_SUPPORT_SDMA_LS;
 }
 
+static void sdma_v5_2_ring_begin_use(struct amdgpu_ring *ring)
+{
+	struct amdgpu_device *adev = ring->adev;
+
+	/* SDMA 5.2.3 (RMB) FW doesn't seem to properly
+	 * disallow GFXOFF in some cases leading to
+	 * hangs in SDMA.  Disallow GFXOFF while SDMA is active.
+	 * We can probably just limit this to 5.2.3,
+	 * but it shouldn't hurt for other parts since
+	 * this GFXOFF will be disallowed anyway when SDMA is
+	 * active, this just makes it explicit.
+	 */
+	amdgpu_gfx_off_ctrl(adev, false);
+}
+
+static void sdma_v5_2_ring_end_use(struct amdgpu_ring *ring)
+{
+	struct amdgpu_device *adev = ring->adev;
+
+	/* SDMA 5.2.3 (RMB) FW doesn't seem to properly
+	 * disallow GFXOFF in some cases leading to
+	 * hangs in SDMA.  Allow GFXOFF when SDMA is complete.
+	 */
+	amdgpu_gfx_off_ctrl(adev, true);
+}
+
 const struct amd_ip_funcs sdma_v5_2_ip_funcs = {
 	.name = "sdma_v5_2",
 	.early_init = sdma_v5_2_early_init,
@@ -1707,6 +1733,8 @@ static const struct amdgpu_ring_funcs sd
 	.test_ib = sdma_v5_2_ring_test_ib,
 	.insert_nop = sdma_v5_2_ring_insert_nop,
 	.pad_ib = sdma_v5_2_ring_pad_ib,
+	.begin_use = sdma_v5_2_ring_begin_use,
+	.end_use = sdma_v5_2_ring_end_use,
 	.emit_wreg = sdma_v5_2_ring_emit_wreg,
 	.emit_reg_wait = sdma_v5_2_ring_emit_reg_wait,
 	.emit_reg_write_reg_wait = sdma_v5_2_ring_emit_reg_write_reg_wait,


