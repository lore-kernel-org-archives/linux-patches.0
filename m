Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0AC21ABA5;
	Sat,  7 Jun 2025 10:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291018; cv=none; b=bxmICOEz1eETXBHuVpbf8jR4CYfeWivrt4HG5vVGiQkVbNMXATM1GTrHI9AlBZfEBNVSHNeyhG391NTGB7iNWmMY0w+QnGGalZGQyv7tTkZhOwHFeO5a4gM+VvbCKsZzDnFzGGlsZKki5BX6Rxe7aOKMX6PlVFkzYIFWWeeXwpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291018; c=relaxed/simple;
	bh=Jj/trqS7E7fRgBjMAQO0CpXZkL/8BhacDOtiHgktwMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3nkzRPJ3yvRJH1zdossGpNzUWbPEKqYEmq//C8gBVW3+WPnkeLbvhpBiEzLq0B9XSU8rB+n1ZpPW0O3LhZQkb7n79/Pvyc4MoFKuMsFHXZj0d9OFDTl1bzuRQeRS4BmlxLQwVrfsxTgR1Yv7udnOUqzcY7vyVnvvTY3yVHd8Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIhWYr25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIhWYr25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDF1C4CEE4;
	Sat,  7 Jun 2025 10:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291018;
	bh=Jj/trqS7E7fRgBjMAQO0CpXZkL/8BhacDOtiHgktwMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIhWYr25XrOmimwwdhfQHjnRGFBb66lAK1hFSGsghCA+E30eY3f2Lc/0bE9f1MzPA
	 TSdN4T+fvtr7Jf1+Kwrl6xxCA+YCmJALHDYiYpMuSCAUKJeay1DWyr7o1QYisbBVNG
	 pnV1DPvzJl1dUx546dvsxZQzYZLgpVx+qiRLSZds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4af454407ec393de51d6@syzkaller.appspotmail.com,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.14 19/24] binder: fix yet another UAF in binder_devices
Date: Sat,  7 Jun 2025 12:07:59 +0200
Message-ID: <20250607100718.447036599@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


