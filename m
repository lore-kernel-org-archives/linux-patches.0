Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C74E594817;
	Wed,  9 Sep 2026 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964845; cv=none; b=H+TsdzQem5mon3csWhqTsb3PiVA7CtXsVSdx/P/id4MYZ0drfnfSDVXWJTvp/fbeSNdDOPWJkB0U4RgN0whyEuMi86CT0tLbA++UYclGVD7WQTor/BAL8YsVH3w32muq08feGWKjiRFs88qP2i4E7VT5hT0MKPiWx3FDGkTi9ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964845; c=relaxed/simple;
	bh=iZixJ+iDkKu8Jh7pZYPb+HR1I5czHOAxcYIP5kElB3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCrEe5LkLz4NJJr6ISe1yvkLqa05FzS5x+1EHknwapfJH9mJF1IHXekv59S4+VjRx8lLjaz8JnmMh4AUg8DOFU689L9TK5XNBCC8wzFJztw9xjvr5i/O2I0LDFZuY2zDy+i3mBG8P19EVxNBdhu5NlE0i8w7agzXDpRvgPXp/Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGGw7y3h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGGw7y3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B7A1F00A3A;
	Wed,  9 Sep 2026 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964844;
	bh=Mp0KCxmaxrUpoKpmshTapXLYYM3jMJ+ycP+3QG3gl5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGGw7y3hEkG1AD+p3XxSunZGbtn+85UKntS1dKUvzr9DcRRmQ0PUqgcmNHgNdzRBn
	 QL1liNwg/t9i22uu9vNwsU2v/P1HBqB0iyEBdbbO4yhqQc+De9tb47c1RmDons4pxJ
	 yYDiCUd8AWJbCe9gO23gP5IL814GfauwlVIbo5mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 514/583] fuse: fix missing barrier when checking io-uring readiness
Date: Wed,  9 Sep 2026 15:43:19 +0200
Message-ID: <20260909134255.542040783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit edb310bc27f0ad83e7fd558a3caf1a94ca511654 upstream.

fuse_block_alloc() reads fch->initialized and then fch->io_uring.
fch->io_uring is set before fch->initialized, ordered by the smp_wmb()
in fuse_chan_set_intialized(), but fuse_block_alloc() has no matching
read barrier between the two loads.

This may lead a CPU to observe fch->initialized=1 but fch->io_uring=0,
and skip the check that blocks request allocation until the io-uring
queues are ready. This can reintroduce the lock-order inversion deadlock
that commit 3393ff964e0f prevents.

Add an smp_rmb() barrier to pair with the smp_wmb() in
fuse_chan_set_initialized() to prevent this.

Fixes: 3393ff964e0f ("fuse: block request allocation until io-uring init is complete")
Cc: stable@vger.kernel.org
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ renamed `fch`/`struct fuse_chan` to `fc`/`struct fuse_conn` and `fuse_chan_set_initialized()` to `fuse_set_initialized()` in the comment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -172,7 +172,13 @@ void fuse_set_initialized(struct fuse_co
 
 static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
 {
-	return !fc->initialized || (for_background && fc->blocked) ||
+	if (!fc->initialized)
+		return true;
+
+	/* Pairs with smp_wmb() in fuse_set_initialized() */
+	smp_rmb();
+
+	return (for_background && fc->blocked) ||
 	       (fc->io_uring && fc->connected && !fuse_uring_ready(fc));
 }
 
@@ -212,8 +218,6 @@ static struct fuse_req *fuse_get_req(str
 				(TASK_KILLABLE | TASK_FREEZABLE)))
 			goto out;
 	}
-	/* Matches smp_wmb() in fuse_set_initialized() */
-	smp_rmb();
 
 	err = -ENOTCONN;
 	if (!fc->connected)


