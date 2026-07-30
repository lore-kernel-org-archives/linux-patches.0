Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417BB3C1D70;
	Thu, 30 Jul 2026 15:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425547; cv=none; b=mjoVRbjU9Tc0OkwkGzx59CRZT+g7qDkpdxpxITAaU08RsyEgEqH0rQKLpiLltqFjrY8UHMrU9jmOU6yjMS2n3vCrqvv0ek7uGSWKGBW7pWbf4DBBZkRO0EbckOcb4PrVOeo9HvMW5AZ/nrQiJWLMS/LLjjuHuWXQdkN1bv5Tx1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425547; c=relaxed/simple;
	bh=qq6xq8WNhD2woY5ikldvD4rH6SSdXJp8VOgRSc0BnII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pp8qInkUHBOvG+2rO4j6HFKoOKUblS3Azgivb5QBuR0pnQI3oQO6QmU28PkeXw875qwOSt20yfJRoyJPjIxgUYpCJumtYt/ulmBH8Uaf3Wv2GV71irZI7OHntjy0W+GmbunPC4+kUtQFyCUKFTprSxAl0k00fOWx6aT8YIlOZnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6avKSdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6avKSdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A80B1F000E9;
	Thu, 30 Jul 2026 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425546;
	bh=M7LLQgjGodZD5ujaufUOq4UatO2nJijA7d6buecM8dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6avKSdhgsc0BUoQZFulkcu8ljuEPFizkjF9mqjcj6J2BTUJKqm6mFciJPpaEBxrH
	 nBa13eWkPT1Q07wS6a+tNLFa8ddq5pRzerS7qA6lhf1nTOtBxqUZGxrL9AZNgYHk2D
	 tpHrtaxnROHhJwlRKBmNHaz8m2g0EQLyGqaHuMV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/602] ksmbd: validate compound request size before reading StructureSize2
Date: Thu, 30 Jul 2026 16:08:20 +0200
Message-ID: <20260730141438.260647574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 15b38176fd1530372905c602fde51fe89ec8c877 ]

When ksmbd validates a compound (chained) SMB2 request,
ksmbd_smb2_check_message() reads pdu->StructureSize2 without first
checking that the compound element is large enough to contain it.
StructureSize2 is a 2-byte field at offset 64
(__SMB2_HEADER_STRUCTURE_SIZE) from the start of each element.

The compound-walking logic only guarantees that a full 64-byte SMB2
header is present for the trailing element: when NextCommand is 0, len is
reduced to the number of bytes remaining after next_smb2_rcv_hdr_off. A
remote client can craft a compound request whose last element has exactly
64 bytes, so the 2-byte StructureSize2 read at offset 64 extends one byte
past the receive buffer, producing a slab-out-of-bounds read.

  BUG: KASAN: slab-out-of-bounds in ksmbd_smb2_check_message (fs/smb/server/smb2misc.c:402)
  Read of size 2 at addr ffff888012ae31ac by task kworker/0:1/14
  The buggy address is located 172 bytes inside of allocated 173-byte region
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   ksmbd_smb2_check_message (fs/smb/server/smb2misc.c:402)
   handle_ksmbd_work (fs/smb/server/server.c:119)
   process_one_work (kernel/workqueue.c:3314)
   worker_thread (kernel/workqueue.c:3397)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

Reject any compound element that is too small to hold StructureSize2
before dereferencing it.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2misc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2misc.c b/fs/smb/server/smb2misc.c
index ae501024665e1f..6317edbfe4fa43 100644
--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -400,6 +400,11 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 		return 1;
 	}
 
+	if (len < __SMB2_HEADER_STRUCTURE_SIZE + sizeof(__le16)) {
+		ksmbd_debug(SMB, "Message is too small for StructureSize2\n");
+		return 1;
+	}
+
 	if (smb2_req_struct_sizes[command] != pdu->StructureSize2) {
 		if (!(command == SMB2_OPLOCK_BREAK_HE &&
 		    (le16_to_cpu(pdu->StructureSize2) == OP_BREAK_STRUCT_SIZE_20 ||
-- 
2.53.0



