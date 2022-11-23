Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB2B1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AC8C433D6;
	Wed, 23 Nov 2022 09:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197166;
	bh=GylouvC0mD/Wmx9YJ2djSRQJ3H4H1N+tXd0yuKM8VKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3E2ZwUoD5Jz1QjZ2SMPJbCpRN0RSbKFY8NXOS8Cdlps5lkXPbiR9/inaPcCj7Zbq
	 awePSc8AHBgxpG7bvigfRkvNzFAZsqFBMwDRn/EUh9wjfC99JT4NVw4mECDMnRdGjY
	 NRDqhu+bRHP3k+9MAle5//WKX7W/KFHPk1lL19OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 217/314] drm/amd/display: Support parsing VRAM info v3.0 from VBIOS
Date: Wed, 23 Nov 2022 09:51:02 +0100
Message-Id: <20221123084635.371789234@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Shen <george.shen@amd.com>

commit 7e952a18eb978a3e51fc1704b752378be66226b2 upstream.

[Why]
For DCN3.2 and DCN3.21, VBIOS has switch to using v3.0 of the VRAM
info struct. We should read and override the VRAM info in driver with
values provided by VBIOS to support memory downbin cases.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   30 +++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -2392,6 +2392,26 @@ static enum bp_result get_vram_info_v25(
 	return result;
 }
 
+static enum bp_result get_vram_info_v30(
+	struct bios_parser *bp,
+	struct dc_vram_info *info)
+{
+	struct atom_vram_info_header_v3_0 *info_v30;
+	enum bp_result result = BP_RESULT_OK;
+
+	info_v30 = GET_IMAGE(struct atom_vram_info_header_v3_0,
+						DATA_TABLES(vram_info));
+
+	if (info_v30 == NULL)
+		return BP_RESULT_BADBIOSTABLE;
+
+	info->num_chans = info_v30->channel_num;
+	info->dram_channel_width_bytes = (1 << info_v30->channel_width) / 8;
+
+	return result;
+}
+
+
 /*
  * get_integrated_info_v11
  *
@@ -3022,6 +3042,16 @@ static enum bp_result bios_parser_get_vr
 				break;
 			default:
 				break;
+			}
+			break;
+
+		case 3:
+			switch (revision.minor) {
+			case 0:
+				result = get_vram_info_v30(bp, info);
+				break;
+			default:
+				break;
 			}
 			break;
 


