Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E78824728E;
	Mon, 23 Jun 2025 13:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685903; cv=none; b=FrgHvUOtrmuG9jzdtyzq8zbFDXQnNf1rHqm8I59PpK+X5NzDHvWCzThjI/lEFtro+3BvExJ2P7biTqwqrgIZSCr/8fFgG2qlJ7yd+2RTLYFLfDWHIAaQxE1uV/O/oFwugExU/aIVwip10ec3QW4r5VzM7G+vkAxBjSlMOkFYYJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685903; c=relaxed/simple;
	bh=supZzu7TKuMJ5i8O0rUdZ/NwgoqwLeKKyJ9q36NlhhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO27yU+SA0GoNNb8OqhuTWMhaPtnz6Le9oOEXeK3IqRP4YbFDNSfoQ0TkLEwNQtK7wsDuluDp3/TWAp3Tq8GnspLUqnT7y+oz835c0LrygxFx5/N0bz3O9govKIWvm18owmFia3gZDV6HuXdiBQFbSKP5iI2VMMWwLz1qm9ISVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16ELnjLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16ELnjLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7479C4CEEA;
	Mon, 23 Jun 2025 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685903;
	bh=supZzu7TKuMJ5i8O0rUdZ/NwgoqwLeKKyJ9q36NlhhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16ELnjLhSg2EjdPRjZjZ6Q2wLP6A8+rt0jEeQVrezbGDXoYno4UIih9DLrs4eiRM9
	 nRsDs0dD8ekiOwl2/9WgtHx3hmnSIZE8YO4ZlYy2HjnKFdTkm1ob+mPI6VEOmor0Wy
	 MA2he8Uctka8JPhD0eZL7N0Ha33OFjhqhPP8clPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 264/592] drm/amdgpu: Add basic validation for RAS header
Date: Mon, 23 Jun 2025 15:03:42 +0200
Message-ID: <20250623130706.591895789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 5df0d6addb7e9b6f71f7162d1253762a5be9138e ]

If RAS header read from EEPROM is corrupted, it could result in trying
to allocate huge memory for reading the records. Add some validation to
header fields.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    | 22 ++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 0ea7cfaf3587d..e979a6086178c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -1392,17 +1392,33 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control)
 
 	__decode_table_header_from_buf(hdr, buf);
 
-	if (hdr->version >= RAS_TABLE_VER_V2_1) {
+	switch (hdr->version) {
+	case RAS_TABLE_VER_V2_1:
+	case RAS_TABLE_VER_V3:
 		control->ras_num_recs = RAS_NUM_RECS_V2_1(hdr);
 		control->ras_record_offset = RAS_RECORD_START_V2_1;
 		control->ras_max_record_count = RAS_MAX_RECORD_COUNT_V2_1;
-	} else {
+		break;
+	case RAS_TABLE_VER_V1:
 		control->ras_num_recs = RAS_NUM_RECS(hdr);
 		control->ras_record_offset = RAS_RECORD_START;
 		control->ras_max_record_count = RAS_MAX_RECORD_COUNT;
+		break;
+	default:
+		dev_err(adev->dev,
+			"RAS header invalid, unsupported version: %u",
+			hdr->version);
+		return -EINVAL;
 	}
-	control->ras_fri = RAS_OFFSET_TO_INDEX(control, hdr->first_rec_offset);
 
+	if (control->ras_num_recs > control->ras_max_record_count) {
+		dev_err(adev->dev,
+			"RAS header invalid, records in header: %u max allowed :%u",
+			control->ras_num_recs, control->ras_max_record_count);
+		return -EINVAL;
+	}
+
+	control->ras_fri = RAS_OFFSET_TO_INDEX(control, hdr->first_rec_offset);
 	control->ras_num_mca_recs = 0;
 	control->ras_num_pa_recs = 0;
 	return 0;
-- 
2.39.5



