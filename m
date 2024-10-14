Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73091AAC4;
	Mon, 14 Oct 2024 14:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916169; cv=none; b=H6j499aRP4hVD0l7Dv5rVquFg+7WrAHTZhZDmwH+fsEy6jfgp+tnq3v2a6BZo1TfK8VD6nwfUigNNIlHRyu+bT65rWMvtBxx71z71NFJdj2damQ3/O6NmVr8eIvpHfgn1NE2vL2PqnA7s2YFxxMF+58xcnSxzXHD46HsO4PrDpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916169; c=relaxed/simple;
	bh=W0B3bzn53v4G68kzTZ6dtELpe64PQePK/dBf1efZHqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4Osf5b5gmWL6Sy8ALE5nACJrOCuCgMRmSIXB3xnxa7ED3ugm3TZacARHt+gaWgBI04E85WUvz796TR4x0tXCcU/B69GiZrajZ90UktGgABpaWbxR5dWf7xKSHtLm9w2cnGFYs6AYR1KM6jGw7/qoAvC3MterhFdbahxIhuOLb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1WL0g/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1WL0g/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0C8C4CEC3;
	Mon, 14 Oct 2024 14:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916168;
	bh=W0B3bzn53v4G68kzTZ6dtELpe64PQePK/dBf1efZHqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1WL0g/a9N0DU9P0UsYIW/qAalAL3/cU7IwbMsrJ1XGOPauu6AEjUAwgn8jejpSfY
	 1ydKL5I18d5Po7YJ1eOYyOJLZqrw4kcdvb7gjoILrIgsb5BMjWLfJTIpN+U5+lWbKV
	 a2ZDm4cHjsRT7nsTN6fcqTBmOu93I457RwBCfI3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 105/214] nfsd: fix possible badness in FREE_STATEID
Date: Mon, 14 Oct 2024 16:19:28 +0200
Message-ID: <20241014141049.091831886@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit c88c150a467fcb670a1608e2272beeee3e86df6e ]

When multiple FREE_STATEIDs are sent for the same delegation stateid,
it can lead to a possible either use-after-free or counter refcount
underflow errors.

In nfsd4_free_stateid() under the client lock we find a delegation
stateid, however the code drops the lock before calling nfs4_put_stid(),
that allows another FREE_STATE to find the stateid again. The first one
will proceed to then free the stateid which leads to either
use-after-free or decrementing already zeroed counter.

Fixes: 3f29cc82a84c ("nfsd: split sc_status out of sc_type")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3837f4e417247..64cf5d7b7a4e2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7158,6 +7158,7 @@ nfsd4_free_stateid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	switch (s->sc_type) {
 	case SC_TYPE_DELEG:
 		if (s->sc_status & SC_STATUS_REVOKED) {
+			s->sc_status |= SC_STATUS_CLOSED;
 			spin_unlock(&s->sc_lock);
 			dp = delegstateid(s);
 			list_del_init(&dp->dl_recall_lru);
-- 
2.43.0



