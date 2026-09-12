Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758D541C302;
	Sat, 12 Sep 2026 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226790; cv=none; b=bR94VfR4r+ig7qaFqvX0VbwxpOP9n4G2RTeyKnVCCp9Rfm6qqxveWg8637FOpj6X56/jiVBGmXT5LrOf3/e691DqsRNq7D/0HAPCBfRK+3UujXjl1xTmjF9gyR59BWXrbOLs8YQFls1DzZWTtVe1nvbrxSACzMGiJ3BSHOEQm5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226790; c=relaxed/simple;
	bh=RqoQ4NQY5giKO6fos4kTbVXhupKkIkEQ9xvWfjC1fzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EB2586JT8UA2hTLXnIugyZNpPBVt7ifvkBHK79g8i7Z8oI2vy3ztnX8BtV1afSjsMcDF/RwLjb5g7pB/z4E6C9qBoRWbL40p4NDBiBYzU9gRHnx60lGu4yGc76bzFh2BEpTeHDoJMl3i8FQGYMB/d8g6ONYCfRvgxxkGJhG/5OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5QSo50G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5QSo50G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130251F00898;
	Sat, 12 Sep 2026 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226789;
	bh=Hjixfi4DL1Hm4WDa0Tfz93M1xmlDwB5BcB+PjnEae9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5QSo50GszRMxq5hjKEAv4FezxAWTkJ2IUqPDsaz2ElOCXnwM0wxQcKPxa0gU1uS9
	 MvBbvRsweOKhqh6RsHXoyG0jDmnh6Fd06VQyWX1wldWZ/Hw92XEdN7+iWlkwZgXoIh
	 SjnUrBv7BHMSxmb/FWI7PQA3vvYQ7v6KcLS+5eo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0048/1191] nfsd: add filehandle match check to nfsd4_delegreturn()
Date: Sat, 12 Sep 2026 08:46:16 +0200
Message-ID: <20260912065549.220656568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7118,6 +7118,10 @@ nfsd4_delegreturn(struct svc_rqst *rqstp
 	if (status)
 		goto put_stateid;
 
+	status = nfs4_check_fh(&cstate->current_fh, &dp->dl_stid);
+	if (status)
+		goto put_stateid;
+
 	trace_nfsd_deleg_return(stateid);
 	wake_up_var(d_inode(cstate->current_fh.fh_dentry));
 	destroy_delegation(dp);


