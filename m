Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A270223E7D;
	Thu, 12 Dec 2024 16:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021572; cv=none; b=PVPvReppGEjIxkL2NfncW3uvtiNU97RGzDBWmo0OS802NTK0fRrBTAOFXqCyGktjO5ySARFHwZaRSOfnTbVize5219j4jYEA0s8ibui5O4c5EJuhwQAFAIG6a+bY37SiZdzDDjEHRdI77+nwwNYzE3JOoXksILPRrxXK1rSkEso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021572; c=relaxed/simple;
	bh=CXNYyX1VOaMr40HzGaZhoFYA0ljhpFFUEr1pINnsSfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ns+f/AE+kPyAnyc3rlm3y/6PY6Avgwm7pF43ej4W0XMMjbe5VU0ixh9grOYielHJH7KotqekzqmxaJia0l3EV/v+tfbVS4uR/Z9VNroS4Ha6w1V83xZ1A2bb0tqDD1Yb9pwR1wTf561GPkuxzEj7PFFJU1W12TM78GyaqfZIetE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyTV1bpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyTV1bpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF70C4CECE;
	Thu, 12 Dec 2024 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021572;
	bh=CXNYyX1VOaMr40HzGaZhoFYA0ljhpFFUEr1pINnsSfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyTV1bpHn0vKpTG6yC/ld1+Es5v7hMfhuQcsjGcJry7F5XN4M7Cd7/D3QwW5g2tZ3
	 e+NO8jD+/gnObrsqgo7Vxr8GMvJjx2QcUrfSOi0pxZly3AH7EEQI+RiILxN7L9V2kr
	 11nHag3cZYmsMhqKVt/ZKUG1raotYES34Wne4e44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 6.1 749/772] drm/amd/display: Check BIOS images before it is used
Date: Thu, 12 Dec 2024 16:01:34 +0100
Message-ID: <20241212144420.879705083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit 8b0ddf19cca2a352b2a7e01d99d3ba949a99c84c upstream.

BIOS images may fail to load and null checks are added before they are
used.

This fixes 6 NULL_RETURNS issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
@@ -664,6 +664,9 @@ static enum bp_result get_ss_info_v3_1(
 
 	ss_table_header_include = GET_IMAGE(ATOM_ASIC_INTERNAL_SS_INFO_V3,
 		DATA_TABLES(ASIC_InternalSS_Info));
+	if (!ss_table_header_include)
+		return BP_RESULT_UNSUPPORTED;
+
 	table_size =
 		(le16_to_cpu(ss_table_header_include->sHeader.usStructureSize)
 				- sizeof(ATOM_COMMON_TABLE_HEADER))
@@ -1031,6 +1034,8 @@ static enum bp_result get_ss_info_from_i
 
 	header = GET_IMAGE(ATOM_ASIC_INTERNAL_SS_INFO_V2,
 		DATA_TABLES(ASIC_InternalSS_Info));
+	if (!header)
+		return result;
 
 	memset(info, 0, sizeof(struct spread_spectrum_info));
 
@@ -1104,6 +1109,8 @@ static enum bp_result get_ss_info_from_s
 	get_atom_data_table_revision(header, &revision);
 
 	tbl = GET_IMAGE(ATOM_SPREAD_SPECTRUM_INFO, DATA_TABLES(SS_Info));
+	if (!tbl)
+		return result;
 
 	if (1 != revision.major || 2 > revision.minor)
 		return result;
@@ -1631,6 +1638,8 @@ static uint32_t get_ss_entry_number_from
 
 	tbl = GET_IMAGE(ATOM_SPREAD_SPECTRUM_INFO,
 			DATA_TABLES(SS_Info));
+	if (!tbl)
+		return number;
 
 	if (1 != revision.major || 2 > revision.minor)
 		return number;
@@ -1711,6 +1720,8 @@ static uint32_t get_ss_entry_number_from
 
 	header_include = GET_IMAGE(ATOM_ASIC_INTERNAL_SS_INFO_V2,
 			DATA_TABLES(ASIC_InternalSS_Info));
+	if (!header_include)
+		return 0;
 
 	size = (le16_to_cpu(header_include->sHeader.usStructureSize)
 			- sizeof(ATOM_COMMON_TABLE_HEADER))
@@ -1748,6 +1759,9 @@ static uint32_t get_ss_entry_number_from
 
 	header_include = GET_IMAGE(ATOM_ASIC_INTERNAL_SS_INFO_V3,
 			DATA_TABLES(ASIC_InternalSS_Info));
+	if (!header_include)
+		return number;
+
 	size = (le16_to_cpu(header_include->sHeader.usStructureSize) -
 			sizeof(ATOM_COMMON_TABLE_HEADER)) /
 					sizeof(ATOM_ASIC_SS_ASSIGNMENT_V3);


