Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67757FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C337CC433EF;
	Mon, 15 May 2023 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170576;
	bh=ZnrBVfKxTl5Xc6ux1pwz3Ml/tdKN1jh9iMv8venI6NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eb0qt+sNSz6X5Yd/Igi7DvsjuauPfZS8heOJvOFVpYcjvyzSvQ5UcGkDIQkWsqxb+
	 O0RYelzMiafgO3fSu8r3xuRgJ3q5VOCbRVPKCcSW/Hvko9ZkyPTNguQughqYJZSlNH
	 K5WyGAFFfeU+SlJEI+W7pYuob2hTyoHsc4RMbtqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guchun Chen <guchun.chen@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 174/239] drm/amdgpu: disable sdma ecc irq only when sdma RAS is enabled in suspend
Date: Mon, 15 May 2023 18:27:17 +0200
Message-Id: <20230515161726.887792110@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guchun Chen <guchun.chen@amd.com>

commit 8b229ada2669b74fdae06c83fbfda5a5a99fc253 upstream.

sdma_v4_0_ip is shared on a few asics, but in sdma_v4_0_hw_fini,
driver unconditionally disables ecc_irq which is only enabled on
those asics enabling sdma ecc. This will introduce a warning in
suspend cycle on those chips with sdma ip v4.0, while without
sdma ecc. So this patch correct this.

[ 7283.166354] RIP: 0010:amdgpu_irq_put+0x45/0x70 [amdgpu]
[ 7283.167001] RSP: 0018:ffff9a5fc3967d08 EFLAGS: 00010246
[ 7283.167019] RAX: ffff98d88afd3770 RBX: 0000000000000001 RCX: 0000000000000000
[ 7283.167023] RDX: 0000000000000000 RSI: ffff98d89da30390 RDI: ffff98d89da20000
[ 7283.167025] RBP: ffff98d89da20000 R08: 0000000000036838 R09: 0000000000000006
[ 7283.167028] R10: ffffd5764243c008 R11: 0000000000000000 R12: ffff98d89da30390
[ 7283.167030] R13: ffff98d89da38978 R14: ffffffff999ae15a R15: ffff98d880130105
[ 7283.167032] FS:  0000000000000000(0000) GS:ffff98d996f00000(0000) knlGS:0000000000000000
[ 7283.167036] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7283.167039] CR2: 00000000f7a9d178 CR3: 00000001c42ea000 CR4: 00000000003506e0
[ 7283.167041] Call Trace:
[ 7283.167046]  <TASK>
[ 7283.167048]  sdma_v4_0_hw_fini+0x38/0xa0 [amdgpu]
[ 7283.167704]  amdgpu_device_ip_suspend_phase2+0x101/0x1a0 [amdgpu]
[ 7283.168296]  amdgpu_device_suspend+0x103/0x180 [amdgpu]
[ 7283.168875]  amdgpu_pmops_freeze+0x21/0x60 [amdgpu]
[ 7283.169464]  pci_pm_freeze+0x54/0xc0

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2522
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1941,9 +1941,11 @@ static int sdma_v4_0_hw_fini(void *handl
 		return 0;
 	}
 
-	for (i = 0; i < adev->sdma.num_instances; i++) {
-		amdgpu_irq_put(adev, &adev->sdma.ecc_irq,
-			       AMDGPU_SDMA_IRQ_INSTANCE0 + i);
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__SDMA)) {
+		for (i = 0; i < adev->sdma.num_instances; i++) {
+			amdgpu_irq_put(adev, &adev->sdma.ecc_irq,
+				       AMDGPU_SDMA_IRQ_INSTANCE0 + i);
+		}
 	}
 
 	sdma_v4_0_ctx_switch_enable(adev, false);


