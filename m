Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD78149C51;
	Fri,  6 Dec 2024 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498754; cv=none; b=VpH93WeVj4re3H1CTdObOtClE6Mu/ok9pDFE2jJM3z/QQp3upnTwvjnf93m8+1B2m5LBXr7sqM99zIG5oBBDYejg54c8F/c4//ac7wVbvOxyN89BLcaDt22TgnGs5ScQDxWXkD+FqFuqUNVw+z6GKgB6gKN7zGwY0H8TMwnU15s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498754; c=relaxed/simple;
	bh=FG8Ap0c1EEcM7SpEydFYpGWYOSzBmEyJw0O+05CtlIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtCzYG6hc/Hdq9baVPapVJETNJW1ECQpSmBv6GnYArF6FciE1BW/0OAoVCKOLkdBTD9A8lNuamJUaWRDvHlvfZ5Ya1nlqC4xLDCO50f1TFyiDTGVpMWTth0iEZ27suA6PyTFLiANcD8OFiqHGGcMTmIj/FFg6aEkm879df4JYfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzaxjEck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzaxjEck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825E7C4CEDC;
	Fri,  6 Dec 2024 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498754;
	bh=FG8Ap0c1EEcM7SpEydFYpGWYOSzBmEyJw0O+05CtlIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzaxjEck7b4QhZ4KYJipHobhJ525M8eQPzMXFc2NUAbSrAPEkLT81og6SaiHV0qYp
	 yWsIviHHq9VWY1bTPq/XdINdfds4Mtb8+RErvhLQxJrvfltij2cFLUWPBghGhSAGJN
	 ulYFzsLgISF6luSxDRcnwjSLOnbAO9DLpiV/ByWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 656/676] nfsd: make sure exp active before svc_export_show
Date: Fri,  6 Dec 2024 15:37:55 +0100
Message-ID: <20241206143718.991803222@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

commit be8f982c369c965faffa198b46060f8853e0f1f0 upstream.

The function `e_show` was called with protection from RCU. This only
ensures that `exp` will not be freed. Therefore, the reference count for
`exp` can drop to zero, which will trigger a refcount use-after-free
warning when `exp_get` is called. To resolve this issue, use
`cache_get_rcu` to ensure that `exp` remains active.

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 3 PID: 819 at lib/refcount.c:25
refcount_warn_saturate+0xb1/0x120
CPU: 3 UID: 0 PID: 819 Comm: cat Not tainted 6.12.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
RIP: 0010:refcount_warn_saturate+0xb1/0x120
...
Call Trace:
 <TASK>
 e_show+0x20b/0x230 [nfsd]
 seq_read_iter+0x589/0x770
 seq_read+0x1e5/0x270
 vfs_read+0x125/0x530
 ksys_read+0xc1/0x160
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: bf18f163e89c ("NFSD: Using exp_get for export getting")
Cc: stable@vger.kernel.org # 4.20+
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/export.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1385,9 +1385,12 @@ static int e_show(struct seq_file *m, vo
 		return 0;
 	}
 
-	exp_get(exp);
+	if (!cache_get_rcu(&exp->h))
+		return 0;
+
 	if (cache_check(cd, &exp->h, NULL))
 		return 0;
+
 	exp_put(exp);
 	return svc_export_show(m, cd, cp);
 }


