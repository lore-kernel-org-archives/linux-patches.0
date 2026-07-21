Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9F3B47E3;
	Tue, 21 Jul 2026 22:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672546; cv=none; b=EK1+kVRksDz6ZqRrsX6MOmnU5EVw4jt7AXCZmCGX0ay5BQ+ZfTWXl0PUMtSYVWXv/Gph3otLX81b92+UdketyqbPX6U8Ksod+LNkoEjA9aeWszc5zj4/OGt72vwyErFUSLVB01oo0wjbwY5oib5OvjstAOQbYTUNeO4QYAWR/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672546; c=relaxed/simple;
	bh=SDM+WLgb/Vl/4kS3j2SmNL1MeQFOQRgRNX9YmMWnyLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cojVf02T9ZApx54ivx69IM8+7MRBTEZ+9U9cnkBMnpGLBuwHCJHH6/lRr5Z0cHGv10HZ7adWUtmzfXkZ25JPQeo4Imb0pKQDg2UHd7isvmnaTGjoP8CN3uSuWiab1kGBaQyA59XcAxO9L+mdT/MFoFiY68n50pE2umH62RZYtvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQLy1kZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQLy1kZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597751F000E9;
	Tue, 21 Jul 2026 22:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672544;
	bh=o0q8A81iq630rG/ZTAdcKAzMrQ3imZqtSCKz2yaZVBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQLy1kZK01ltVKvadCfi22KtHSkKSGT9tF8gcQB0xl5YmCNjhoOyOFNHmVzlzhWbA
	 BORHWTWxoSg0VlmvbCGHsLO3jIUByYHKlwO0HcXM0jmMST7x2OlIPco0423CY1Q3Jj
	 unePkd0PL9PmLO6kOj4x6fxrGSOZWLnDUQbsvIFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	John Garry <john.g.garry@oracle.com>,
	David Disseldorp <ddiss@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 664/843] scsi: target: Bound PR-OUT TransportID parsing to the received buffer
Date: Tue, 21 Jul 2026 17:24:59 +0200
Message-ID: <20260721152420.995801718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit d04a179085c262c9ed577d0a4cbc6482ff1fd9a3 upstream.

core_scsi3_decode_spec_i_port() and core_scsi3_emulate_register_and_move()
hand the raw PERSISTENT RESERVE OUT parameter buffer to
target_parse_pr_out_transport_id() without telling it how many bytes are
valid.  For an iSCSI TransportID (FORMAT CODE 01b),
iscsi_parse_pr_out_transport_id() locates the ",i,0x" ISID separator with
an unbounded strstr() (and on the error path prints the name with a further
unbounded "%s").  An initiator can submit a TransportID whose iSCSI name
contains neither a ",i,0x" substring nor a NUL terminator, filling the
parameter list to its end, so the scan runs off the end of the buffer.

When the parameter list spans more than one page the buffer is a multi-page
vmap (transport_kmap_data_sg()), so the over-read walks into the trailing
vmalloc guard page and oopses (KASAN: vmalloc-out-of-bounds in strstr).  It
is reachable by any fabric that delivers a PR OUT to a device exported
through an iSCSI TPG, including a guest via vhost-scsi.

Pass the number of received bytes down to the parser and validate the iSCSI
TransportID's own self-described length (ADDITIONAL LENGTH + 4) once, up
front: reject it if it is below the spc4r17 minimum or larger than the
received buffer, then bound the separator search, the ISID walk and the
name copy by that length.  This is the length check the callers already
perform after the parse (core_scsi3_decode_spec_i_port() compares tid_len
against tpdl, core_scsi3_emulate_register_and_move() validates it against
data_length), moved ahead of the scan.  Also drop the unbounded "%s" of the
unterminated name.

Add per-format explicit name-length checks before copying into i_str,
rather than silently truncating with min_t: for FORMAT CODE 00b reject if
the descriptor body (tid_len - 4 bytes) cannot fit in
i_str[TRANSPORT_IQN_LEN]; for FORMAT CODE 01b reject if the name portion
(from &buf[4] up to the separator) cannot fit.  Both checks make the bounds
intent explicit at each format branch.

