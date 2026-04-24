Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4053E3563D4;
	Fri, 24 Apr 2026 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038228; cv=none; b=W2UxxnYBSr+Uzak70GP2j7+CCPmIlPIc2lyguyEiRf0UtlWuHC4itRj+JJhYT3LhlMAHVwkNIVxj8gDXLVBTESlR0pzkI2jbh7oIP3GBBq/LGJ/3oIGy4nb4yKDu/S8KqhUP3bfuq3HfvF8GTSzIOUoVRzSCT9OIK3tG+/RdHY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038228; c=relaxed/simple;
	bh=z7XXMUe6AJV7eWKHaIXknmqr56/bsqEPZhcUfMn4+ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mySRRvyyKLhoHl+VjUf0KHVrxak2H//hf99s/Rsb2vzwgLgnBY9I98j9QgpkJGSMUwJ11gcJ7zyw56nCMS6LIhODYi08FFzRRzprMehM+SBizG9MzHwNUrevqTA7x1mo8SoTB7gCyrfNcIqR0ya/WUMA+t0aW+em7wPlv8pGC1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTs/0S71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTs/0S71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA04EC19425;
	Fri, 24 Apr 2026 13:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038228;
	bh=z7XXMUe6AJV7eWKHaIXknmqr56/bsqEPZhcUfMn4+ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTs/0S71rCnDGX5ZqLYjSjrdbD8fOzoRytXu78OIxty1wsflikLWV30EsOMDUQTX2
	 vXUXvjao487fdTTqgO+Jk/KVlq65bGKcG9Rg6kL1DaCu5ZJtxEvtW4rndWuH5w8U8c
	 Xye7BrzjbZ4WVcNOD6k8Ewh3S0gr6ZGbLZIRRUFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 18/35] fuse: quiet down complaints in fuse_conn_limit_write
Date: Fri, 24 Apr 2026 15:31:25 +0200
Message-ID: <20260424132415.501060309@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 129a45f9755a89f573c6a513a6b9e3d234ce89b0 upstream.

gcc 15 complains about an uninitialized variable val that is passed by
reference into fuse_conn_limit_write:

 control.c: In function ‘fuse_conn_congestion_threshold_write’:
 include/asm-generic/rwonce.h:55:37: warning: ‘val’ may be used uninitialized [-Wmaybe-uninitialized]
    55 |         *(volatile typeof(x) *)&(x) = (val);                            \
       |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
 include/asm-generic/rwonce.h:61:9: note: in expansion of macro ‘__WRITE_ONCE’
    61 |         __WRITE_ONCE(x, val);                                           \
       |         ^~~~~~~~~~~~
 control.c:178:9: note: in expansion of macro ‘WRITE_ONCE’
   178 |         WRITE_ONCE(fc->congestion_threshold, val);
       |         ^~~~~~~~~~
 control.c:166:18: note: ‘val’ was declared here
   166 |         unsigned val;
       |                  ^~~

Unfortunately there's enough macro spew involved in kstrtoul_from_user
that I think gcc gives up on its analysis and sprays the above warning.
AFAICT it's not actually a bug, but we could just zero-initialize the
variable to enable using -Wmaybe-uninitialized to find real problems.

Previously we would use some weird uninitialized_var annotation to quiet
down the warnings, so clearly this code has been like this for quite
some time.

Cc: stable@vger.kernel.org # v5.9
Fixes: 3f649ab728cda8 ("treewide: Remove uninitialized_var() usage")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/control.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -120,7 +120,7 @@ static ssize_t fuse_conn_max_background_
 					      const char __user *buf,
 					      size_t count, loff_t *ppos)
 {
-	unsigned val;
+	unsigned int val = 0;
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
@@ -162,7 +162,7 @@ static ssize_t fuse_conn_congestion_thre
 						    const char __user *buf,
 						    size_t count, loff_t *ppos)
 {
-	unsigned val;
+	unsigned int val = 0;
 	struct fuse_conn *fc;
 	ssize_t ret;
 


