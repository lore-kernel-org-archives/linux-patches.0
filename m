Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E652C2459D1;
	Thu, 28 May 2026 20:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999351; cv=none; b=f0cLnPng2ZnWyz6rwrGGkkAELfNeHUhRdc3l/pqLs+M+h1vVYkHAsSXYjQOWnseZvEPUrY0bcOn345vA3HR7sPu0/3ueN9swiKnIV2GTRb/FCj0bQg6v1vmXS/qp/sbGcK/qZTXNpB7S46tmqSgWcobWQVfe5QE73hIYcQdbjUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999351; c=relaxed/simple;
	bh=BdHX4xjprSzLpCF/w6KHa0M3/awU4sXi+JU0AgeBG/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOI+HkB9H/OLl62Hz3gi9w3nLt3RfzysC3iQx48jOPNmg+3R8oT/L4WBJGeOSf36HlNcu3RhcTw4utB5BmkIj9fYSevYDZv96GwI6qi8OD5DAVw3D+/fb0G9nr/PWOdBOrnEke0M/mCaf18gNLtyg+pnGTj4uWmfOu6qOBzEYCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPRylR4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPRylR4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519791F000E9;
	Thu, 28 May 2026 20:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999349;
	bh=MdB3o42altVIbyhj0YPjFqyvzzWHz4bnpLcd3KEGziQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPRylR4jUgO8K0zex65hrgtCQC6vnwaq7Ee8xTdaQQXT7yO7VJt52JUYA1BRoCZrp
	 WVRiFFoPxBcLzyLuZCDjRDt8o4tCZ/SeEGORebwus8zwvXsHZpm5rHVfjpR0As6h9j
	 4jaT7qfVPKw/DLdQzXybLwXZP0zDhhsF6t34IKbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/377] cxl/mbox: validate payload size before accessing contents in cxl_payload_from_user_allowed()
Date: Thu, 28 May 2026 21:44:03 +0200
Message-ID: <20260528194638.539341082@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 60b5d1f68338aff2c5af0113f04aefa7169c50c2 ]

cxl_payload_from_user_allowed() casts and dereferences the input
payload without first verifying its size. When a raw mailbox command
is sent with an undersized payload (ie: 1 byte for CXL_MBOX_OP_CLEAR_LOG,
which expects a 16-byte UUID), uuid_equal() reads past the allocated buffer,
triggering a KASAN splat:

BUG: KASAN: slab-out-of-bounds in memcmp+0x176/0x1d0 lib/string.c:683
Read of size 8 at addr ffff88810130f5c0 by task syz.1.62/2258

CPU: 2 UID: 0 PID: 2258 Comm: syz.1.62 Not tainted 6.19.0-dirty #3 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xab/0xe0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xce/0x650 mm/kasan/report.c:482
 kasan_report+0xce/0x100 mm/kasan/report.c:595
 memcmp+0x176/0x1d0 lib/string.c:683
 uuid_equal include/linux/uuid.h:73 [inline]
 cxl_payload_from_user_allowed drivers/cxl/core/mbox.c:345 [inline]
 cxl_mbox_cmd_ctor drivers/cxl/core/mbox.c:368 [inline]
 cxl_validate_cmd_from_user drivers/cxl/core/mbox.c:522 [inline]
 cxl_send_cmd+0x9c0/0xb50 drivers/cxl/core/mbox.c:643
 __cxl_memdev_ioctl drivers/cxl/core/memdev.c:698 [inline]
 cxl_memdev_ioctl+0x14f/0x190 drivers/cxl/core/memdev.c:713
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xa8/0x330 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdaf331ba79
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fdaf1d77038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fdaf3585fa0 RCX: 00007fdaf331ba79
RDX: 00002000000001c0 RSI: 00000000c030ce02 RDI: 0000000000000003
RBP: 00007fdaf33749df R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdaf3586038 R14: 00007fdaf3585fa0 R15: 00007ffced2af768
 </TASK>

Add 'in_size' parameter to cxl_payload_from_user_allowed() and validate
the payload is large enough.

Fixes: 6179045ccc0c ("cxl/mbox: Block immediate mode in SET_PARTITION_INFO command")
Fixes: 206f9fa9d555 ("cxl/mbox: Add Clear Log mailbox command")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260220001618.963490-2-dave@stgolabs.net
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index fa6dd0c94656f..e7a6452bf5445 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -311,6 +311,7 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
  * cxl_payload_from_user_allowed() - Check contents of in_payload.
  * @opcode: The mailbox command opcode.
  * @payload_in: Pointer to the input payload passed in from user space.
+ * @in_size: Size of @payload_in in bytes.
  *
  * Return:
  *  * true	- payload_in passes check for @opcode.
@@ -325,12 +326,15 @@ static bool cxl_mem_raw_command_allowed(u16 opcode)
  *
  * The specific checks are determined by the opcode.
  */
-static bool cxl_payload_from_user_allowed(u16 opcode, void *payload_in)
+static bool cxl_payload_from_user_allowed(u16 opcode, void *payload_in,
+					  size_t in_size)
 {
 	switch (opcode) {
 	case CXL_MBOX_OP_SET_PARTITION_INFO: {
 		struct cxl_mbox_set_partition_info *pi = payload_in;
 
+		if (in_size < sizeof(*pi))
+			return false;
 		if (pi->flags & CXL_SET_PARTITION_IMMEDIATE_FLAG)
 			return false;
 		break;
@@ -338,6 +342,8 @@ static bool cxl_payload_from_user_allowed(u16 opcode, void *payload_in)
 	case CXL_MBOX_OP_CLEAR_LOG: {
 		const uuid_t *uuid = (uuid_t *)payload_in;
 
+		if (in_size < sizeof(uuid_t))
+			return false;
 		/*
 		 * Restrict the ‘Clear log’ action to only apply to
 		 * Vendor debug logs.
@@ -365,7 +371,8 @@ static int cxl_mbox_cmd_ctor(struct cxl_mbox_cmd *mbox_cmd,
 		if (IS_ERR(mbox_cmd->payload_in))
 			return PTR_ERR(mbox_cmd->payload_in);
 
-		if (!cxl_payload_from_user_allowed(opcode, mbox_cmd->payload_in)) {
+		if (!cxl_payload_from_user_allowed(opcode, mbox_cmd->payload_in,
+						  in_size)) {
 			dev_dbg(cxl_mbox->host, "%s: input payload not allowed\n",
 				cxl_mem_opcode_to_name(opcode));
 			kvfree(mbox_cmd->payload_in);
-- 
2.53.0



