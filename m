Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626047;
	b=BeTDNjzKxvAI7NOvzlz7cYmnGp5CJIdwj1VTtgL6Zz7JD4CPSOhfrCs/qoK+AXabqozF
	 9chLhNnqSTbVSXXQMthasSKxcmHYuYGgRxIkw8hQo6EwO1qp2FMMvfwLq2O8a0rv9W/Qi
	 N/BbBkYKs9fPD6lE+emVEEYznU4OhLNKc/c3qhI7wF5uc7LF/oY/tGwM+184/j3LSpk3o
	 8FuEhyx11TWpyqDd/WZFRcyzHpDXSXi/gWCYB9mhnBFc+dhCGnLgMzdxdF1TYOHiqhOSD
	 9egGC3pH4T+Fw5SEtW4Au8VPXzXL5K874eQ5IJWmcMytSxSKJaWl5SIgCydQXHqmENA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LDGwiy5E6C255EDPehIS/q2U4ooemfe06yCUDF8MYiw=;
	b=RDG1n1DVw8BVCpKxQyLFjyCKuRQqKA0o1bdeJ0SFWB1PMrgqKcgAdOhlop9YZNK7bYZ7
	 R7L2jwvqLU4rgzjv9aQYEZdt1cpzK6cTgCkrOIjAx3iMqEnqPFOWsQz6z0OEc/tin02Wk
	 GU2aPrPdGPCR2Ah4HTagxE5GwNh53qP1amfqvi50fytSNyCbmzfR7X5BSpAqkqKFGcTPT
	 oRWKWDmOzZS7Rf6Nc53/wSM08z2jUSSucJkpts+yuncL9Vu3aqDm444AOxyJlWXBFHx8p
	 JXTZIHwzwo8zZ3kbZ6XKH3Shj9JdLC0G7EGTxsq33Lepq0o+ePctU4QtP2xcn0w7U3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMLJyc19;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7E5606A31E;
	Wed, 25 Nov 2026 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMLJyc19
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA5C1F000C0;
	Wed, 25 Nov 2026 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626047;
	bh=LDGwiy5E6C255EDPehIS/q2U4ooemfe06yCUDF8MYiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMLJyc19m6pj87aOaxtfsWCnFBdU8JSSzEEaH63ZItxHJXD9OsruFeIwlAzh/5UYQ
	 TRuDAEPV13q/QRoIjPVuhyaBm9Q0e6iHYiglgImvwQ9DOqlUQ5D+WvCF6MvPdme5lr
	 VIxOOn+PSYErC9EKnELH8el27ZYzfIMlkHyspNy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vadayath <jay@artiphishell.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 715/816] dm-raid: bound array_position before indexing failed_devices
Date: Wed, 25 Nov 2026 15:37:43 +0100
Message-ID: <20261125143905.725613204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Vadayath <jay@artiphishell.com>

commit 11b5cd14c0eecae458cecbe53d21a3dbc10190f5 upstream.

super_init_validation() reads role = le32_to_cpu(sb2->array_position)
out of an on-disk dm_raid_superblock and then uses it as a bit index into
the failed_devices bitmap via test_bit(role, (void *)failed_devices).
failed_devices is a uint64_t[DISKS_ARRAY_ELEMS] (DISKS_ARRAY_ELEMS == 4,
i.e. 256 bits) living on the stack. The only guard is role < 0, so any
on-disk array_position >= 256 makes test_bit() read past the end of the
stack array (array_position == 256 reads failed_devices[4], 8 bytes past
the object). For a raid1 set the role != raid_disk reorder branch falls
through to the same test_bit().

A crafted dm-raid superblock therefore causes a stack out-of-bounds read
during table load. Reachable by anyone able to issue a dmsetup create
with attacker-controlled metadata (CAP_SYS_ADMIN in the target
namespace); the crash fires in the constructor / analyse_superblocks
path, before any md_run or array sizing.

  BUG: KASAN: stack-out-of-bounds in super_validate+0x1cd0/0x3390
  Read of size 8 at addr ffff888007b17828 by task poc/152
  Call Trace:
   dump_stack_lvl+0x64/0x80
   print_report+0xd0/0x630
   kasan_report+0xe5/0x120
   kasan_check_range+0x105/0x1b0
   super_validate+0x1cd0/0x3390        (super_init_validation, inlined)
   raid_ctr+0x2c4b/0xa0f0
   dm_table_add_target+0x66f/0xf80
   table_load+0x2ee/0x780
   ctl_ioctl+0x362/0x9f0
   dm_ctl_ioctl+0x9/0x10
   __x64_sys_ioctl+0x134/0x1c0
   do_syscall_64+0xe2/0x4b0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

role is a device position that must refer to an actual member of the
array, so reject anything outside [0, rs->raid_disks) instead of only the
negative case. rs->raid_disks is always <= the 256-bit capacity of
failed_devices, so this both closes the out-of-bounds access and matches
the intended semantics.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a crafted raid1 superblock (magic "DmRd", compat_features=1,
num_devices=2, array_position=256, level=1) and a dmsetup-create
reproducer that reliably triggers the KASAN report on an unpatched kernel
(the precursor DMINFO "raid device #256 now at position #0" is visible in
the serial log just before the splat). The fix below was drafted with the
Claude coding assistant; a userspace reproducer is available on request.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jay Vadayath <jay@artiphishell.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2424,7 +2424,8 @@ static int super_init_validation(struct
 		 */
 		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >= 0)) {
 			role = le32_to_cpu(sb2->array_position);
-			if (role < 0)
+			/* Bound @role before it indexes the failed_devices stack bitmap. */
+			if (role < 0 || role >= rs->raid_disks)
 				continue;
 
 			if (role != r->raid_disk) {


