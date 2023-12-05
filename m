Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957D36AA0;
	Tue,  5 Dec 2023 03:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjLSt8bI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDF2C433C8;
	Tue,  5 Dec 2023 03:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746499;
	bh=oFCEMIhSfMizectqlBb1XTmZwX7OQikOgYmjMN20yE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjLSt8bIuTKr5gBQkylf73cU223BJrw84pIIaEMPwLQCIvozmRPc74v5HEt+HfUkJ
	 zP2CXZKt2AzC3bXWsUDZpsQj9jcFfgK+L+Lt9ziQvX/IC2mOW8egIvOjlZIzwWc7WG
	 DN5ND6THdQU4+83FmW4h+ClsFeIwjh9JMg8kfZgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Sierra <alex.sierra@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH 6.6 028/134] drm/amdgpu: Force order between a read and write to the same address
Date: Tue,  5 Dec 2023 12:15:00 +0900
Message-ID: <20231205031537.210246980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Sierra <alex.sierra@amd.com>

commit 4b27a33c3b173bef1d19ba89e0b9b812b4fddd25 upstream.

Setting register to force ordering to prevent read/write or write/read
hazards for un-cached modes.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c                     |    8 ++++++++
 drivers/gpu/drm/amd/include/asic_reg/gc/gc_11_0_0_offset.h |    2 ++
 2 files changed, 10 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -83,6 +83,10 @@ MODULE_FIRMWARE("amdgpu/gc_11_0_4_me.bin
 MODULE_FIRMWARE("amdgpu/gc_11_0_4_mec.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_4_rlc.bin");
 
+static const struct soc15_reg_golden golden_settings_gc_11_0[] = {
+	SOC15_REG_GOLDEN_VALUE(GC, 0, regTCP_CNTL, 0x20000000, 0x20000000)
+};
+
 static const struct soc15_reg_golden golden_settings_gc_11_0_1[] =
 {
 	SOC15_REG_GOLDEN_VALUE(GC, 0, regCGTT_GS_NGG_CLK_CTRL, 0x9fff8fff, 0x00000010),
@@ -275,6 +279,10 @@ static void gfx_v11_0_init_golden_regist
 	default:
 		break;
 	}
+	soc15_program_register_sequence(adev,
+					golden_settings_gc_11_0,
+					(const u32)ARRAY_SIZE(golden_settings_gc_11_0));
+
 }
 
 static void gfx_v11_0_write_data_to_reg(struct amdgpu_ring *ring, int eng_sel,
--- a/drivers/gpu/drm/amd/include/asic_reg/gc/gc_11_0_0_offset.h
+++ b/drivers/gpu/drm/amd/include/asic_reg/gc/gc_11_0_0_offset.h
@@ -6369,6 +6369,8 @@
 #define regTCP_INVALIDATE_BASE_IDX                                                                      1
 #define regTCP_STATUS                                                                                   0x19a1
 #define regTCP_STATUS_BASE_IDX                                                                          1
+#define regTCP_CNTL                                                                                     0x19a2
+#define regTCP_CNTL_BASE_IDX                                                                            1
 #define regTCP_CNTL2                                                                                    0x19a3
 #define regTCP_CNTL2_BASE_IDX                                                                           1
 #define regTCP_DEBUG_INDEX                                                                              0x19a5


