Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E8D2DFF04;
	Sun,  7 Jun 2026 10:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829510; cv=none; b=MPD5WFeLfeSqyFQEuhliTgRIa7ruA2K3ebe+YcVYNltN843+anfqryigXNE8lG3psUBezHvQqAPXEhdXYbpsz37to6qZUxahSa3JMqosfTqkk28yzkO4jFptVIT5EN6ZP1hv9iC4qjjs4ATPdgHabjteb70EM87OwKxkjaEdZD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829510; c=relaxed/simple;
	bh=QnvOPBw0zzC2497CBEamSCRcrRdyXGdm18rCxRcdA7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU4bvQ0fwZcnSk6HI07e+8PgPfCJgxW4p2dKbvossBcIBraaFcU1EJadEEHvM6h0sBmz16kYH0yr4FxbaJfOTZSc0D8xpFAoyQX26MmUhreXnIwtkYUOkn6qbnG0VH8D2MJet/L2fJo/wQFGJHg6DQzsT438aDUWuOIEbTi+aXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei2KjDkK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei2KjDkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD4C1F00893;
	Sun,  7 Jun 2026 10:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829509;
	bh=XO5GXOUrEXKjasZRdHnQLbCHFfzh5UE+lso1wSfYpN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ei2KjDkKW0ilfcaj6gMc61ANB3sExxxDuE+CaDvttRMsSlh5lbZ3N3FPSf0iOmRXt
	 ZG/kwSZNSgm5Y60pmRc5fxTvwfiT2EUcvVGaTQldpS/PSrz4qsJd1WJJZWjH4plDSE
	 Ytybvt4e4mzf7ZD8DPG1TBnA07KrnYh49S3tX8t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.0 285/332] scsi: target: iscsi: Fix CRC overread and double-free in iscsit_handle_text_cmd()
Date: Sun,  7 Jun 2026 12:00:54 +0200
Message-ID: <20260607095738.516471824@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 778c2ab142c625a8a8afa570e0f9b7873f445d99 upstream.

Two latent bugs in the Text-phase handler, both present since the
original LIO integration in commit e48354ce078c ("iscsi-target: Add
iSCSI fabric support for target v4.1"):

1) DataDigest CRC buffer overread (4 bytes past text_in).

   text_in is kzalloc()'d at ALIGN(payload_length, 4).  rx_size is then
   incremented by ISCSI_CRC_LEN to make room for the received DataDigest
   in the iovec, but the same (now-bumped) rx_size is passed as the
   buffer length to iscsit_crc_buf():

       if (conn->conn_ops->DataDigest) {
               ...
               rx_size += ISCSI_CRC_LEN;
       }
       ...
       if (conn->conn_ops->DataDigest) {
               data_crc = iscsit_crc_buf(text_in, rx_size, 0, NULL);

   iscsit_crc_buf() walks rx_size bytes of text_in with crc32c(), so
   when DataDigest is negotiated it reads 4 bytes past the end of the
   text_in allocation.  KASAN reproduces this directly on the unpatched
   mainline tree as slab-out-of-bounds in crc32c() called from the Text
   PDU path.  The OOB bytes feed crc32c() and are then compared against
   the initiator-supplied checksum, so the value does not flow back to
   the attacker, but the kernel does read past the buffer on every Text
   PDU with DataDigest=CRC32C.

   Fix by passing the actual padded payload length
   (ALIGN(payload_length, 4)) that was used for the kzalloc().

2) Stale cmd->text_in_ptr re-free (double-free) on ERL>0 bad DataDigest
   drop.

   On DataDigest mismatch with ErrorRecoveryLevel > 0 the handler
   silently drops the PDU and lets the initiator plug the CmdSN gap:

               kfree(text_in);
               return 0;

   cmd->text_in_ptr still points at the freed buffer.  The next Text
   Request on the same ITT re-enters iscsit_setup_text_cmd(), which
   unconditionally does

       kfree(cmd->text_in_ptr);
       cmd->text_in_ptr = NULL;

   freeing the same pointer a second time.  Session teardown via
   iscsit_release_cmd() has the same shape and hits the same double-free
   if the connection is dropped before a second Text Request arrives.

   On an unmodified mainline tree the bug-1 CRC overread fires first on
   the initial valid Text Request and perturbs the subsequent state, so
   #4 was isolated by building a kernel with only the bug-1 hunk of this
   patch applied plus temporary printk() observability around the three
   relevant kfree() sites.  The observability prints are not part of
   this patch.  On that build, a three-PDU Text Request sequence after
   login produces two back-to-back splats:

       BUG: KASAN: double-free in iscsit_setup_text_cmd+0x??
       BUG: KASAN: double-free in iscsit_release_cmd+0x??

   showing the same pointer freed in the ERL>0 drop path and again in
   iscsit_setup_text_cmd() (next Text Request on the same ITT) and once
   more in iscsit_release_cmd() (session teardown).  On distro kernels
   with CONFIG_SLAB_FREELIST_HARDENED=y (default) the double-free
   becomes a remote kernel BUG(); on non-hardened kernels it corrupts
   the slab freelist.

   Fix by clearing cmd->text_in_ptr after the kfree() in the ERL>0 drop
   path.  With both hunks applied #4 is directly observable on the stock
   tree without observability printks; fixing bug-1 alone would mask #4
   less, not more, so the hunks are submitted together.

Both fixes are one-liners.  The Text PDU state machine is unchanged and
the wire protocol is unaffected.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Tested-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/iscsi/iscsi_target.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2281,7 +2281,9 @@ iscsit_handle_text_cmd(struct iscsit_con
 			goto reject;
 
 		if (conn->conn_ops->DataDigest) {
-			data_crc = iscsit_crc_buf(text_in, rx_size, 0, NULL);
+			data_crc = iscsit_crc_buf(text_in,
+						  ALIGN(payload_length, 4),
+						  0, NULL);
 			if (checksum != data_crc) {
 				pr_err("Text data CRC32C DataDigest"
 					" 0x%08x does not match computed"
@@ -2300,6 +2302,7 @@ iscsit_handle_text_cmd(struct iscsit_con
 					" Command CmdSN: 0x%08x due to"
 					" DataCRC error.\n", hdr->cmdsn);
 					kfree(text_in);
+					cmd->text_in_ptr = NULL;
 					return 0;
 				}
 			} else {


