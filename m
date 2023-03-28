Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3382C8476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4D6C433EF;
	Tue, 28 Mar 2023 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015258;
	bh=58D9NaggtejgQVA9VOqwJuLtgerLB+e2QFO7NZOCwsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxK6VQnP6T8lZz4QHKhWlx9jayTFk96DsDJ8Y2JkxMsoeFCQL+A8WdDN8E+T8/CUM
	 wqtDfTMtcQDiVN6bm6Zaa7hKFu4VPPTTCkiRJoCHxEp1OVzdS6uI/VGwbuB+Pxn8AH
	 +urmdw+mBgq+SJr457tE6ofIWYPI8uqPYVLZXwz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 223/240] drm/amdgpu: skip ASIC reset for APUs when go to S4
Date: Tue, 28 Mar 2023 16:43:06 +0200
Message-Id: <20230328142629.017900983@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

commit b589626674de94d977e81c99bf7905872b991197 upstream.

For GC IP v11.0.4/11, PSP TMR need to be reserved
for ASIC mode2 reset. But for S4, when psp suspend,
it will destroy the TMR that fails the ASIC reset.

[  96.006101] amdgpu 0000:62:00.0: amdgpu: MODE2 reset
[  100.409717] amdgpu 0000:62:00.0: amdgpu: SMU: I'm not done with your previous command: SMN_C2PMSG_66:0x00000011 SMN_C2PMSG_82:0x00000002
[  100.411593] amdgpu 0000:62:00.0: amdgpu: Mode2 reset failed!
[  100.412470] amdgpu 0000:62:00.0: PM: pci_pm_freeze(): amdgpu_pmops_freeze+0x0/0x50 [amdgpu] returns -62
[  100.414020] amdgpu 0000:62:00.0: PM: dpm_run_callback(): pci_pm_freeze+0x0/0xd0 returns -62
[  100.415311] amdgpu 0000:62:00.0: PM: pci_pm_freeze+0x0/0xd0 returned -62 after 4623202 usecs
[  100.416608] amdgpu 0000:62:00.0: PM: failed to freeze async: error -62

We can skip the reset on APUs, assuming we can resume them
properly. Verified on some GFX11, GFX10 and old GFX9 APUs.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2457,7 +2457,10 @@ static int amdgpu_pmops_freeze(struct de
 	adev->in_s4 = false;
 	if (r)
 		return r;
-	return amdgpu_asic_reset(adev);
+
+	if (amdgpu_acpi_should_gpu_reset(adev))
+		return amdgpu_asic_reset(adev);
+	return 0;
 }
 
 static int amdgpu_pmops_thaw(struct device *dev)


