Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A608279DC9;
	Sat, 30 May 2026 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165618; cv=none; b=F783/pRktH64P3xBa/iSBhn2yWT+aeqgLUBx78K6No/dXcSNxIwZeUHhNxnB0WPXf4omz20OAWV6BD/H+rz1wk8KO9ah+l0gGvFTcZea/yYbOzwkUmXQhHnWkyTn6FEeWtXEEknPnvIIe6T6ck3XdWTalZ8VDMshAAeKof5907E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165618; c=relaxed/simple;
	bh=ng7HICWLceGnlGispZm2FILpRq2DmIrTjr4E/XIr6CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qU/pRLWYJEwJ+RcEVBAAn7/WaT+718OLfo08+iIIupAuMGBtDEf9rUaf2FjrygtD05yh17d3pKmZzHCPRMRVHrYTHBfG/MNpJQtwGZJqXC8jery2Uy2yRWcmQ20RZVXTNaI3RBtxz2GVpWCc/2h9MT5sPsyJsJf/vh8kLD8tKCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqmsTAiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqmsTAiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFD51F00893;
	Sat, 30 May 2026 18:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165616;
	bh=R9ReAKiSwa5u0f/bmHlSsH3H1Sao+BpqV9tVtYs+6eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqmsTAiADMUnGclZcyKngQeUKvTCYlK93ZK3NRBnxqBMOylnS7y4on/YoBIgwxVpr
	 A7+C9UdhMGBYu5xRA7YtIAQWuJa6oKSMWilP++TEUSUHiscS0LUqosEfOY32KpmB3V
	 JVAZYZ4FdUnQFaGrGHB3q7H4Vezx/yG0qknzTC58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 130/589] fuse: quiet down complaints in fuse_conn_limit_write
Date: Sat, 30 May 2026 18:00:11 +0200
Message-ID: <20260530160228.191926655@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 	struct fuse_mount *fm;
 	ssize_t ret;


