Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31EA2DC78C;
	Thu,  2 Jul 2026 16:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010770; cv=none; b=r/hdZ8wigpHR0It0qFoBhuPyRgPn77ym1D5z1VghQZWH/0qqE4lIALXmhG7MewLdk/+cK/yz499wcih1b4TdqtGTMqGndajsvABcKZCMmKheO7cjscEp8H8Kz8gXoRKegA4EvofJJOE7T1CfXt5NFBrVnnDGqjxBM0ghrgnIdpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010770; c=relaxed/simple;
	bh=4cvD5nap7WgA2UkXQcN8n3fwDETh8v092TIdyzL73Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDh+OfWGhMRJaw88y9ZDN5HQBb/Q7FfUbq9j+uSmNXUdeqA8h7VDPafc7yF73vv60oLHzXf9moPGCWhfMWWviWyzNhs0Rm3miCuu7mdYD3C16G/EtY+S5kfCg4GcMPirAkiaWTeDYS502S2T/KacL8vDqDV5ADHLxMmVNj+TP/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNSVkHjn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNSVkHjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEB71F000E9;
	Thu,  2 Jul 2026 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010768;
	bh=sAOWdIyA5EZkZ/g08g/UCRQvawiA1X1lSsgYcxpHGyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNSVkHjnCIOBBDpPkPQNKld6D4BHBKNovyUKPkYb61Gjtq/JEH1CWHVpfNUXzLnko
	 cBOtOIyWz8n+rg6BPfxQjuUFNtI0K5YW5QTEbg+rXbsV5uKuMsCO0oF7eXO978L5Mp
	 hs4mpWijnxeN5BTEJ13EiQW7hIFPdOxaPOw6j4PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/175] drm/amd/display: Bound VBIOS record-chain walk loops
Date: Thu,  2 Jul 2026 18:18:24 +0200
Message-ID: <20260702155115.841532036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit ff287df16a1a58aca78b08d1f3ee09fc44da0351 ]

[Why & How]
All record-chain walk loops in bios_parser.c and bios_parser2.c use
for(;;) and only terminate on a 0xFF record_type sentinel or zero
record_size. A malformed VBIOS image missing the terminator record
causes unbounded iteration at probe time, potentially hundreds of
thousands of iterations with record_size=1. In the final iterations
near the BIOS image boundary, struct casts beyond the 2-byte header
validated by GET_IMAGE can also read out of bounds.

Cap all 14 record-chain walk loops to BIOS_MAX_NUM_RECORD (256)
iterations. The atombios.h defines up to 22 distinct record types
and atomfirmware.h has 13. Assuming an average of less than 10
records per type (which is reasonable since most are connector-
based) 256 is a generous upper bound.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Assisted-by: Copilot:claude-opus-4.6 Mythos
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 95700a3d660287ed657d6892f7be9ffc0e294a93)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/bios/bios_parser.c | 15 +++++++----
 .../drm/amd/display/dc/bios/bios_parser2.c    | 27 ++++++++++++-------
 .../amd/display/dc/bios/bios_parser_helper.h  |  5 ++++
 3 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
