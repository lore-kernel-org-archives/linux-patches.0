Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B988A44CF39;
	Tue, 16 Jun 2026 15:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624515; cv=none; b=sd4zwf5xCUb5tMo441atErZwp+xJ9tF2D/8f5EeB1WYl6uwww9MzwI9jW5SeiCUlwlZ4tSLkm2Pxekj10c1LNl8pkoN0nYhmIRhkcvKxXcoLIfh3r0EuerdvgtvjOB7BvwUTLcokov2+Z1sNGB8q2mbwBvOIoVvOgzw5B3833yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624515; c=relaxed/simple;
	bh=NCfILnHhHNLzE616OnmSOrND40VN4vjWWZ2roeL0ucQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofsuiXt4uxIIlrqDcxlf6CIn3OsnRzWDbwBl3NyXIsMNj6B7xHw+C6wKMYqqFxqJIzt4nEt11nxjTjE1aD9IuB7WVF54g4acGDkP2BUIjaQUbU7auM/pE6tHJfM8NnRK4wSB/n41pY5weLm11klYpDm1R6ESnlg3NoJNQFmh02k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wY61ziiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wY61ziiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872EB1F00A3A;
	Tue, 16 Jun 2026 15:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624513;
	bh=08F6psitP9Wp5JkbBehospEDo0m1lrbsZDVblC6tmfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wY61ziiGOMM9+4nNAyWqYGaVm5UYPNvBtZ/HByeyTOe+2mGbLi9yu5yu5cq5u1nsL
	 27+xLO6RE3ai8ZCnzc1US9g4+/xyMajo2SDyCSgF8EHntYni6iryI9ddiVJkT4CxuH
	 lwO/vNdUQa3u/W6oTqLPeDOwB1x58lN1cKnVoBUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 352/378] drm/amd/display: Bound VBIOS record-chain walk loops
Date: Tue, 16 Jun 2026 20:29:43 +0530
Message-ID: <20260616145128.675001835@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit ff287df16a1a58aca78b08d1f3ee09fc44da0351 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c        |   15 +++++---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c       |   27 ++++++++++-----
 drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.h |    5 ++
 3 files changed, 33 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
@@ -222,6 +222,7 @@ static enum bp_result bios_parser_get_i2
 	ATOM_COMMON_RECORD_HEADER *header;
 	ATOM_I2C_RECORD *record;
 	struct bios_parser *bp = BP_FROM_DCB(dcb);
+	int i;
 
 	if (!info)
 		return BP_RESULT_BADINPUT;
@@ -234,7 +235,7 @@ static enum bp_result bios_parser_get_i2
 	offset = le16_to_cpu(object->usRecordOffset)
 			+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, offset);
 
 		if (!header)
@@ -293,11 +294,12 @@ static enum bp_result bios_parser_get_de
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
@@ -948,6 +950,7 @@ static ATOM_HPD_INT_RECORD *get_hpd_reco
 {
 	ATOM_COMMON_RECORD_HEADER *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -957,7 +960,7 @@ static ATOM_HPD_INT_RECORD *get_hpd_reco
 	offset = le16_to_cpu(object->usRecordOffset)
 			+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, offset);
 
 		if (!header)
@@ -1652,6 +1655,7 @@ static ATOM_ENCODER_CAP_RECORD_V2 *get_e
 {
 	ATOM_COMMON_RECORD_HEADER *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -1661,7 +1665,7 @@ static ATOM_ENCODER_CAP_RECORD_V2 *get_e
 	offset = le16_to_cpu(object->usRecordOffset)
 					+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, offset);
 
 		if (!header)
