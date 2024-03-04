Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF1778B4C;
	Mon,  4 Mar 2024 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589013; cv=none; b=aSIS2E/RLsmHfwiX4m2uwf7DPZYcf+0s7w46/ZZWzwRw6gLdJALdqs+YdYHHbzt6U8+nEciqh9tP5CybgmBADzF5ixsDts+sn1Ng6uS1Uv7j3CbXJlrBuzKufDsPAcJprcrIBPIskN0ZbD3MyGynuJerMAwfm9PCGVqeQkIszmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589013; c=relaxed/simple;
	bh=cXDTrQVxtIG2nEuqIRxfgPRgoI5ZrQm86sTegZZ7q70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMpoLBBLq11okgBNbv8+GxBoBZzNAicWD7ico/foEakP+8geVlmfgZI1nhsHHikefP3UJ4CXx/iPS7VDNgW+MzKdLxodlNrY8d2JYP2lg9zUkekR356XB2Q9igoJnE8H2DFabmQ4yWcp/fRhWYyiCSwEkwFuqTHNR40yaytMUwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSs5xLp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSs5xLp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63D1C43394;
	Mon,  4 Mar 2024 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589013;
	bh=cXDTrQVxtIG2nEuqIRxfgPRgoI5ZrQm86sTegZZ7q70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSs5xLp11A1KwvhRT6t7lux8obiOllBCyGXTjjDhtmGhaJhk8WjfDmPhqAAUYG/hG
	 bjcYN88Yg7kwYTAH1qd5HsYKcqgCcUYdPQtKqcI1jnJY9l6Z2rAup0WOuKuho+1yPy
	 xa7YnqP6c/kZiQ1YZaO1EiKhWiBxjEDTX+hO213M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 167/215] lockd: ensure we use the correct file descriptor when unlocking
Date: Mon,  4 Mar 2024 21:23:50 +0000
Message-ID: <20240304211602.256519415@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 69efce009f7df888e1fede3cb2913690eb829f52 ]

Shared locks are set on O_RDONLY descriptors and exclusive locks are set
on O_WRONLY ones. nlmsvc_unlock however calls vfs_lock_file twice, once
for each descriptor, but it doesn't reset fl_file. Ensure that it does.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svclock.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -659,11 +659,13 @@ nlmsvc_unlock(struct net *net, struct nl
 	nlmsvc_cancel_blocked(net, file, lock);
 
 	lock->fl.fl_type = F_UNLCK;
-	if (file->f_file[O_RDONLY])
-		error = vfs_lock_file(file->f_file[O_RDONLY], F_SETLK,
+	lock->fl.fl_file = file->f_file[O_RDONLY];
+	if (lock->fl.fl_file)
+		error = vfs_lock_file(lock->fl.fl_file, F_SETLK,
 					&lock->fl, NULL);
-	if (file->f_file[O_WRONLY])
-		error = vfs_lock_file(file->f_file[O_WRONLY], F_SETLK,
+	lock->fl.fl_file = file->f_file[O_WRONLY];
+	if (lock->fl.fl_file)
+		error |= vfs_lock_file(lock->fl.fl_file, F_SETLK,
 					&lock->fl, NULL);
 
 	return (error < 0)? nlm_lck_denied_nolocks : nlm_granted;


