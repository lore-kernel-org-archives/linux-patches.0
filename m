Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0B1E2834;
	Wed, 25 Feb 2026 01:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983666; cv=none; b=iEtSoHCHVZOZcDu7uwWkmQkxVj2cIkZ+jO/bKTWD5ontnuWXX7EXgABtMHBiAJo5PHql/vXeOedMBIfPbbtd/cZNuxiCNYuoG/lGsjSijsB2XdqgbI950287nyS78xP0C1PrY/J1uNeDMKSf4mSlDC4V60URDGi0+BgAGkrKKGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983666; c=relaxed/simple;
	bh=YTtBa+fL6PMiMjCTMQcaXmxCHAgTKYd67KhDNCxJQIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmmszbRke/Ka61ZVWuNWGLV+airGv9sbCmr3bbzpuFpTtKHs0IlbtsWcaZ8TfB7Nk6+X7Div6ASHXhDS8YOdzEDjGOaVsIMn1QqgqStvf7UEh49Iei3KLOJaKFECo4Gp94GFXTQEQTNNu+OVusD8CaiPahkN0lcUAzioHKJ2cIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvEBwPN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvEBwPN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B65C116D0;
	Wed, 25 Feb 2026 01:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983666;
	bh=YTtBa+fL6PMiMjCTMQcaXmxCHAgTKYd67KhDNCxJQIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvEBwPN7mQstFyDDUXoDmkCZtTyU+zwRPBiqODGZjtsEzok+55RR1uctYd0ZZbpVD
	 46Yi0RYp9iS+X5O+cjkLxO+pxLHj5wd+7OQOxys6hxdZqrh3JYDcvgyis5vrEEveHW
	 4aJYwTIMxUYie5DXWlA3o2AcOsGlgefa5Lm0jkig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 753/781] ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths
Date: Tue, 24 Feb 2026 17:24:22 -0800
Message-ID: <20260225012418.189736209@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit a09dc10d1353f0e92c21eae2a79af1c2b1ddcde8 upstream.

There are two places where ksmbd_vfs_kern_path_end_removing() needs to be
called in order to balance what the corresponding successful call to
ksmbd_vfs_kern_path_start_removing() has done, i.e. drop inode locks and
put the taken references.  Otherwise there might be potential deadlocks
and unbalanced locks which are caught like:

BUG: workqueue leaked lock or atomic: kworker/5:21/0x00000000/7596
     last function: handle_ksmbd_work
2 locks held by kworker/5:21/7596:
 #0: ffff8881051ae448 (sb_writers#3){.+.+}-{0:0}, at: ksmbd_vfs_kern_path_locked+0x142/0x660
 #1: ffff888130e966c0 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: ksmbd_vfs_kern_path_locked+0x17d/0x660
CPU: 5 PID: 7596 Comm: kworker/5:21 Not tainted 6.1.162-00456-gc29b353f383b #138
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: ksmbd-io handle_ksmbd_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x44/0x5b
 process_one_work.cold+0x57/0x5c
 worker_thread+0x82/0x600
 kthread+0x153/0x190
 ret_from_fork+0x22/0x30
 </TASK>

Found by Linux Verification Center (linuxtesting.org).

Fixes: d5fc1400a34b ("smb/server: avoid deadlock when linking with ReplaceIfExists")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6114,14 +6114,14 @@ static int smb2_create_link(struct ksmbd
 				rc = -EINVAL;
 				ksmbd_debug(SMB, "cannot delete %s\n",
 					    link_name);
-				goto out;
 			}
 		} else {
 			rc = -EEXIST;
 			ksmbd_debug(SMB, "link already exists\n");
-			goto out;
 		}
 		ksmbd_vfs_kern_path_end_removing(&path);
+		if (rc)
+			goto out;
 	}
 	rc = ksmbd_vfs_link(work, target_name, link_name);
 	if (rc)


