Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691A63F1AC7;
	Wed, 20 May 2026 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297242; cv=none; b=hlma4410Oh3mnHOTz+cBjW7wz/CF8pAd4gzXvbgziB5enhd1/ZgrhzHGxW8rPGZ62pxwEM+h1obA5SXdd4e2x/vIckgXzWRq4X15CVP+CJ2VF2BWyT0WrbC8DTWeEUbWU9ywuFeK2M81mATJmh1fcOGO+GggAsbo6f41NotC9ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297242; c=relaxed/simple;
	bh=Oi5buXI8eX+fVTl3A3kuSkyKMrVyTB/hEH19G5ZQlZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEP7Amu+i3HelQTQFxP0AmQcQ0/xeL1fOUtbfDk1mbFq1gWMwMsJ49G8A8SpQJREe1+NJvPOKVExJqm/WHeNK0b9fBOuGIJ8WbL0RgjW2SCsXUAPWIU6GtcAEWWN6KG3Om0yctWcWIfirqpsNnhXW2PMw2SCzRh0hDMpoDFp4aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPAZdvx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPAZdvx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF5F1F000E9;
	Wed, 20 May 2026 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297241;
	bh=rcrGGFrUWnGw1u+LoNBXHoavp3KUbrJxHrQhB0yv5uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPAZdvx6D9deo0vsOgwVnAy2KE8efokofbqqYOeycUHcIdClMv47YB7c416m8CIIx
	 aO9C0mZSgnfVAuv0QL42LW94r+FvXMQP3cVSonFxLY1cA8sFXYeknul6SO9VCDm6yj
	 2BcI3FqHc4zEB4aeZSjYiH30anmpb6MX1sGnAl/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.0 1105/1146] nfsd: fix GET_DIR_DELEGATION when VFS leases are disabled
Date: Wed, 20 May 2026 18:22:35 +0200
Message-ID: <20260520162213.252357435@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit b0bf14546bcefa4ea49f5efcd7db2a99f0cabde9 upstream.

When leases are disabled on the server, running xfstest generic/309 leads
to an error because GET_DIR_DELEGATION returns EINVAL.

nfsd_get_dir_deleg() can fail in several ways: like memory allocation and
unable to get a lease because either leases are disable or it's already
held. Currently only the condition "already held" is translated to
returning directory-delegation-is-unavailable error. However, other failure
conditions are likely temporary and thus should result in the same kind
of error.

Fixes: 8b99f6a8c116 ("nfsd: wire up GET_DIR_DELEGATION handling")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 85e94c30285a..2797da8cc950 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2535,10 +2535,6 @@ nfsd4_get_dir_delegation(struct svc_rqst *rqstp,
 	dd = nfsd_get_dir_deleg(cstate, gdd, nf);
 	nfsd_file_put(nf);
 	if (IS_ERR(dd)) {
-		int err = PTR_ERR(dd);
-
-		if (err != -EAGAIN)
-			return nfserrno(err);
 		gdd->gddrnf_status = GDD4_UNAVAIL;
 		return nfs_ok;
 	}
-- 
2.54.0



