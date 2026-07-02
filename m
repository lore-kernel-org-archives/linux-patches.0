Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DA93491E1;
	Thu,  2 Jul 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010699; cv=none; b=j52KWPo5fsaJqQfOuH+H/lnFY0m1Z0ciwqSbPGkaltabIE6zFSzKDyCR1VbmbC4O6QtBJxaXkomvIip+2Vj4g8T4NWJDK6C2bBdClPkWSBexQXv0dllnTwTQhhtGaSo2wHaTR4FOS/2sKyF1qNacrJ5XO3ejIwkd0ddpMxVxTWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010699; c=relaxed/simple;
	bh=OvNnpN0TLjjbaa14E+nFOjCtKVymb7xbKXvLEqWU8i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K91wRfZE3NgjTKSGKJTsyd8iT8aTxl5hipZtXqovOuhAo5Pcrw6ZZTH48Wbq/QuPAUIsAi90uyZoz1Zc6pC2bcv2FPekqmfFgS0VDvsxBOJxSfrI0fJBOOH2BdYticXHMiLphbb7ZkIrU3M70CfktjFp0k24+4L1fVJAjfcz5Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbLujieT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbLujieT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7C11F000E9;
	Thu,  2 Jul 2026 16:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010698;
	bh=W0M6cEUIUYR5ndRhqsNoUJkeqopeKsbb/IJH4yVWgM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbLujieT+Xp30P53csTGpNorHuLNi2T0v7Q/WDQ8tPq5kF8Smxy+M5x2g8BpdjpAn
	 kvmiaw3sPXriH50nFZWHp/2GoqgcD0Tv0e3u9r9/XvmBNp0iE20TkmUgYx5SXKtZHQ
	 7nM1PZC6GMKlmURa6m9j6oGFdzdoxFK2XtfOhmik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+42a37bf8045847d8f9d2@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.12 164/204] gfs2: fix use-after-free in gfs2_qd_dealloc
Date: Thu,  2 Jul 2026 18:20:21 +0200
Message-ID: <20260702155122.094731853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit f9c9ec2c319f843b70ecdf939d48b52d189bc081 upstream.

gfs2_qd_dealloc(), called as an RCU callback from gfs2_qd_dispose(),
accesses the superblock object sdp through qd->qd_sbd after freeing qd.
It does so to decrement sd_quota_count and wake up sd_kill_wait.

However, by the time the RCU callback runs, gfs2_put_super() may have
already freed sdp via free_sbd().  This can happen when
gfs2_quota_cleanup() is called during unmount: it disposes of quota
objects via call_rcu() and then waits on sd_kill_wait with a 60-second
timeout.  If the timeout expires, or if gfs2_gl_hash_clear() triggers
additional qd_put() calls that schedule more RCU callbacks after the
wait completes, gfs2_put_super() will proceed to free the superblock
while RCU callbacks referencing it are still pending.

Add an rcu_barrier() before free_sbd() in gfs2_put_super() to ensure
all pending RCU callbacks (including gfs2_qd_dealloc) have completed
before the superblock is freed.

Fixes: a475c5dd16e5 ("gfs2: Free quota data objects synchronously")
Reported-by: syzbot+42a37bf8045847d8f9d2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=42a37bf8045847d8f9d2
Tested-by: syzbot+42a37bf8045847d8f9d2@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -652,6 +652,7 @@ restart:
 	gfs2_delete_debugfs_file(sdp);
 
 	gfs2_sys_fs_del(sdp);
+	rcu_barrier();
 	free_sbd(sdp);
 }
 


