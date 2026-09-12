Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E4547ECFB;
	Sat, 12 Sep 2026 13:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219853; cv=none; b=NHP6E3h3SH8rrDMmS32SB8VBnRh/NzFGiVMzlXcqSOR/FfkZ9wPqp22CIinnmFks4b8LUpmPzw3ybBi3Ff8Z856m4+qARFqSh8ILIXLQy5L3w7aGtM3sd9qQ6jchNcaPlzAgydsULQe/dRPsA0evQsrCp13ZdSxOn/7YS0tN+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219853; c=relaxed/simple;
	bh=I3UrMy643fZh/6pNkhyQ1FfRiFHY0q4rpdGhdgc6F4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+wteljuVD7WEmCVN4nWMlj+Yth+LustLubj32eKct9f+DuTTtnvLC+b/wJNxxyqF0Y+z1AIuZU9YF8PJDPHPQNIClLaVVXjI+IARpLQaAAPPGPAbLgSN63qOVMeF/xXyxeAX60n9pX69OkF1VKjhIppr8wEAwqerTJb1Uy0Gyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWYiYhLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWYiYhLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87A61F000FF;
	Sat, 12 Sep 2026 13:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219852;
	bh=xjvlg2wJHrZ7p+q8FY7IexB93FAZiqnIGjpTlJio1bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWYiYhLx+UeLRfi5YD0Iaum18RSsYNhXkRJXJ73y2dOzrI74um4VVdULAccxv/YLX
	 EByBIiU0UDzegGCWZZhYdWY4ohxJ4KfbpyHD4it1fZE2nLoKosXHHMn4ey6QFARbJC
	 sVU6pRtEvVTu/VS8HDYuyg/zWSmyVPJnlW7pUnEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0057/1424] nfsd: add filehandle match check to nfsd4_delegreturn()
Date: Sat, 12 Sep 2026 08:41:29 +0200
Message-ID: <20260912065608.579809428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 04cce9d79f2b1a114f7128e08bf60a473e10f1ec upstream.

nfsd4_delegreturn() is the only stateful NFSv4 operation that does
not call nfs4_check_fh() to verify the delegation's file matches
cstate->current_fh. A client can DELEGRETURN with a mismatched
filehandle, destroying the correct delegation but waking the wrong
inode's waiters.

Add the missing nfs4_check_fh() call after the generation check.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-6-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7184,6 +7184,10 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if (status)
 		goto put_stateid;
 
+	status = nfs4_check_fh(&cstate->current_fh, &dp->dl_stid);
+	if (status)
+		goto put_stateid;
+
 	trace_nfsd_deleg_return(stateid);
 	wake_up_var(d_inode(cstate->current_fh.fh_dentry));
 	destroy_delegation(dp);


