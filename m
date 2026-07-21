Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94308441035;
	Tue, 21 Jul 2026 22:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672548; cv=none; b=KZfZ/ONSTc0UXKiod7RnS0rcvY1vNHuFAemqLCEAbAVS2wXHzBlQBaVTUXQ2hu6EVKHJXZoYuBfJf2qW8kBiiB4H8ehy+XT+/kv6bPJjFSieGG3vfZNCC/8uGZoEkp7rSdKGQOXBVTOAtX9tdeIQvnWT7iquWVsuPLwg6QMFZ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672548; c=relaxed/simple;
	bh=D91HAKPo/YD+lD5bx7xWvuJTLEY3GrbRCjBjGHf5FM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvkSNct9koMPgnD1Ebn7uheOhExU8bpevvvFixNsT66ooQ2wAyFjt5y270SxkHBVzp45U/GvGxWzUH6BvDCmF8TlHRnBs2ly6Xvh25afccu3ac1PUlzBW0v8fv0fNQ+V3xfV27WCl8+Z2LKYVrAdjxpuIUc/arTq2esGJ2ygqaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyB/jfv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyB/jfv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36571F000E9;
	Tue, 21 Jul 2026 22:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672547;
	bh=V5DKwuD0mzb3MDzkS1rpuMVPXAQSoWp7K3x93dlEhtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyB/jfv6AiCHeBi9X5QsncuA0LO+dntFB7O0lUjY4BIdWi5l5gP9V5tessvdfW8Zh
	 fvYIs4sXCb3g2T3KostThV2P5rf8/z9tbmKbYTkno2IG+/wCHxUxqlUgzNlH5xctm7
	 dA0QuUDRKad9U+8g1oiUGwOeYDVVT70RRb3t7vQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	John Garry <john.g.garry@oracle.com>,
	David Disseldorp <ddiss@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 665/843] scsi: target: core: Fix iSCSI ISID use-after-free in REGISTER AND MOVE
Date: Tue, 21 Jul 2026 17:25:00 +0200
Message-ID: <20260721152421.020009489@linuxfoundation.org>
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
@@ -3284,9 +3284,6 @@ core_scsi3_emulate_pro_register_and_move
 		goto out;
 	}
 
-	transport_kunmap_data_sg(cmd);
-	buf = NULL;
-
 	pr_debug("SPC-3 PR [%s] Extracted initiator %s identifier: %s"
 		" %s\n", dest_tf_ops->fabric_name, (iport_ptr != NULL) ?
 		"port" : "device", initiator_str, (iport_ptr != NULL) ?
@@ -3520,6 +3517,11 @@ after_iport_check:
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


