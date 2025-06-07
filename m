Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FF221D58F;
	Sat,  7 Jun 2025 10:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291114; cv=none; b=GQs096QIR/cZnPixHnnZoqWGMnncIx+OeMxF3LZ8IKmqjHyuMUjtfN9fexyPMBshHpt18jvGSH5qhiMbQmpYgi8tldC8NF6htEk9cE8sKfwnFZCR8HsVoNhW2F6G8ngli44s9/WLJWRa6wNqSxSPEz6IY6900589cOL8HHLeKMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291114; c=relaxed/simple;
	bh=C+otZMIHTCRpH2lzMJX954T7xRVU3nNb7Jgy90CYyTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dd7+fnPqe3cp8yO8/HMUayPrVAxKymG74T6Yu9v1x0EW7NYCfpty1ki8cMQdEHrKiMlbuhFfMPo0Z15fsoULq+tt+iSmcnlzs8siZ0I55SRQqiNbqEtJgSUFq9ziCVze1BdbEWmoKEm2Ofvy65Bt6+NJ/3E3eVpBcEl3mcsNnOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8r1XOuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8r1XOuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B916FC4CEF1;
	Sat,  7 Jun 2025 10:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291114;
	bh=C+otZMIHTCRpH2lzMJX954T7xRVU3nNb7Jgy90CYyTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8r1XOuT3JLZCkqw6Z634aUp8HgKYVuGrNBAZOkt2Y1V/nCL+6UbrI05BeZ/jXQxF
	 50+xTYuIMPnItSk14sxahFteIkxbdcj4JbRvhF1AP2t4ys473M3f642D+UV0MplgLo
	 KROyAmu8AH6fKcXd640KbgDrIYwAkmnfxnTgiGjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4af454407ec393de51d6@syzkaller.appspotmail.com,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.15 28/34] binder: fix yet another UAF in binder_devices
Date: Sat,  7 Jun 2025 12:08:09 +0200
Message-ID: <20250607100720.816894979@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 9857af0fcff385c75433f2162c30c62eb912ef6d upstream.

Commit e77aff5528a18 ("binderfs: fix use-after-free in binder_devices")
addressed a use-after-free where devices could be released without first
being removed from the binder_devices list. However, there is a similar
path in binder_free_proc() that was missed:

  ==================================================================
  BUG: KASAN: slab-use-after-free in binder_remove_device+0xd4/0x100
  Write of size 8 at addr ffff0000c773b900 by task umount/467
  CPU: 12 UID: 0 PID: 467 Comm: umount Not tainted 6.15.0-rc7-00138-g57483a362741 #9 PREEMPT
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   binder_remove_device+0xd4/0x100
   binderfs_evict_inode+0x230/0x2f0
   evict+0x25c/0x5dc
   iput+0x304/0x480
   dentry_unlink_inode+0x208/0x46c
   __dentry_kill+0x154/0x530
   [...]

  Allocated by task 463:
   __kmalloc_cache_noprof+0x13c/0x324
   binderfs_binder_device_create.isra.0+0x138/0xa60
   binder_ctl_ioctl+0x1ac/0x230
  [...]

  Freed by task 215:
   kfree+0x184/0x31c
   binder_proc_dec_tmpref+0x33c/0x4ac
   binder_deferred_func+0xc10/0x1108
   process_one_work+0x520/0xba4
  [...]
  ==================================================================

Call binder_remove_device() within binder_free_proc() to ensure the
device is removed from the binder_devices list before being kfreed.

Cc: stable@vger.kernel.org
Fixes: 12d909cac1e1 ("binderfs: add new binder devices to binder_devices")
Reported-by: syzbot+4af454407ec393de51d6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4af454407ec393de51d6
Tested-by: syzbot+4af454407ec393de51d6@syzkaller.appspotmail.com
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20250524220758.915028-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5246,6 +5246,7 @@ static void binder_free_proc(struct bind
 			__func__, proc->outstanding_txns);
 	device = container_of(proc->context, struct binder_device, context);
 	if (refcount_dec_and_test(&device->ref)) {
+		binder_remove_device(device);
 		kfree(proc->context->name);
 		kfree(device);
 	}


