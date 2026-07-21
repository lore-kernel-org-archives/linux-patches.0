Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC8C43901B;
	Tue, 21 Jul 2026 22:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672768; cv=none; b=oBqP5oI620uVUUtbMRy5GVXGbj+K/HNdf7aWDyXEUYj2QutVII5q47kubrCzVgEyjAD4CMNqXsIInoRa1HGTqu5fzzvkOT+peHTCvD7ksPD2en7dADKU7QCCqf83ZTT7ueM76r489V3AbqZ4DZHd05bavGIf8GMkv85q1FHKCxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672768; c=relaxed/simple;
	bh=Hl/76r2NfBatp9NB+lKKuScsNkDwLL+WjDjjdR3DHb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6mW6XQvsMj+KSGPBY4Dq6OK+XMqRNboG1lXgUQNAuf1oISqwASoAEFrW+jsrrme1y7pxAVUmCK7zHlUxFPBZM96adAOkMCWTK3TTFhkeotwMQJC0ILVvwpID+4TZZEyYCBIErLlK8CT5MK6ZjDa8Kudf2SVrvuRcBmAAF5Ea8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHKE1GjB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHKE1GjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C461A1F000E9;
	Tue, 21 Jul 2026 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672767;
	bh=CQllWwBkM9ZiYGL5UTPtUr3ZIJH3l62+E8DTqpFrhWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHKE1GjBwJCBGpyOGD7pObFPIxJB0nOuPbH2Z5cSgcp2GRmsplf6BIy1zn6iu7Wd8
	 k4uIxmnevlBDRYMbegb3faZBRJ5+h39UDYcG7/kKKxvbtDHZ4ewlqV+x5+btAmsiPl
	 mHc4VTsFySwJm4Yd2mmi1z85gFnQeKcXf2w9ovpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 749/843] smb2: small refactor in smb2_check_message()
Date: Tue, 21 Jul 2026 17:26:24 +0200
Message-ID: <20260721152422.900062690@linuxfoundation.org>
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

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit da3847894fddc27ca95d5ac0012f444a77a5e0c3 ]

If the command is SMB2_IOCTL, OutputLength and OutputContext are
optional and can be zero, so return early and skip calculated length
check.

Move the mismatched length message to the end of the check, to avoid
unnecessary logs when the check was not a real miscalculation.

Also change the pr_warn_once() to a pr_warn() so we're sure to get a
log for the real mismatches.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 53b7c271f06b ("smb: client: restrict implied bcc[0] exemption to responses without data area")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c  |   13 ++++++-------
 fs/cifs/smb2misc.c |   47 ++++++++++++++++++++++++++++-------------------
 2 files changed, 34 insertions(+), 26 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -890,19 +890,18 @@ int
 cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
-	int length;
+	int rc;
 
 	/*
 	 * We know that we received enough to get to the MID as we
 	 * checked the pdu_length earlier. Now check to see
-	 * if the rest of the header is OK. We borrow the length
-	 * var for the rest of the loop to avoid a new stack var.
+	 * if the rest of the header is OK.
 	 *
 	 * 48 bytes is enough to display the header and a little bit
 	 * into the payload for debugging purposes.
 	 */
-	length = server->ops->check_message(buf, server->total_read, server);
-	if (length != 0)
+	rc = server->ops->check_message(buf, server->total_read, server);
+	if (rc)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
@@ -917,9 +916,9 @@ cifs_handle_standard(struct TCP_Server_I
 		return -1;
 
 	if (!mid)
-		return length;
+		return rc;
 
-	handle_mid(mid, server, buf, length);
+	handle_mid(mid, server, buf, rc);
 	return 0;
 }
 
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -132,15 +132,15 @@ static __u32 get_neg_ctxt_len(struct smb
 }
 
 int
-smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
+smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 {
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct smb2_pdu *pdu = (struct smb2_pdu *)shdr;
-	__u64 mid;
-	__u32 clc_len;  /* calculated length */
-	int command;
-	int pdu_size = sizeof(struct smb2_pdu);
 	int hdr_size = sizeof(struct smb2_hdr);
+	int pdu_size = sizeof(struct smb2_pdu);
+	int command;
+	__u32 calc_len; /* calculated length */
+	__u64 mid;
 
 	/*
 	 * Add function to do table lookup of StructureSize by command
@@ -154,7 +154,7 @@ smb2_check_message(char *buf, unsigned i
 
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(iter, &srvr->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(iter, &server->smb_ses_list, smb_ses_list) {
 			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
 				ses = iter;
 				break;
@@ -221,30 +221,33 @@ smb2_check_message(char *buf, unsigned i
 		}
 	}
 
-	clc_len = smb2_calc_size(buf, srvr);
+	calc_len = smb2_calc_size(buf, server);
+
+	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
+	 * be 0, and not a real miscalculation */
+	if (command == SMB2_IOCTL_HE && calc_len == 0)
+		return 0;
 
-	if (shdr->Command == SMB2_NEGOTIATE)
-		clc_len += get_neg_ctxt_len(shdr, len, clc_len);
+	if (command == SMB2_NEGOTIATE_HE)
+		calc_len += get_neg_ctxt_len(shdr, len, calc_len);
 
-	if (len != clc_len) {
-		cifs_dbg(FYI, "Calculated size %u length %u mismatch mid %llu\n",
-			 clc_len, len, mid);
+	if (len != calc_len) {
 		/* create failed on symlink */
 		if (command == SMB2_CREATE_HE &&
 		    shdr->Status == STATUS_STOPPED_ON_SYMLINK)
 			return 0;
 		/* Windows 7 server returns 24 bytes more */
-		if (clc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)
+		if (calc_len + 24 == len && command == SMB2_OPLOCK_BREAK_HE)
 			return 0;
 		/* server can return one byte more due to implied bcc[0] */
-		if (clc_len == len + 1)
+		if (calc_len == len + 1)
 			return 0;
 
 		/*
 		 * Some windows servers (win2016) will pad also the final
 		 * PDU in a compound to 8 bytes.
 		 */
-		if (((clc_len + 7) & ~7) == len)
+		if (((calc_len + 7) & ~7) == len)
 			return 0;
 
 		/*
@@ -253,12 +256,18 @@ smb2_check_message(char *buf, unsigned i
 		 * SMB2/SMB3 frame length (header + smb2 response specific data)
 		 * Some windows servers also pad up to 8 bytes when compounding.
 		 */
-		if (clc_len < len)
+		if (calc_len < len)
 			return 0;
 
-		pr_warn_once(
-			"srv rsp too short, len %d not %d. cmd:%d mid:%llu\n",
-			len, clc_len, command, mid);
+		/* Only log a message if len was really miscalculated */
+		if (unlikely(cifsFYI))
+			cifs_dbg(FYI, "Server response too short: calculated "
+				 "length %u doesn't match read length %u (cmd=%d, mid=%llu)\n",
+				 calc_len, len, command, mid);
+		else
+			pr_warn("Server response too short: calculated length "
+				"%u doesn't match read length %u (cmd=%d, mid=%llu)\n",
+				calc_len, len, command, mid);
 
 		return 1;
 	}


