Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E84D433E87;
	Thu,  2 Jul 2026 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011652; cv=none; b=AEV05gJ1DAGX6krGY1NJsBblPYRfLom9CAYzshv39NtVy2L/fNu3AOoivb1MzwT3N/rxral7bip02zOYSTZeZ6r/L4MHKY0jR7DmrmA34PCDbqNcqYKYOR1WqsazjLc6CN7wbJq/E1smOd+8ApJWWUxw2aCdplKQnXfibK1S+qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011652; c=relaxed/simple;
	bh=PiyIF8mIdnipiYcObKZw793xKZ7MVTUyN3ppmLGRQWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocM7Hcybt2mpAQUYE5yrji6ZFDQgJU0uk+Rcl77wecEQJCTS+bF+uNXr6pTxrLHvoPudIEOsU1Of7LSLXXTpGj3pIsRPC2AnsUj5Pt5BFZDgeX7l2+1MToZ+rQnlegphgZ60IrwI2MOHd2T7SPHGiudJokfYzhdB1R7XrutSveo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqyin96c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqyin96c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012451F000E9;
	Thu,  2 Jul 2026 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011651;
	bh=JvHj066W9GUM936W4IUoy+TgtS7j0tcgzH/ALBLTTqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqyin96cEFFgh1d9UtnD4fFpbmhE+ikzOfSJmh69uwqoyPIiiPzU6eHaNhG9F6KV7
	 URUnUF154OBGOkuws6GZ+tLVgszfDtVDsDmQO+KR4SVKyZh0Iwh+9aYH8ymQV768NV
	 kODX/JNq/Cxa1mRqDu7SElokrmCGKBSkLVKwAbZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+42a37bf8045847d8f9d2@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 7.1 080/120] gfs2: fix use-after-free in gfs2_qd_dealloc
Date: Thu,  2 Jul 2026 18:21:16 +0200
Message-ID: <20260702155114.615729554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -643,6 +643,7 @@ restart:
 	gfs2_delete_debugfs_file(sdp);
 
 	gfs2_sys_fs_del(sdp);
+	rcu_barrier();
 	free_sbd(sdp);
 }
 


