Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B415442FBC;
	Thu, 30 Jul 2026 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423811; cv=none; b=oU5BR+aW1jankqntdxx7SnoGUh0lxH4orNA3dLqKlRRhrr1EYXmUcX7Tpt8wzZbomYKErDFzTWfq7prP10PZCUGknVxszXIDQdf8xpas7mJTXh26nHufZqh6Lvo8iPM+QVrbMCa+wouoVrJl6LR2AA0y7v6XUu2yDZ+3al8DAck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423811; c=relaxed/simple;
	bh=kCMof6L7T5br+iDTUrgNDlSEp8BZFctv5omtyGnsoHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxyFgrKgqAjVRfzareR/mwbOJx2QuT4AbhqgWCgDbQDhcqbk5DctYTCrByGCTJz7C3BajIKBFFMIUn2uEyf9pV/Vj+1PiRP0daCtbk8jtby/puWtn3evqVElquJBSVOeYZuKG6ju0D0fEuEaYQSzX1q/2E0HFAttKhwBJhvJSfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjNS1TB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjNS1TB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FF91F01562;
	Thu, 30 Jul 2026 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423810;
	bh=LcZQms3uZoLWdw27tZHdnIvpHxmoNY3WOTiUs0Fr2FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjNS1TB4RfpyuZRIn6iI345yFqwqt161lSheOGZhvJUx+3ca96fiLZkIzoG+vtcUc
	 LTslz7Z68m8iW3B4x0zWXJiltv5ccC9SEqrUm8OLss4cELGHFKBnNzvCE4Q/LdBOK5
	 8XAs95fdPzJjnSlGZNx8I6qbSlIQLcCrMNBIybag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/675] ksmbd: validate compound request size before reading StructureSize2
Date: Thu, 30 Jul 2026 16:07:40 +0200
Message-ID: <20260730141447.907582470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 67a2d7a793f6ed..b11d854d3fcfba 100644
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