While here, also reject a FORMAT CODE 01b TransportID whose ",i,0x"
separator sits at the very end of the descriptor: that leaves an empty ISID
and points the returned port nexus pointer at buf + tid_len, one past the
descriptor, which the registration code (__core_scsi3_locate_pr_reg(),
__core_scsi3_alloc_registration()) then dereferences as the ISID string --
the same over-read of the parameter buffer for a malformed descriptor.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Link: https://patch.msgid.link/20260611-b4-disp-9f20739e-v6-1-f6630e2aae44@proton.me
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_fabric_lib.c |   89 ++++++++++++++++++++++++--------
 drivers/target/target_core_internal.h   |    3 -
 drivers/target/target_core_pr.c         |    4 -
 3 files changed, 73 insertions(+), 23 deletions(-)

--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -289,13 +289,24 @@ static void sbp_parse_pr_out_transport_i
 static bool iscsi_parse_pr_out_transport_id(
 	struct se_portal_group *se_tpg,
 	char *buf,
+	u32 buf_len,
 	u32 *out_tid_len,
 	char **port_nexus_ptr,
 	char *i_str)
 {
 	char *p;
+	u32 tid_len;
 	int i;
-	u8 format_code = (buf[0] & 0xc0);
+	u8 format_code;
+
+	/*
+	 * The 4-byte iSCSI TransportID header (FORMAT CODE + 2-byte ADDITIONAL
+	 * LENGTH) must be present before any of it can be parsed.
+	 */
+	if (buf_len < 4)
+		return false;
+
+	format_code = buf[0] & 0xc0;
 	/*
 	 * Check for FORMAT CODE 00b or 01b from spc4r17, section 7.5.4.6:
 	 *
@@ -315,15 +326,17 @@ static bool iscsi_parse_pr_out_transport
 		return false;
 	}
 	/*
-	 * If the caller wants the TransportID Length, we set that value for the
-	 * entire iSCSI Tarnsport ID now.
+	 * Reconstruct the self-described TransportID length from the ADDITIONAL
+	 * LENGTH field plus the 4-byte header.  Reject it if it is below the
+	 * spc4r17 section 7.5.4.6 minimum (ADDITIONAL LENGTH shall be at least
+	 * 20) or if it runs past the bytes actually received, so that every
+	 * access below stays inside the TransportID.
 	 */
-	if (out_tid_len) {
-		/* The shift works thanks to integer promotion rules */
-		*out_tid_len = get_unaligned_be16(&buf[2]);
-		/* Add four bytes for iSCSI Transport ID header */
-		*out_tid_len += 4;
-	}
+	tid_len = get_unaligned_be16(&buf[2]) + 4;
+	if (tid_len < 24 || tid_len > buf_len)
+		return false;
+	if (out_tid_len)
+		*out_tid_len = tid_len;
 
 	/*
 	 * Check for ',i,0x' separator between iSCSI Name and iSCSI Initiator
@@ -331,16 +344,32 @@ static bool iscsi_parse_pr_out_transport
 	 * format.
 	 */
 	if (format_code == 0x40) {
-		p = strstr(&buf[4], ",i,0x");
+		p = strnstr(&buf[4], ",i,0x", tid_len - 4);
 		if (!p) {
-			pr_err("Unable to locate \",i,0x\" separator"
-				" for Initiator port identifier: %s\n",
-				&buf[4]);
+			pr_err("Unable to locate \",i,0x\" separator in iSCSI TransportID\n");
+			return false;
+		}
+		/*
+		 * The iSCSI name runs from &buf[4] up to the separator; reject it
+		 * if it cannot fit in i_str[TRANSPORT_IQN_LEN].
+		 */
+		if (p - &buf[4] >= TRANSPORT_IQN_LEN) {
+			pr_err("iSCSI Initiator port name too long in TransportID\n");
 			return false;
 		}
 		*p = '\0'; /* Terminate iSCSI Name */
 		p += 5; /* Skip over ",i,0x" separator */
 
+		/*
+		 * The ISID must follow the separator.  A ",i,0x" sitting at the
+		 * very end of the TransportID leaves no ISID and would point the
+		 * port nexus at buf + tid_len, i.e. past the descriptor, which
+		 * the registration code then reads as the ISID string.
+		 */
+		if (p >= buf + tid_len) {
+			pr_err("Missing ISID in iSCSI Initiator port TransportID\n");
+			return false;
+		}
 		*port_nexus_ptr = p;
 		/*
 		 * Go ahead and do the lower case conversion of the received
@@ -348,7 +377,7 @@ static bool iscsi_parse_pr_out_transport
 		 * for comparison against the running iSCSI session's ISID from
 		 * iscsi_target.c:lio_sess_get_initiator_sid()
 		 */
-		for (i = 0; i < 12; i++) {
+		for (i = 0; i < 12 && p < buf + tid_len; i++) {
 			/*
 			 * The first ISCSI INITIATOR SESSION ID field byte
 			 * containing an ASCII null character terminates the
@@ -366,10 +395,22 @@ static bool iscsi_parse_pr_out_transport
 			*p = tolower(*p);
 			p++;
 		}
-	} else
+		strscpy(i_str, &buf[4], TRANSPORT_IQN_LEN);
+	} else {
 		*port_nexus_ptr = NULL;
-
-	strscpy(i_str, &buf[4], TRANSPORT_IQN_LEN);
+		/*
+		 * FORMAT CODE 00b: the name occupies buf[4..tid_len-1].  The
+		 * declared length tid_len - 4 must fit in i_str[TRANSPORT_IQN_LEN].
+		 * (For 01b the same tid_len bound would be over-restrictive: the
+		 * descriptor also carries the separator and ISID, so a legal
+		 * <=223-byte name gives tid_len up to 244.)
+		 */
+		if (tid_len - 4 >= TRANSPORT_IQN_LEN) {
+			pr_err("iSCSI Initiator port name too long in TransportID\n");
+			return false;
+		}
+		strscpy(i_str, &buf[4], tid_len - 4);
+	}
 	return true;
 }
 
@@ -419,8 +460,16 @@ int target_get_pr_transport_id(struct se
 }
 
 bool target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		char *buf, u32 *out_tid_len, char **port_nexus_ptr, char *i_str)
+		char *buf, u32 buf_len, u32 *out_tid_len,
+		char **port_nexus_ptr, char *i_str)
 {
+	/*
+	 * The fixed-length SAS/SRP/FCP/SBP TransportIDs are 24 bytes; the iSCSI
+	 * format is variable and bounds itself against buf_len below.
+	 */
+	if (tpg->proto_id != SCSI_PROTOCOL_ISCSI && buf_len < 24)
+		return false;
+
 	switch (tpg->proto_id) {
 	case SCSI_PROTOCOL_SAS:
 		/*
@@ -439,8 +488,8 @@ bool target_parse_pr_out_transport_id(st
 		sbp_parse_pr_out_transport_id(buf, i_str);
 		break;
 	case SCSI_PROTOCOL_ISCSI:
-		return iscsi_parse_pr_out_transport_id(tpg, buf, out_tid_len,
-					port_nexus_ptr, i_str);
+		return iscsi_parse_pr_out_transport_id(tpg, buf, buf_len,
+					out_tid_len, port_nexus_ptr, i_str);
 	default:
 		pr_err("Unknown proto_id: 0x%02x\n", tpg->proto_id);
 		return false;
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -104,7 +104,8 @@ int	target_get_pr_transport_id(struct se
 		struct t10_pr_registration *pr_reg, int *format_code,
 		unsigned char *buf);
 bool target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		char *buf, u32 *out_tid_len, char **port_nexus_ptr, char *i_str);
+		char *buf, u32 buf_len, u32 *out_tid_len,
+		char **port_nexus_ptr, char *i_str);
 
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1582,7 +1582,7 @@ core_scsi3_decode_spec_i_port(
 
 			iport_ptr = NULL;
 			tid_found = target_parse_pr_out_transport_id(tmp_tpg,
-					ptr, &tid_len, &iport_ptr, i_str);
+					ptr, tpdl, &tid_len, &iport_ptr, i_str);
 			if (!tid_found)
 				continue;
 			/*
@@ -3276,7 +3276,7 @@ core_scsi3_emulate_pro_register_and_move
 		goto out;
 	}
 	tid_found = target_parse_pr_out_transport_id(dest_se_tpg,
-			&buf[24], &tmp_tid_len, &iport_ptr, initiator_str);
+			&buf[24], tid_len, &tmp_tid_len, &iport_ptr, initiator_str);
 	if (!tid_found) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" initiator_str from Transport ID\n");


