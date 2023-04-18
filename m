Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90861257D
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EF3C4339B;
	Tue, 18 Apr 2023 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822304;
	bh=/D4nHdOgubPpYjY6rrUOP3UQHzHPzlTIcnEkY36hxPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vo9dcYNU1wEShDawMY4GpgF5R6/oIhokQQwEq/yIx1KZ7SBpu7g9ciMAglQfXNIB8
	 11nAeHZca9Rrn8miUiyD/JtWMFpM1ye2J7LqU9ZoqapnXcDpfvIXAGZwOIN5C7C0X2
	 aXN7ysQKZ5ocFrd+2XHrE0O/qeEaj0GcQMmpCamY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jane Jian <Jane.Jian@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 098/139] drm/amdgpu/gfx: set cg flags to enter/exit safe mode
Date: Tue, 18 Apr 2023 14:22:43 +0200
Message-Id: <20230418120317.462582580@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jane Jian <Jane.Jian@amd.com>

[ Upstream commit e06bfcc1a1c41bcb8c31470d437e147ce9f0acfd ]

sriov needs to enter/exit safe mode in update umd p state
add the cg flag to let it enter or exit while needed

Signed-off-by: Jane Jian <Jane.Jian@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c748d92cec8e7..ddb7b8651ab4c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1315,6 +1315,11 @@ static int gfx_v11_0_sw_init(void *handle)
 		break;
 	}
 
+	/* Enable CG flag in one VF mode for enabling RLC safe mode enter/exit */
+	if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(11, 0, 3) &&
+		amdgpu_sriov_is_pp_one_vf(adev))
+		adev->cg_flags = AMD_CG_SUPPORT_GFX_CGCG;
+
 	/* EOP Event */
 	r = amdgpu_irq_add_id(adev, SOC21_IH_CLIENTID_GRBM_CP,
 			      GFX_11_0_0__SRCID__CP_EOP_INTERRUPT,
-- 
2.39.2



