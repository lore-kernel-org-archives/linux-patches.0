Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC385308F1B;
	Tue, 11 Nov 2025 01:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823880; cv=none; b=JDbw0eMBqxhqiDWwJanMKAg35gpAx4pca/Y0fqfNVuM4TmOtI6uFe1Ak7Vbdzs7uUr7kk8bWqbrcQ/ZgikRuD3ZEMvx/8+J+0Ex+AcfIFri9jnQjz4qkVoZF4qWr95Dj3JSqM48L8S2KpS6YW5lmA5arTKBsc/gZ24SMVIgHkwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823880; c=relaxed/simple;
	bh=TRm8vcrfEsUfbxrFvo69LUk1ilyUPWAFk1Q/RSXBgWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1zywkKh0y/IrXklgb0XzWA9FbddMX+RjGkIyk6/iyLzwUyRRcf1I0Rl/yAktPuMADCZaFqh9INjmbCm4ezESouEzuLBK/X6kWdkgaciIs+w1DfkTAHSxI4T5Z9lk6ajm7WLQ1h2+BfKCEn8n5Qs1eUUYZGnBrLVmVfSkspJrXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4F7sWDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4F7sWDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8CEC19425;
	Tue, 11 Nov 2025 01:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823880;
	bh=TRm8vcrfEsUfbxrFvo69LUk1ilyUPWAFk1Q/RSXBgWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4F7sWDaEAOCeqmmQ7yjpkZPDOMdeaSlN1OoZgq+COBDw2ISuBVG2fpGwbMmB9ZGy
	 TQvPJxYoaaYg1VfMQ5E9cBRBREfwLpgd4PV3uqDodmxooJ5F5EtprjTpjy317tYcVl
	 /XFDnr8RdMgnSExkCk5MiVIUG48TOzz/do5dzQYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 390/849] drm/amdgpu: Notify pmfw bad page threshold exceeded
Date: Tue, 11 Nov 2025 09:39:20 +0900
Message-ID: <20251111004545.861789890@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit c8d6e90abe50377110f92702fbebc6efdd22391d ]

Notify pmfw when bad page threshold is exceeded, no matter the module
parameter 'bad_page_threshold' is set or not.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 9bda9ad13f882..88ded6296be34 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -774,9 +774,10 @@ amdgpu_ras_eeprom_update_header(struct amdgpu_ras_eeprom_control *control)
 				control->tbl_rai.health_percent = 0;
 			}
 			ras->is_rma = true;
-			/* ignore the -ENOTSUPP return value */
-			amdgpu_dpm_send_rma_reason(adev);
 		}
+
+		/* ignore the -ENOTSUPP return value */
+		amdgpu_dpm_send_rma_reason(adev);
 	}
 
 	if (control->tbl_hdr.version >= RAS_TABLE_VER_V2_1)
-- 
2.51.0



