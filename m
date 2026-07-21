Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABD73C0617;
	Tue, 21 Jul 2026 21:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670241; cv=none; b=UsIUi7UUkXcx0vtqmQ6U022tBE3EnvNZMlKbHLkWzzlI7MWlo2Pd/QB+v98/zruWWz5vX8ZU9ccaLWgpmqTufI1qp+aJ8uebInEwXUZyOkn5jG85dKUgl8lFsxMRKbPktgulT9UqcEduSLSIgvsxY7GUa80xRp7Wi+5qKxJEjaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670241; c=relaxed/simple;
	bh=auMEpz7buocMnj4KxttulUKmAQ1NmVtluLBBeqhxEvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj3y+urBa33t0hjGtYWJoSK6Jukn4bWeZBbm9tmh6KOBG7ofG/5ynUWl9r9g/6Qi03+3czXZXxS0pEccZnxB6J3jcKNH7iEL0lKFmBbtdkkmQ6psMdXsUmrAaCLz8I5o2byXQRIu9Rx2R4GBC80LZqroDGI4Ry0gIdTeg+2e3W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TklE8MCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TklE8MCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A69E1F000E9;
	Tue, 21 Jul 2026 21:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670240;
	bh=hGloPQDOkyAnKIeq6VxvMy2sQfGQDhqcFMQf44jTU4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TklE8MCIOIuJonw7/ZY0BBGhrdWYGNdyMvDQCpyXjoUfAkKb+p4DUcLLpLDsW/Eik
	 1LnlzAhRRTK6cHKIc7FAsoLT2x/AzIfgLtYYjWKrS+C0hA1PUbhBrkLGnkXtcoHOYn
	 QEcnyQTkUOA246IHM/SkH3b+xAut+UPRVxwOmv9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	John Garry <john.g.garry@oracle.com>,
	David Disseldorp <ddiss@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 0858/1067] scsi: target: core: Fix iSCSI ISID use-after-free in REGISTER AND MOVE
Date: Tue, 21 Jul 2026 17:24:19 +0200
Message-ID: <20260721152443.736800285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit fda6a1f3c3d7047b5ce5654487649c2daa738bfc upstream.

core_scsi3_emulate_pro_register_and_move() maps the PERSISTENT RESERVE OUT
parameter list with transport_kmap_data_sg() and parses the destination
TransportID with target_parse_pr_out_transport_id(). For an iSCSI
TransportID (FORMAT CODE 01b), iscsi_parse_pr_out_transport_id() returns
the ISID in iport_ptr as a raw pointer into that mapped buffer.

The function then unmaps the buffer with transport_kunmap_data_sg() before
dereferencing iport_ptr in strcmp(), __core_scsi3_locate_pr_reg() and
core_scsi3_alloc_registration(). When the parameter list spans more than
one page (PARAMETER LIST LENGTH > 4096), transport_kmap_data_sg() uses
vmap() and transport_kunmap_data_sg() does vunmap(), so the kernel virtual
address backing iport_ptr is torn down and every subsequent dereference is
a use-after-free read of the unmapped region.

Keep the parameter list mapped until iport_ptr is no longer needed: drop
the early transport_kunmap_data_sg() and unmap once on the success path,
right before returning. The error paths already unmap through the existing
"if (buf) transport_kunmap_data_sg(cmd)" at the out: label, which now runs
on every post-map error exit because buf is no longer cleared early. Only
reads of the mapping happen while spinlocks are held; the map and unmap
calls remain outside any lock. The sibling caller
core_scsi3_decode_spec_i_port() already uses the buffer before unmapping it
and is left unchanged.

Fixes: 4949314c7283 ("target: Allow control CDBs with data > 1 page")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Link: https://patch.msgid.link/20260610042245.35473-1-hexlabsecurity@proton.me
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_pr.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3288,9 +3288,6 @@ core_scsi3_emulate_pro_register_and_move
 		goto out;
 	}
 
-	transport_kunmap_data_sg(cmd);
-	buf = NULL;
-
 	pr_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s"
 		" %s\n", dest_tf_ops->fabric_name, (iport_ptr != NULL) ?
 		"port" : "device", initiator_str, (iport_ptr != NULL) ?
@@ -3527,6 +3524,11 @@ after_iport_check:
 	core_scsi3_update_and_write_aptpl(cmd->se_dev, aptpl);
 
 	core_scsi3_put_pr_reg(dest_pr_reg);
+	/*
+	 * iport_ptr aliases the PR-OUT parameter list mapped above, so the
+	 * buffer is unmapped only here on success (and at out: on error).
+	 */
+	transport_kunmap_data_sg(cmd);
 	return 0;
 out:
 	if (buf)


