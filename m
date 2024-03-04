Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C917BAE2;
	Mon,  4 Mar 2024 21:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589010; cv=none; b=GtgY8lky0zUDBQ2GbSEFkcPAhXJDJ0hyqZmV44e2U4R6XwMAZdIfNjvoiJ3aEK5z9qdPqJigpCRy4C3wNY2GID2MhDGKi7smPPXrCplrr6kP29FJMZe3NuoyOgfx6CEHsCDVHPHbYmiiX2WOrxki5NMzE8074bV6AnKvaw9m5IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589010; c=relaxed/simple;
	bh=5EqthNYa7OyHvmQbkmCkxPHLa6H+cB+BkILrxR8uIYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhRAu85UpWiJyp+5SzNlFNuDe9pHN9dY1ljDkbM62MFbbv80572S2kla3/60OoM2OJYxc+MGZHJ+lRZcFyfHFJFLVn7BXEnS4Mquv4H04kYOAUagexnX3kHwie0J+R8uqgwlsoRNjVdAJ+V730XBuwtZl74TXUifm9cTuqZmMsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILXaiD1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILXaiD1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEB8C433F1;
	Mon,  4 Mar 2024 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589010;
	bh=5EqthNYa7OyHvmQbkmCkxPHLa6H+cB+BkILrxR8uIYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILXaiD1cKJWJBV1kqIEqpurMdjy6KL2kYDwOVAmtTrXV5eq2FsR/cVOIGtx/XxHEG
	 gNyXX8CTl8GD9YIOA0hd1au8Ta6Ibz62NTAdAVm1N8e1db/1YW9GXd/afvQyRGuN3j
	 sfVi5oPca9SDAX2T6KuAaFopyiotNLhWYC2lhFPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 166/215] lockd: set missing fl_flags field when retrieving args
Date: Mon,  4 Mar 2024 21:23:49 +0000
Message-ID: <20240304211602.232528722@linuxfoundation.org>
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

[ Upstream commit 75c7940d2a86d3f1b60a0a265478cb8fc887b970 ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svc4proc.c |    1 +
 fs/lockd/svcproc.c  |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -52,6 +52,7 @@ nlm4svc_retrieve_args(struct svc_rqst *r
 		*filp = file;
 
 		/* Set up the missing parts of the file_lock structure */
+		lock->fl.fl_flags = FL_POSIX;
 		lock->fl.fl_file  = file->f_file[mode];
 		lock->fl.fl_pid = current->tgid;
 		lock->fl.fl_start = (loff_t)lock->lock_start;
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -77,6 +77,7 @@ nlmsvc_retrieve_args(struct svc_rqst *rq
 
 		/* Set up the missing parts of the file_lock structure */
 		mode = lock_to_openmode(&lock->fl);
+		lock->fl.fl_flags = FL_POSIX;
 		lock->fl.fl_file  = file->f_file[mode];
 		lock->fl.fl_pid = current->tgid;
 		lock->fl.fl_lmops = &nlmsvc_lock_operations;


