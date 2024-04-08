Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6516B7CF0F;
	Mon,  8 Apr 2024 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584609; cv=none; b=a0CSjaRXdQqfhVvBKQfIL4H0088sVfc/zvTyXwW2UCLHZDvhNnrOg94xRCWCi1a9xXdcFprVlC9Z2SGVh2WXaGQLNRjYhrDsyb8JZpXIM0DOYzzNZ158vhVHxbMu+KTUAl/drO4lldo31DkpUFkoIlBSRtvbhsTMUznxVIX2JuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584609; c=relaxed/simple;
	bh=g7rNNnVkxsq5neRf2vBWVfch2RxLhjNDEmV6iMiQ6bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NExRha7Ddw14Tz92AWg9pRmJiiP7ZmbAUa1GwFVCJYrWpsc+IAzFi2n/eEhxLJdmIEq2+tBhGunC3C5DebA/QTP3C/esBCOiLlKk6bjtCkZEeOkBjME9+YgZKaPUWk3e4AJ+/601nb+W/8EaKPPk457DQKEr+OYszflqH05urX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbqNUvcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbqNUvcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E39C43390;
	Mon,  8 Apr 2024 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584609;
	bh=g7rNNnVkxsq5neRf2vBWVfch2RxLhjNDEmV6iMiQ6bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbqNUvcPh2WlOPdzZuEts9kPhomDWkE0HfdzKxI7DCJ/Eu1vKxbsyHMaj0bVwdxTo
	 Nyycd57ET8/J8PFnB8D86qSJE5+uhZiLNz2nW8vp/cUS9NoO69pSVAz+SmkChoXpEm
	 KDlevz2phAM8+w2AzbEPOJ8qzjiJo8QtFoPFVRnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Brown <neilb@suse.de>,
	Yongcheng Yang <yoyang@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 497/690] nfsd: return error if nfs4_setacl fails
Date: Mon,  8 Apr 2024 14:56:03 +0200
Message-ID: <20240408125417.652620489@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 01d53a88c08951f88f2a42f1f1e6568928e0590e ]

With the addition of POSIX ACLs to struct nfsd_attrs, we no longer
return an error if setting the ACL fails. Ensure we return the na_aclerr
error on SETATTR if there is one.

Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: Neil Brown <neilb@suse.de>
Reported-by: Yongcheng Yang <yoyang@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 92d4eb1032ff9..eeff0ba0be558 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1135,6 +1135,8 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 				0, (time64_t)0);
 	if (!status)
 		status = nfserrno(attrs.na_labelerr);
+	if (!status)
+		status = nfserrno(attrs.na_aclerr);
 out:
 	nfsd_attrs_free(&attrs);
 	fh_drop_write(&cstate->current_fh);
-- 
2.43.0



