Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769081BDEC;
	Wed,  3 Jan 2024 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIpcYCAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9324C433C7;
	Wed,  3 Jan 2024 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301305;
	bh=A2uJKTRhwkWD00fPQfZTXZkdPAI2ZODyov94Bs5Ivk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIpcYCABjD29va9NZT3p443h8hq8FCVicZx0is0KdOl3QOBgX/n2eQZD3989+qyQD
	 w11UwB3WgMCsWG5t/Hd5PTOdmnQf2r4GW2CEPU1S6T+4Q7JKM8nwmvK7sqh0+LNV3N
	 u0BJQpEDZ1X7EkdLGQgAHxPhOr3gg1xNlZbyBNsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 096/100] NFSD: fix possible oops when nfsd/pool_stats is closed.
Date: Wed,  3 Jan 2024 17:55:25 +0100
Message-ID: <20240103164910.546486981@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 88956eabfdea7d01d550535af120d4ef265b1d02 upstream.

If /proc/fs/nfsd/pool_stats is open when the last nfsd thread exits, then
when the file is closed a NULL pointer is dereferenced.
This is because nfsd_pool_stats_release() assumes that the
pointer to the svc_serv cannot become NULL while a reference is held.

This used to be the case but a recent patch split nfsd_last_thread() out
from nfsd_put(), and clearing the pointer is done in nfsd_last_thread().

This is easily reproduced by running
   rpc.nfsd 8 ; ( rpc.nfsd 0;true) < /proc/fs/nfsd/pool_stats

Fortunately nfsd_pool_stats_release() has easy access to the svc_serv
pointer, and so can call svc_put() on it directly.

Fixes: 9f28a971ee9f ("nfsd: separate nfsd_last_thread() from nfsd_put()")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -1124,11 +1124,12 @@ int nfsd_pool_stats_open(struct inode *i
 
 int nfsd_pool_stats_release(struct inode *inode, struct file *file)
 {
+	struct seq_file *seq = file->private_data;
+	struct svc_serv *serv = seq->private;
 	int ret = seq_release(inode, file);
-	struct net *net = inode->i_sb->s_fs_info;
 
 	mutex_lock(&nfsd_mutex);
-	nfsd_put(net);
+	svc_put(serv);
 	mutex_unlock(&nfsd_mutex);
 	return ret;
 }


