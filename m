Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932D5611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFC4C433EF;
	Sun, 28 May 2023 19:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302475;
	bh=4ZPCwhkH1brojeZZcV9gpHcRj54LzG/1n3oPSBY+ijA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q619cOsGVMiv+tDDUcml+Rv3blPxKPPdC03aE5ZokHCcw2puCIWVQA5j3RN5+xlRU
	 5wv5sxvKmBnq5AJTVZvSm1NskksO991XdRzY8ogjlUwnnoHCDdgdZpy/BvZDfBn4r3
	 tGrfOQBX+Yazjpoz/6NXFHkMjcSuNYdfbbNCEBwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1 018/119] platform/x86/intel/ifs: Annotate work queue on stack so object debug does not complain
Date: Sun, 28 May 2023 20:10:18 +0100
Message-Id: <20230528190835.937793702@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Arcari <darcari@redhat.com>

commit 3279decb2c3c8d58cb0b70ed5235c480735a36ee upstream.

Object Debug results in the following warning while attempting to load
ifs firmware:

[  220.007422] ODEBUG: object 000000003bf952db is on stack 00000000e843994b, but NOT annotated.
[  220.007459] ------------[ cut here ]------------
[  220.007461] WARNING: CPU: 0 PID: 11774 at lib/debugobjects.c:548 __debug_object_init.cold+0x22e/0x2d5
[  220.137476] RIP: 0010:__debug_object_init.cold+0x22e/0x2d5
[  220.254774] Call Trace:
[  220.257641]  <TASK>
[  220.265606]  scan_chunks_sanity_check+0x368/0x5f0 [intel_ifs]
[  220.288292]  ifs_load_firmware+0x2a3/0x400 [intel_ifs]
[  220.332793]  current_batch_store+0xea/0x160 [intel_ifs]
[  220.357947]  kernfs_fop_write_iter+0x355/0x530
[  220.363048]  new_sync_write+0x28e/0x4a0
[  220.381226]  vfs_write+0x62a/0x920
[  220.385160]  ksys_write+0xf9/0x1d0
[  220.399421]  do_syscall_64+0x59/0x90
[  220.440635]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  220.566845] ---[ end trace 3a01b299db142b41 ]---

Correct this by calling INIT_WORK_ONSTACK instead of INIT_WORK.

Fixes: 684ec215706d ("platform/x86/intel/ifs: Authenticate and copy to secured memory")

Signed-off-by: David Arcari <darcari@redhat.com>
Cc: Jithu Joseph <jithu.joseph@intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Gross <markgross@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230523105400.674152-1-darcari@redhat.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/ifs/load.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -154,7 +154,7 @@ static int scan_chunks_sanity_check(stru
 			continue;
 		reinit_completion(&ifs_done);
 		local_work.dev = dev;
-		INIT_WORK(&local_work.w, copy_hashes_authenticate_chunks);
+		INIT_WORK_ONSTACK(&local_work.w, copy_hashes_authenticate_chunks);
 		schedule_work_on(cpu, &local_work.w);
 		wait_for_completion(&ifs_done);
 		if (ifsd->loading_error)


