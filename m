Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF283C061E;
	Fri, 24 Apr 2026 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038125; cv=none; b=gHg0zznSROwP4VaSb6XJ8GD3K+asQNPkjKbf4XXYlOmd8SaFGMJGwRW/yvlD53ue72Z+ssG2d7LfMx2doIVtw3WDDtUHLEHmfZKd0W1UAF4COdonPopJdDIvchAgWxFvTcP1fXGK+ZwiQ+47HYCElzsdBdDILGVVpTTDeRhwntU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038125; c=relaxed/simple;
	bh=e9drIznvs29HiEvjickAFWUVi1Mg4EUIBMeDRmBp+v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=szduwWH+zq4AoJdTuPrHRih5lb60PqIPMnR9d4cgj2pOJV+dv0lVrZNjj8tF7B3C6rfozXG3wLwIpgbvOOP/t5UTIeyZpjp5b3YSI0AiCXWTZDUoULrIGvGb08pszbmRQSd4V1pWF/THTt7nezafJSEHNBPS4CYFwkHxKn0wQ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQoSESAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQoSESAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB61BC19425;
	Fri, 24 Apr 2026 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038125;
	bh=e9drIznvs29HiEvjickAFWUVi1Mg4EUIBMeDRmBp+v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQoSESAs0st2Y8P8rcyoFJa58CiEN7FIZHt6d5xotP+He1BByphrNbW4f/GdDwb/P
	 Oux5Ue5sh3Y1cn4OQCX7iZ8r2rpf0oR8MIfR2A1BozQXUL5/2QMl4DmG/YnBD5T7ua
	 04sE224Lr16TQhaCnxsC5cb0t1dTYZwSoX0wAK3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 34/55] fuse: quiet down complaints in fuse_conn_limit_write
Date: Fri, 24 Apr 2026 15:31:13 +0200
Message-ID: <20260424132437.067687483@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -121,7 +121,7 @@ static ssize_t fuse_conn_max_background_
 					      const char __user *buf,
 					      size_t count, loff_t *ppos)
 {
-	unsigned val;
+	unsigned int val = 0;
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
@@ -163,7 +163,7 @@ static ssize_t fuse_conn_congestion_thre
 						    const char __user *buf,
 						    size_t count, loff_t *ppos)
 {
-	unsigned val;
+	unsigned int val = 0;
 	struct fuse_conn *fc;
 	ssize_t ret;
 


