Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2837613D29A;
	Tue, 18 Jun 2024 13:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716535; cv=none; b=qVZ+dCgEVUaaRCxpGYg4oOZ92qMIIrLFVjHUhy7oRZut3fW7pqhp9X6DTvxdqi87y1I30xdXFH7OBFPKkYmOxG5g6hXnIrvnUUoIxnZbkp9Ges419MDpGDFcIMiUOrtBBwZgzhz4aLCRwdGCdeb7k4KufHMbmwGumrCGw1xF4S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716535; c=relaxed/simple;
	bh=jYfcGOEkYxnY9LtMNzabtzn9DDXycUPNp4HLTQlBWjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyUNXf2PDp+B4vt2aAVC0D7HK9Qwh5vfvk4PjheVDmzDNljt6g8vLbt7KEFam13/am//kXseFrLvGs9gK008S+u0Nu8/QaPKGgFAuyUI7ff7pIdrAKHRNA8ElamubHlQz8NShXrS2oL9gq0ur9dsHZAXxuXjRQld0qYX+z9QRNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLpsmKyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLpsmKyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0A3C3277B;
	Tue, 18 Jun 2024 13:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716534;
	bh=jYfcGOEkYxnY9LtMNzabtzn9DDXycUPNp4HLTQlBWjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLpsmKyVjhIruG9Yhj4FI0yIfAUd+kmXBDDLTuGOECELJIH0iM4Ks/o4V89KWxG0V
	 00GNS5/RFaDZ9Ps9zHiuczD+Me2AXgPfTK2tG2CXd1uWeCO5y07q3+hLRe7nmUrexJ
	 B4EfVptFX3+Ifgs7g6luGIJ/fXT3ojaWD+PYuryc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongcheng Yang <yoyang@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 677/770] nfsd: put the export reference in nfsd4_verify_deleg_dentry
Date: Tue, 18 Jun 2024 14:38:50 +0200
Message-ID: <20240618123433.410892326@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 50256e4793a5e5ab77703c82a47344ad2e774a59 ]

nfsd_lookup_dentry returns an export reference in addition to the dentry
ref. Ensure that we put it too.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2138866
Fixes: 876c553cb410 ("NFSD: verify the opened dentry after setting a delegation")
Reported-by: Yongcheng Yang <yoyang@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 948ef17178158..10915c72c7815 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5397,6 +5397,7 @@ nfsd4_verify_deleg_dentry(struct nfsd4_open *open, struct nfs4_file *fp,
 	if (err)
 		return -EAGAIN;
 
+	exp_put(exp);
 	dput(child);
 	if (child != file_dentry(fp->fi_deleg_file->nf_file))
 		return -EAGAIN;
-- 
2.43.0