@@ -2750,6 +2754,7 @@ static enum bp_result update_slot_layout
 					      unsigned int record_offset)
 {
 	unsigned int j;
+	unsigned int n;
 	struct bios_parser *bp;
 	ATOM_BRACKET_LAYOUT_RECORD *record;
 	ATOM_COMMON_RECORD_HEADER *record_header;
@@ -2759,7 +2764,7 @@ static enum bp_result update_slot_layout
 	record = NULL;
 	record_header = NULL;
 
-	for (;;) {
+	for (n = 0; n < BIOS_MAX_NUM_RECORD; n++) {
 
 		record_header = GET_IMAGE(ATOM_COMMON_RECORD_HEADER, record_offset);
 		if (record_header == NULL) {
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -395,6 +395,7 @@ static enum bp_result bios_parser_get_i2
 	struct atom_i2c_record *record;
 	struct atom_i2c_record dummy_record = {0};
 	struct bios_parser *bp = BP_FROM_DCB(dcb);
+	int i;
 
 	if (!info)
 		return BP_RESULT_BADINPUT;
@@ -428,7 +429,7 @@ static enum bp_result bios_parser_get_i2
 		break;
 	}
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -533,6 +534,7 @@ static struct atom_hpd_int_record *get_h
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -541,7 +543,7 @@ static struct atom_hpd_int_record *get_h
 
 	offset = object->disp_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -610,6 +612,7 @@ static struct atom_hpd_int_record *get_h
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -619,7 +622,7 @@ static struct atom_hpd_int_record *get_h
 	offset = le16_to_cpu(object->disp_recordoffset)
 			+ bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -2188,6 +2191,7 @@ static struct atom_encoder_caps_record *
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -2196,7 +2200,7 @@ static struct atom_encoder_caps_record *
 
 	offset = object->encoder_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -2225,6 +2229,7 @@ static struct atom_disp_connector_caps_r
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -2233,7 +2238,7 @@ static struct atom_disp_connector_caps_r
 
 	offset = object->disp_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -2261,6 +2266,7 @@ static struct atom_connector_caps_record
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -2269,7 +2275,7 @@ static struct atom_connector_caps_record
 
 	offset = object->disp_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -2347,6 +2353,7 @@ static struct atom_connector_speed_recor
 {
 	struct atom_common_record_header *header;
 	uint32_t offset;
+	int i;
 
 	if (!object) {
 		BREAK_TO_DEBUGGER(); /* Invalid object */
@@ -2355,7 +2362,7 @@ static struct atom_connector_speed_recor
 
 	offset = object->disp_recordoffset + bp->object_info_tbl_offset;
 
-	for (;;) {
+	for (i = 0; i < BIOS_MAX_NUM_RECORD; i++) {
 		header = GET_IMAGE(struct atom_common_record_header, offset);
 
 		if (!header)
@@ -3240,6 +3247,7 @@ static enum bp_result update_slot_layout
 {
 	unsigned int record_offset;
 	unsigned int j;
+	unsigned int n;
 	struct atom_display_object_path_v2 *object;
 	struct atom_bracket_layout_record *record;
 	struct atom_common_record_header *record_header;
@@ -3261,7 +3269,7 @@ static enum bp_result update_slot_layout
 		(object->disp_recordoffset) +
 		(unsigned int)(bp->object_info_tbl_offset);
 
-	for (;;) {
+	for (n = 0; n < BIOS_MAX_NUM_RECORD; n++) {
 
 		record_header = (struct atom_common_record_header *)
 			GET_IMAGE(struct atom_common_record_header,
@@ -3355,6 +3363,7 @@ static enum bp_result update_slot_layout
 	struct slot_layout_info *slot_layout_info)
 {
 	unsigned int record_offset;
+	unsigned int n;
 	struct atom_display_object_path_v3 *object;
 	struct atom_bracket_layout_record_v2 *record;
 	struct atom_common_record_header *record_header;
@@ -3377,7 +3386,7 @@ static enum bp_result update_slot_layout
 		(object->disp_recordoffset) +
 		(unsigned int)(bp->object_info_tbl_offset);
 
-	for (;;) {
+	for (n = 0; n < BIOS_MAX_NUM_RECORD; n++) {
 
 		record_header = (struct atom_common_record_header *)
 			GET_IMAGE(struct atom_common_record_header,
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.h
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser_helper.h
@@ -37,4 +37,9 @@ void bios_set_scratch_critical_state(str
 
 #define GET_IMAGE(type, offset) ((type *) bios_get_image(&bp->base, offset, sizeof(type)))
 
+/* Upper bound on the number of records in a VBIOS record chain. Prevents
+ * unbounded looping if the VBIOS image is malformed and lacks a terminator.
+ */
+#define BIOS_MAX_NUM_RECORD 256
+
 #endif


