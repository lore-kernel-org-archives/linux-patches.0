Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700A31E89C;
	Tue, 27 May 2025 17:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366462; cv=none; b=fr9G0qAnIDog4GcAHYBiszLvUkGiqzW7miNNU2zCUxWl/l1o5rnIP/HCZ6z4ELlJDTc9ErBMcpOkEHKcxct2qB3OBiAwsEVPwhIRbcnv1YmxKHf37/ZIYX2uy3GQgDDZGVKYsO8/5faQ7QsYY/6O6xjbRq4MTuRcem25U+UtZfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366462; c=relaxed/simple;
	bh=z33e4QPYXkPq99MvNTxlxqNuFOEDq7/RI6JCBjP6EPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgAa2WoZ9iA1YQjTacMZrlheo28kmmVB0Q/an2nJyG11LJN7oRfERvqgmHVS6UPJKM57LidOHia7L8pVBD8p5Qlnfd/vYo0YdAqCPd6Q7IxRD2q3eDIBPro+Y6f6VbWkM1wBSR5F9apjE3Dq3OtWSii2F34XTMw40NUX51KMh8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ys1O/zLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ys1O/zLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC408C4CEE9;
	Tue, 27 May 2025 17:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366462;
	bh=z33e4QPYXkPq99MvNTxlxqNuFOEDq7/RI6JCBjP6EPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ys1O/zLbcX2lM+lqacJaE6iBMl5ThZHKbqdRfm+U3dbilKppCbL2VoxZL7lxKX4uj
	 bYoGQ4BwxCkJ9I+sKtG6HT+c7Uk9qPVxxZaDWpoB5DQPJMfI+wCDJnJEMO1hUxIJPJ
	 5Q/VSi3EwnTzRzJf1fFI0rvmvvZZnDMrGDGGMJm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 075/783] NFSv4: Treat ENETUNREACH errors as fatal for state recovery
Date: Tue, 27 May 2025 18:17:52 +0200
Message-ID: <20250527162516.188943925@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 0af5fb5ed3d2fd9e110c6112271f022b744a849a ]

If a containerised process is killed and causes an ENETUNREACH or
ENETDOWN error to be propagated to the state manager, then mark the
nfs_client as being dead so that we don't loop in functions that are
expecting recovery to succeed.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 542cdf71229fe..04c726cc2900b 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2739,7 +2739,15 @@ static void nfs4_state_manager(struct nfs_client *clp)
 	pr_warn_ratelimited("NFS: state manager%s%s failed on NFSv4 server %s"
 			" with error %d\n", section_sep, section,
 			clp->cl_hostname, -status);
-	ssleep(1);
+	switch (status) {
+	case -ENETDOWN:
+	case -ENETUNREACH:
+		nfs_mark_client_ready(clp, -EIO);
+		break;
+	default:
+		ssleep(1);
+		break;
+	}
 out_drain:
 	memalloc_nofs_restore(memflags);
 	nfs4_end_drain_session(clp);
-- 
2.39.5