index ac2a71e80723d1..fa8fcbcc421aba 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
@@ -225,6 +225,7 @@ static enum bp_result bios_parser_get_i2c_info(struct dc_bios *dcb,
 	ATOM_COMMON_RECORD_HEADER *header;
 	ATOM_I2C_RECORD *record;
 	struct bios_parser *bp = BP_FROM_DCB(dcb);
+	int i;
 
 	if (!info)
 		return BP_RESULT_BADINPUT;
@@ -237,7 +238,7 @@ static enum bp_result bios_parser_get_i2c_info(struct dc_bios *dcb,
 	offset = le16_to_cpu(object->usRecordOffset)
 			+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, offset);
 
 		if (!header)
@@ -296,11 +297,12 @@ static enum bp_result bios_parser_get_device_tag_record(
 {
 	ATOM_COMMON_RECORD_HEADER *header;
 	uint32_t offset;
+	int i;
 
 	offset = le16_to_cpu(object->usRecordOffset)
 			+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, offset);
 
 		if (!header)
@@ -873,6 +875,7 @@ static ATOM_HPD_INT_RECORD *get_hpd_record(struct bios_parser *bp,
 {
 	ATOM_COMMON_RECORD_HEADER *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -882,7 +885,7 @@ static ATOM_HPD_INT_RECORD *get_hpd_record(struct bios_parser *bp,
 	offset = le16_to_cpu(object->usRecordOffset)
 			+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, offset);
 
 		if (!header)
@@ -1577,6 +1580,7 @@ static ATOM_ENCODER_CAP_RECORD_V2 *get_encoder_cap_record(
 {
 	ATOM_COMMON_RECORD_HEADER *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -1586,7 +1590,7 @@ static ATOM_ENCODER_CAP_RECORD_V2 *get_encoder_cap_record(
 	offset = le16_to_cpu(object->usRecordOffset)
 					+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, offset);
 
 		if (!header)
@@ -2675,6 +2679,7 @@ static enum bp_result update_slot_layout_info(struct dc_bios *dcb,
 					      unsigned int record_offset)
 {
 	unsigned int j;
+	unsigned int n;
 	struct bios_parser *bp;
 	ATOM_BRACKET_LAYOUT_RECORD *record;
 	ATOM_COMMON_RECORD_HEADER *record_header;
@@ -2684,7 +2689,7 @@ static enum bp_result update_slot_layout_info(struct dc_bios *dcb,
 	record = NULL;
 	record_header = NULL;
 
-	for (;;) {
+	for (n = 0; n < BIOS_MAX_NUM_RECORD; n++) {
 
 		record_header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, record_offset);
 		if (record_header == NULL) {
diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index ed8f669a9a3e15..33142f1c37462b 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -391,6 +391,7 @@ static enum bp_result bios_parser_get_i2c_info(struct dc_bios *dcb,
 	struct atom_i2c_record *record;
 	struct atom_i2c_record dummy_record = {0};
 	struct bios_parser *bp = BP_FROM_DCB(dcb);
+	int i;
 
 	if (!info)
 		return BP_RESULT_BADINPUT;
@@ -424,7 +425,7 @@ static enum bp_result bios_parser_get_i2c_info(struct dc_bios *dcb,
 		break;
 	}
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -529,6 +530,7 @@ static struct atom_hpd_int_record *get_hpd_record_for_path_v3(struct bios_parser
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -537,7 +539,7 @@ static struct atom_hpd_int_record *get_hpd_record_for_path_v3(struct bios_parser
 
 	offset = object->disp_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -607,6 +609,7 @@ static struct atom_hpd_int_record *get_hpd_record(
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -616,7 +619,7 @@ static struct atom_hpd_int_record *get_hpd_record(
 	offset = le16_to_cpu(object->disp_recordoffset)
 			+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -2125,6 +2128,7 @@ static struct atom_encoder_caps_record *get_encoder_cap_record(
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -2133,7 +2137,7 @@ static struct atom_encoder_caps_record *get_encoder_cap_record(
 
 	offset = object->encoder_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -2162,6 +2166,7 @@ static struct atom_disp_connector_caps_record *get_disp_connector_caps_record(
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -2170,7 +2175,7 @@ static struct atom_disp_connector_caps_record *get_disp_connector_caps_record(
 
 	offset = object->disp_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -2198,6 +2203,7 @@ static struct atom_connector_caps_record *get_connector_caps_record(struct bios_
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -2206,7 +2212,7 @@ static struct atom_connector_caps_record *get_connector_caps_record(struct bios_
 
 	offset = object->disp_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -2286,6 +2292,7 @@ static struct atom_connector_speed_record *get_connector_speed_cap_record(struct
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -2294,7 +2301,7 @@ static struct atom_connector_speed_record *get_connector_speed_cap_record(struct
 
 	offset = object->disp_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -3154,6 +3161,7 @@ static enum bp_result update_slot_layout_info(
 {
 	unsigned int record_offset;
 	unsigned int j;
+	unsigned int n;
 	struct atom_display_object_path_v2 *object;
 	struct atom_bracket_layout_record *record;
 	struct atom_common_record_header *record_header;
@@ -3175,7 +3183,7 @@ static enum bp_result update_slot_layout_info(
 		(object->disp_recordoffset) +
 		(unsigned int)(bp->object_info_tbl_offset);
 
-	for (;;) {
+	for (n = 0; n < BIOS_MAX_NUM_RECORD; n++) {
 
 		record_header = (struct atom_common_record_header *)
 			GET_IMAGE(struct atom_common_record_header,
@@ -3269,6 +3277,7 @@ static enum bp_result update_slot_layout_info_v2(
 	struct slot_layout_info *slot_layout_info)
 {
 	unsigned int record_offset;
+	unsigned int n;
 	struct atom_display_object_path_v3 *object;
 	struct atom_bracket_layout_record_v2 *record;
 	struct atom_common_record_header *record_header;
@@ -3291,7 +3300,7 @@ static enum bp_result update_slot_layout_info_v2(
 		(object->disp_recordoffset) +
 		(unsigned int)(bp->object_info_tbl_offset);
 
-	for (;;) {
+	for (n = 0; n < BIOS_MAX_NUM_RECORD; n++) {
 
 		record_header = (struct atom_common_record_header *)
 			GET_IMAGE(struct atom_common_record_header,
diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.h b/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.h
index e1b4a40a353db1..da1e30de3c59a0 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.h
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.h
@@ -38,4 +38,9 @@ uint32_t bios_get_vga_enabled_displays(struct dc_bios *bios);
 
 #define GET_IMAGE(type, offset) ((type *) bios_get_image(&bp->base, offset, sizeof(type)))
 
+/* Upper bound on the number of records in a VBIOS record chain. Prevents
+ * unbounded looping if the VBIOS image is malformed and lacks a terminator.
+ */
+#define BIOS_MAX_NUM_RECORD 256
+
 #endif
-- 
2.53.0



