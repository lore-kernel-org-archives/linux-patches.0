Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBD35172E9;
	Thu, 17 Sep 2026 16:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664283; cv=none; b=sXGvkyqi35+NZ6i9ZZDmITx8iwTfrUQygZP75vbJua9wJo+RQjJAGudlCWpXG5pcZ/CpgxDw73MxlmvC4UNqTEqSGW+KeNQ9n+b5o5aUkTNjSWhQ5DYrPTHO5fCvOI7mChxVWVrcGRCA+xmti3hVVBcT/+AW1MuTeUg35m4KoYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664283; c=relaxed/simple;
	bh=guD9x3xmadxka0hAKDx+k4H4Xjt67YNSf/xBzu04uMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akjltOd5e1AXj8VV1gjPfl+6CUxgJAr7uQUx3emzNejwvWiPXCTh03Z8XQIbOj7vEk1aRD54dRs6jTNyM30CRptMxD2e5Y8Zoxrr9Vwc7OMWxqLn5ecVTZSpn7+JmZtA8nAzgsdSFA4nKxcCN+gZZ/wJzyyK2XeRF/PRk8mW5vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSZpEXpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSZpEXpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152A41F000FF;
	Thu, 17 Sep 2026 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664282;
	bh=p1EczhsQ3smNSAf6+lyBmJrn3NqbCMQ9FTPMoX7ehcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSZpEXpyhpNgqc3um2sQp/3Pw+KVESYfOoAf/2BiJsXmrbqjTK5xiDQuLkiZxJtnF
	 Q1wG9npbTwUXj6Z2L4Jil6UpO7nz6Xn5SgZOxLSvaBQP5gPXNyA0YrOShD8vWeHoJT
	 ZkR1ueI2TC23PMxnllQeU1kksnKEXuDFm9Zb+vq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0320/1250] drm/amdgpu: validate RAS EEPROM tbl_size before record count
Date: Thu, 17 Sep 2026 16:01:55 +0100
Message-ID: <20260917151600.774141404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

[ Upstream commit c83e4a45ff9a0b7aa1c48246102009a99ccef11b ]

Corrupt EEPROM data can set tbl_size below the table header size.
Guard the RAS_NUM_RECS macros against undersized tbl_size and reset
the table during init when tbl_size is below the minimum for the table
version instead of trusting the header.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c    | 26 +++++++++++++++----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 652aa085b6263..51382d604b1f0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -142,12 +142,15 @@
 #define RAS_RI_TO_AI(_C, _I) (((_I) + (_C)->ras_fri) % \
 			      (_C)->ras_max_record_count)
 
-#define RAS_NUM_RECS(_tbl_hdr)  (((_tbl_hdr)->tbl_size - \
-				  RAS_TABLE_HEADER_SIZE) / RAS_TABLE_RECORD_SIZE)
+#define RAS_NUM_RECS(_tbl_hdr) \
+	(((_tbl_hdr)->tbl_size < RAS_TABLE_HEADER_SIZE) ? 0u : \
+	 (((_tbl_hdr)->tbl_size - RAS_TABLE_HEADER_SIZE) / RAS_TABLE_RECORD_SIZE))
 
-#define RAS_NUM_RECS_V2_1(_tbl_hdr)  (((_tbl_hdr)->tbl_size - \
-				       RAS_TABLE_HEADER_SIZE - \
-				       RAS_TABLE_V2_1_INFO_SIZE) / RAS_TABLE_RECORD_SIZE)
+#define RAS_NUM_RECS_V2_1(_tbl_hdr) \
+	(((_tbl_hdr)->tbl_size < RAS_TABLE_HEADER_SIZE + \
+	  RAS_TABLE_V2_1_INFO_SIZE) ? 0u : \
+	 (((_tbl_hdr)->tbl_size - RAS_TABLE_HEADER_SIZE - \
+	   RAS_TABLE_V2_1_INFO_SIZE) / RAS_TABLE_RECORD_SIZE))
 
 #define to_amdgpu_device(x) ((container_of(x, struct amdgpu_ras, eeprom_control))->adev)
 
@@ -1415,11 +1418,24 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control)
 	switch (hdr->version) {
 	case RAS_TABLE_VER_V2_1:
 	case RAS_TABLE_VER_V3:
+		if (hdr->tbl_size < RAS_TABLE_HEADER_SIZE + RAS_TABLE_V2_1_INFO_SIZE) {
+			dev_err(adev->dev,
+				"RAS header invalid, tbl_size %u smaller than minimum %u, resetting table\n",
+				hdr->tbl_size,
+				RAS_TABLE_HEADER_SIZE + RAS_TABLE_V2_1_INFO_SIZE);
+			return amdgpu_ras_eeprom_reset_table(control);
+		}
 		control->ras_num_recs = RAS_NUM_RECS_V2_1(hdr);
 		control->ras_record_offset = RAS_RECORD_START_V2_1;
 		control->ras_max_record_count = RAS_MAX_RECORD_COUNT_V2_1;
 		break;
 	case RAS_TABLE_VER_V1:
+		if (hdr->tbl_size < RAS_TABLE_HEADER_SIZE) {
+			dev_err(adev->dev,
+				"RAS header invalid, tbl_size %u smaller than minimum %u, resetting table\n",
+				hdr->tbl_size, RAS_TABLE_HEADER_SIZE);
+			return amdgpu_ras_eeprom_reset_table(control);
+		}
 		control->ras_num_recs = RAS_NUM_RECS(hdr);
 		control->ras_record_offset = RAS_RECORD_START;
 		control->ras_max_record_count = RAS_MAX_RECORD_COUNT;
-- 
2.53.0



