Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33CC2EC54A;
	Mon, 17 Aug 2026 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979063; cv=none; b=ocZZ4SHg0gPDUlTJcLZcTmZJY+bimNnr+GI6E4daVAzdmaGdL3ACN6+Je9g8YNhGszaVHUIsO+/NpFJadd44mI8PYUr6I+z8ar3KFqVtRfoDNlsb2CbNTpeKJInwP0Z7itzIau7Q2Xn4KEKN/+KO1shuRac6iJVBRUgLtOPo2x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979063; c=relaxed/simple;
	bh=d9sw1ld7zhkFCln1vyC+mD02T6/mrdTNM1Ul+8zWr3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkDy8aZWcy2udRFmQUJ5DQfjEqsMIQx6hTi+YvCkvNS9KQEWh4f5U/uL91X+IsbwxLcgsMZlO+wnHcXyJ1zo4GHyak+0B4FSj6zAzq/CFvT9x4wR55DcsfU4FGzVov/Jem2TLNC7qX6vKp5pHqpPSD/FL8MgZ8VlZFtH7LhV9BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jt4ZBDez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jt4ZBDez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0374D1F000E9;
	Mon, 17 Aug 2026 15:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979061;
	bh=F82WdBsbqoKtj92iK9YeWpJi40VCJx4JtTXmWweRMdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jt4ZBDezpGaet0pZcaWjkkgGWGXSqneJU+tMpyFjr56vbZRcCNmH7wRZPZpn2QrD0
	 uYkkff6e0qPxdB9Jgxe3GUtczH5UzeMb4mUUjnTofumTj7j0IxPcAlL6cPDmJQ2P/i
	 f5yx46GbJLR5bTDxZxIqRSmRG8bSDjrudw9k0rng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/609] ksmbd: validate compound request size before reading StructureSize2
Date: Mon, 17 Aug 2026 15:26:04 +0200
Message-ID: <20260817132545.768236435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index f257e096c8e17f..6a4f1b8a0b13c9 100644
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



