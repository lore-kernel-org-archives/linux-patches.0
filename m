Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F4433CE9A;
	Mon, 23 Mar 2026 14:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277058; cv=none; b=ZXWfToNjC2D1qRCupDFuTCFv1Gc1xJnJdmj7lcTQyM3wCaMpSXUpWKycTIpPmp6mhcZcZiE+qFOhVjQVrE6DdWDFCg8d36fRSbLj/LcOheaR9QO6GjyPFluBAJ8vr/reyza8rIFDuOw0wVXpiBdHqRJ4TZsKXAsN1pkJ0unCj/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277058; c=relaxed/simple;
	bh=FrN99LkMlR0kaFlwkqCc229h8UXNCG5K4u5Zu8MiNWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k09UwcI3DVJDufyXhk/M2Y7Npoy6WKsBBZNkX0l+ypAsmw+IVS6sbYuqsWwTWdR7MUV7KgcGsgCJgcgO0sHZEWbthYIcmww1NIJlIzc1gdT/kbAN7cjvU3HlySDh5MVG5sd9fvJZTLx9/MuCOc0cIqld88yopYqptRdvhlFhh7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0sAEsjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0sAEsjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F3FC4CEF7;
	Mon, 23 Mar 2026 14:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277058;
	bh=FrN99LkMlR0kaFlwkqCc229h8UXNCG5K4u5Zu8MiNWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0sAEsjqHLXvSPp1V+NnLaHgy9LD3Z9EwBn3jtISwK8o3Rqdlk69nHsdsDEycgeGa
	 Gw7IY0DfzSuuzXfShdbBP8HXdRmtde+Jp8a8i5SaUzsOK6E6fICb415Jc3y/l99xWh
	 KPzCfsd3CisHhgyX+2ucbnS1bj9X3DJum+e8LBFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.12 305/460] drm/amdgpu: Add basic validation for RAS header
Date: Mon, 23 Mar 2026 14:45:01 +0100
Message-ID: <20260323134533.985230802@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 5df0d6addb7e9b6f71f7162d1253762a5be9138e upstream.

If RAS header read from EEPROM is corrupted, it could result in trying
to allocate huge memory for reading the records. Add some validation to
header fields.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ RAS_TABLE_VER_V3 is not supported in v6.6.y. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -1362,15 +1362,31 @@ int amdgpu_ras_eeprom_init(struct amdgpu
 
 	__decode_table_header_from_buf(hdr, buf);
 
-	if (hdr->version == RAS_TABLE_VER_V2_1) {
+	switch (hdr->version) {
+	case RAS_TABLE_VER_V2_1:
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
+
+	if (control->ras_num_recs > control->ras_max_record_count) {
+		dev_err(adev->dev,
+			"RAS header invalid, records in header: %u max allowed :%u",
+			control->ras_num_recs, control->ras_max_record_count);
+		return -EINVAL;
+	}
+
 	control->ras_fri = RAS_OFFSET_TO_INDEX(control, hdr->first_rec_offset);
 
 	if (hdr->header == RAS_TABLE_HDR_VAL) {


