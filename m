Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D9183CC8;
	Thu,  5 Sep 2024 09:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530344; cv=none; b=FqcmcN2ve126ny/dCWoSqL86wfMQBpqjgURhM+WzFnl44cv1bjnd2g6LWrkzeLlVynR0DafK6GWktQCOmcnqCQyFR/cLfcwciqsjXO8zzUZfzOoQp0xqpuEZ6J4dAh8eaYjFJSDftiOmyAXcpUQLDH+3ZA/bXq/VVwHKhuKyRKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530344; c=relaxed/simple;
	bh=vg1ME29IRyun6Buz6+mknhlBoCMDqx1+krR4+Pvoz8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VElh7vnOMtN8wM171WzB45TCtrlhkumunPzJLTX0SizJ1v5OHUKbzZ/6/2fxm3QIZdKvf2glHGzqBjc0cz0G/YLar1L7RHYLAKjyQszxHgSYjSGjlRhEG0EACNvfdKpzlZklxwVmJXSPmm2VzpHVQCIHcOPSpQ4JgsO5NwcBv78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5vE5msW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5vE5msW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AE8C4CEC3;
	Thu,  5 Sep 2024 09:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530343;
	bh=vg1ME29IRyun6Buz6+mknhlBoCMDqx1+krR4+Pvoz8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5vE5msWywNOGytQToYdUwyI5r+A0z+UkfvrqCPGuHmGU523iQHVrOq9CJlezicqX
	 c5WA3QLtmA+puawgMinb1YaN1X1oYBl7HDY0vjYJ8vrBgdFuXdOHhZuwXTVpLdlxjg
	 OdnyBbZ9Uli/Dxj6py/WPk22Ri2smhQBR7dFI5JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/132] drm/amd/display: Check BIOS images before it is used
Date: Thu,  5 Sep 2024 11:41:54 +0200
Message-ID: <20240905093727.152467411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 8b0ddf19cca2a352b2a7e01d99d3ba949a99c84c ]

BIOS images may fail to load and null checks are added before they are
used.

This fixes 6 NULL_RETURNS issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
index 19cd1bd844df..684b005f564c 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
@@ -667,6 +667,9 @@ static enum bp_result get_ss_info_v3_1(
 	ss_table_header_include = ((ATOM_ASIC_INTERNAL_SS_INFO_V3 *) bios_get_image(&bp->base,
 				DATA_TABLES(ASIC_InternalSS_Info),
 				struct_size(ss_table_header_include, asSpreadSpectrum, 1)));
+	if (!ss_table_header_include)
+		return BP_RESULT_UNSUPPORTED;
+
 	table_size =
 		(le16_to_cpu(ss_table_header_include->sHeader.usStructureSize)
 				- sizeof(ATOM_COMMON_TABLE_HEADER))
@@ -1036,6 +1039,8 @@ static enum bp_result get_ss_info_from_internal_ss_info_tbl_V2_1(
 				&bp->base,
 				DATA_TABLES(ASIC_InternalSS_Info),
 				struct_size(header, asSpreadSpectrum, 1)));
+	if (!header)
+		return result;
 
 	memset(info, 0, sizeof(struct spread_spectrum_info));
 
@@ -1109,6 +1114,8 @@ static enum bp_result get_ss_info_from_ss_info_table(
 	get_atom_data_table_revision(header, &revision);
 
 	tbl = GET_IMAGE(ATOM_SPREAD_SPECTRUM_INFO, DATA_TABLES(SS_Info));
+	if (!tbl)
+		return result;
 
 	if (1 != revision.major || 2 > revision.minor)
 		return result;
@@ -1636,6 +1643,8 @@ static uint32_t get_ss_entry_number_from_ss_info_tbl(
 
 	tbl = GET_IMAGE(ATOM_SPREAD_SPECTRUM_INFO,
 			DATA_TABLES(SS_Info));
+	if (!tbl)
+		return number;
 
 	if (1 != revision.major || 2 > revision.minor)
 		return number;
@@ -1718,6 +1727,8 @@ static uint32_t get_ss_entry_number_from_internal_ss_info_tbl_v2_1(
 				&bp->base,
 				DATA_TABLES(ASIC_InternalSS_Info),
 				struct_size(header_include, asSpreadSpectrum, 1)));
+	if (!header_include)
+		return 0;
 
 	size = (le16_to_cpu(header_include->sHeader.usStructureSize)
 			- sizeof(ATOM_COMMON_TABLE_HEADER))
@@ -1756,6 +1767,9 @@ static uint32_t get_ss_entry_number_from_internal_ss_info_tbl_V3_1(
 	header_include = ((ATOM_ASIC_INTERNAL_SS_INFO_V3 *) bios_get_image(&bp->base,
 				DATA_TABLES(ASIC_InternalSS_Info),
 				struct_size(header_include, asSpreadSpectrum, 1)));
+	if (!header_include)
+		return number;
+
 	size = (le16_to_cpu(header_include->sHeader.usStructureSize) -
 			sizeof(ATOM_COMMON_TABLE_HEADER)) /
 					sizeof(ATOM_ASIC_SS_ASSIGNMENT_V3);
-- 
2.43.0



