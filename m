Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CF42D94A7;
	Thu, 15 Jan 2026 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498978; cv=none; b=YiNwHc0/FrZ5iw5PVfUPfsnP/24J8oVFzsId5NlcaDKiYsTFXJ/gcT83pP1uqPdTG1OsgltouuhtV93GUlvpSWl4BoPioQMCecth/boG5qxy0tEIEbRp6ypFZLu3gv6DoIlihde0wS3eJxc4U/EcMX3TXIGeB8Udsak1EgzXq3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498978; c=relaxed/simple;
	bh=lj7e+SJuRr1Td8/VnnHkE+1YCUf6QaBOIQsyGJR7G6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAHgE0UpLx65rLGkUkdjRCd+BZCguWfAF51Z+8ALg1L7ZVtiyE2lW4Mub9+hn7MWxSGFbFk+X4npPi0dXuM/LtnQXECRGON02MRgwUX7hEhR0ro0/T79Nai13uaVknZaIt3XuVoaj48KVn/KswWLqKczGNw42gsJ6hwyL9jCIXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEOYXxD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEOYXxD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D12C116D0;
	Thu, 15 Jan 2026 17:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498978;
	bh=lj7e+SJuRr1Td8/VnnHkE+1YCUf6QaBOIQsyGJR7G6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEOYXxD23QaMVTYZrhk+4/1blBsTJ+1GJeKBs4+cAIENMnh361IYzJa8jur6dVtrD
	 1P8wCXR65u8G2jwjw2x4BLWG6jZXtr+E2ajVIhYFfpVGdrqTe57+kKozr6yGn+VLW6
	 BEJcrFozzpfXv3SW62sjUHZLOl2C3YvSJdtHb3uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/451] macintosh/mac_hid: fix race condition in mac_hid_toggle_emumouse
Date: Thu, 15 Jan 2026 17:44:27 +0100
Message-ID: <20260115164233.286769266@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 1e4b207ffe54cf33a4b7a2912c4110f89c73bf3f ]

The following warning appears when running syzkaller, and this issue also
exists in the mainline code.

 ------------[ cut here ]------------
 list_add double add: new=ffffffffa57eee28, prev=ffffffffa57eee28, next=ffffffffa5e63100.
 WARNING: CPU: 0 PID: 1491 at lib/list_debug.c:35 __list_add_valid_or_report+0xf7/0x130
 Modules linked in:
 CPU: 0 PID: 1491 Comm: syz.1.28 Not tainted 6.6.0+ #3
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
 RIP: 0010:__list_add_valid_or_report+0xf7/0x130
 RSP: 0018:ff1100010dfb7b78 EFLAGS: 00010282
 RAX: 0000000000000000 RBX: ffffffffa57eee18 RCX: ffffffff97fc9817
 RDX: 0000000000040000 RSI: ffa0000002383000 RDI: 0000000000000001
 RBP: ffffffffa57eee28 R08: 0000000000000001 R09: ffe21c0021bf6f2c
 R10: 0000000000000001 R11: 6464615f7473696c R12: ffffffffa5e63100
 R13: ffffffffa57eee28 R14: ffffffffa57eee28 R15: ff1100010dfb7d48
 FS:  00007fb14398b640(0000) GS:ff11000119600000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 000000010d096005 CR4: 0000000000773ef0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 80000000
 Call Trace:
  <TASK>
  input_register_handler+0xb3/0x210
  mac_hid_start_emulation+0x1c5/0x290
  mac_hid_toggle_emumouse+0x20a/0x240
  proc_sys_call_handler+0x4c2/0x6e0
  new_sync_write+0x1b1/0x2d0
  vfs_write+0x709/0x950
  ksys_write+0x12a/0x250
  do_syscall_64+0x5a/0x110
  entry_SYSCALL_64_after_hwframe+0x78/0xe2

The WARNING occurs when two processes concurrently write to the mac-hid
emulation sysctl, causing a race condition in mac_hid_toggle_emumouse().
Both processes read old_val=0, then both try to register the input handler,
leading to a double list_add of the same handler.

  CPU0                             CPU1
  -------------------------        -------------------------
  vfs_write() //write 1            vfs_write()  //write 1
    proc_sys_write()                 proc_sys_write()
      mac_hid_toggle_emumouse()          mac_hid_toggle_emumouse()
        old_val = *valp // old_val=0
                                           old_val = *valp // old_val=0
                                           mutex_lock_killable()
                                           proc_dointvec() // *valp=1
                                           mac_hid_start_emulation()
                                             input_register_handler()
                                           mutex_unlock()
        mutex_lock_killable()
        proc_dointvec()
        mac_hid_start_emulation()
          input_register_handler() //Trigger Warning
        mutex_unlock()

Fix this by moving the old_val read inside the mutex lock region.

Fixes: 99b089c3c38a ("Input: Mac button emulation - implement as an input filter")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250819091035.2263329-1-leo.lilong@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/mac_hid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index 28b8581b44dda..b622df9f4b231 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -186,13 +186,14 @@ static int mac_hid_toggle_emumouse(struct ctl_table *table, int write,
 				   void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int *valp = table->data;
-	int old_val = *valp;
+	int old_val;
 	int rc;
 
 	rc = mutex_lock_killable(&mac_hid_emumouse_mutex);
 	if (rc)
 		return rc;
 
+	old_val = *valp;
 	rc = proc_dointvec(table, write, buffer, lenp, ppos);
 
 	if (rc == 0 && write && *valp != old_val) {
-- 
2.51.0



