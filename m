Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4CE1BDA95;
	Thu, 30 Jan 2025 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246808; cv=none; b=Wj4G1WzxxBqxeMy6SZcoEJvb3InaxBuRyUhih+B1EbG4rGAQ3xksZKX0dibuRFV/RR7NON1GRFeJbrsQC69wM4Llx055WiBDCt13hPVqztCm5xduLcmWZb2lVN+DvgzYg5JZIL4lseD43k60fImVLrngsRHJP11SnhlsIAiCNBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246808; c=relaxed/simple;
	bh=lzOoedfmIovX7pi4pq20lBHJB/6IqEsBmAJXEVbwThs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAi7mjulnxZZy3GHvMV/d9Wt/DOtb2sZONh3Bqxow/3b5iF45bzOrYyqYdgFzLy0pNJRvBLOeeKZtyu2lJH4+Bu5W8Db//2lnfNEVCXqJABI50x8+DjUKTErg+5Ccx/LaU+x0rZJ6usWeCG7HWtaQcY1bgjjhUvHZRTe0S/1SDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXngzQmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXngzQmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579ACC4CED2;
	Thu, 30 Jan 2025 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246808;
	bh=lzOoedfmIovX7pi4pq20lBHJB/6IqEsBmAJXEVbwThs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXngzQmpa9WVM1lurKeyv08UWOE1GN6uuNg1pn06M0FvdUh8gmFjDpxi+qaaGi7yM
	 lR1bVUQZRmLunSZKesgR24KijAfdOteBBpILSbc2/cur1ROCvGbHcsFY0xDT8UY/vm
	 WCyq0IX0m4w4v6OFD6Vai2j7LgSSirCeuZk3YzYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com,
	Suraj Sonawane <surajsonawane0215@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	BRUNO VERNAY <bruno.vernay@se.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.4 73/91] scsi: sg: Fix slab-use-after-free read in sg_release()
Date: Thu, 30 Jan 2025 15:01:32 +0100
Message-ID: <20250130140136.613684030@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Sonawane <surajsonawane0215@gmail.com>

commit f10593ad9bc36921f623361c9e3dd96bd52d85ee upstream.

Fix a use-after-free bug in sg_release(), detected by syzbot with KASAN:

BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30
kernel/locking/lockdep.c:5838
__mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:912
sg_release+0x1f4/0x2e0 drivers/scsi/sg.c:407

In sg_release(), the function kref_put(&sfp->f_ref, sg_remove_sfp) is
called before releasing the open_rel_lock mutex. The kref_put() call may
decrement the reference count of sfp to zero, triggering its cleanup
through sg_remove_sfp(). This cleanup includes scheduling deferred work
via sg_remove_sfp_usercontext(), which ultimately frees sfp.

After kref_put(), sg_release() continues to unlock open_rel_lock and may
reference sfp or sdp. If sfp has already been freed, this results in a
slab-use-after-free error.

Move the kref_put(&sfp->f_ref, sg_remove_sfp) call after unlocking the
open_rel_lock mutex. This ensures:

 - No references to sfp or sdp occur after the reference count is
   decremented.

 - Cleanup functions such as sg_remove_sfp() and
   sg_remove_sfp_usercontext() can safely execute without impacting the
   mutex handling in sg_release().

The fix has been tested and validated by syzbot. This patch closes the
bug reported at the following syzkaller link and ensures proper
sequencing of resource cleanup and mutex operations, eliminating the
risk of use-after-free errors in sg_release().

Reported-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7efb5850a17ba6ce098b
Tested-by: syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
Fixes: cc833acbee9d ("sg: O_EXCL and other lock handling")
Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
Link: https://lore.kernel.org/r/20241120125944.88095-1-surajsonawane0215@gmail.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: BRUNO VERNAY <bruno.vernay@se.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -390,7 +390,6 @@ sg_release(struct inode *inode, struct f
 
 	mutex_lock(&sdp->open_rel_lock);
 	scsi_autopm_put_device(sdp->device);
-	kref_put(&sfp->f_ref, sg_remove_sfp);
 	sdp->open_cnt--;
 
 	/* possibly many open()s waiting on exlude clearing, start many;
@@ -402,6 +401,7 @@ sg_release(struct inode *inode, struct f
 		wake_up_interruptible(&sdp->open_wait);
 	}
 	mutex_unlock(&sdp->open_rel_lock);
+	kref_put(&sfp->f_ref, sg_remove_sfp);
 	return 0;
 }
 


