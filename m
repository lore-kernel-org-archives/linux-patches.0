Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DE613D528;
	Tue, 18 Jun 2024 13:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716631; cv=none; b=qRS79MNs8TPEnJJnhMllPUupfsiMrVe+voZOUSz9iY2kmHGlA889VkTDRBMuTka/qWHPqRK9CA2iqkeKryNPpaCkemrvtK4GB8zoE2XehrRyugXgB0tsaWbEjw/TCdALqnBXrOe/JviVGkpxRXA70qhxnXWNOLPT2EpKPspUZ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716631; c=relaxed/simple;
	bh=sC95tCH95LMNujqj/h7jSj6scoqRAjcU7ZeNYKzkIt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wf6KDoBV6QNKlyCgON/0PD5e+QDHlvxj2kIHFY2HeRwjvvBIlAaOYwls9wJWxHQ1ItW6IMJSWJxZH/c7juM9rU1woLishtM0sagxNdOusY+KQZ6i+TNGnuInOLAhxDy9q6FrAk26zp/htMpWlQF/Itra4xq5CDhH66XrE/dBb6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDWs95nb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDWs95nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012F1C3277B;
	Tue, 18 Jun 2024 13:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716631;
	bh=sC95tCH95LMNujqj/h7jSj6scoqRAjcU7ZeNYKzkIt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDWs95nbFwFlTXXdHR2UOSY6CVE+UOx+EUM+BzlWOmxAmaxTfiQGb4H86AdWZq6am
	 o98DSZNiSE+46x6zSy1p9dhwM1pNDggN2ZLSLBd8jXrutQAtRtkh0r7ZsNhJ5JdW6n
	 AfiGx1Foy07nd1ZX+jI9E4hhLbMae78+KiO2MJy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Brown <neilb@suse.de>,
	Yongcheng Yang <yoyang@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 710/770] nfsd: return error if nfs4_setacl fails
Date: Tue, 18 Jun 2024 14:39:23 +0200
Message-ID: <20240618123434.678293982@linuxfoundation.org>
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

[ Upstream commit 01d53a88c08951f88f2a42f1f1e6568928e0590e ]

With the addition of POSIX ACLs to struct nfsd_attrs, we no longer
return an error if setting the ACL fails. Ensure we return the na_aclerr
error on SETATTR if there is one.

Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: Neil Brown <neilb@suse.de>
Reported-by: Yongcheng Yang <yoyang@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 32fccca7de185..86ab9b8ac2daf 100644
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



