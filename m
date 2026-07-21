Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE9146A60E;
	Tue, 21 Jul 2026 19:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662044; cv=none; b=tnLGc/nBz5G97HA6MXLSL9FiV6mIOmPyiF7TlHaRHob9GCqGDVsHAw3mXTwurR2HBbikQfH0YgDS9ZkToUluftUTyH6eRo07fZHfQI+4PMyelUtF7Jpy5m4Ob4vUDawcK8RH5SACDvaebfswB83k4T50IhQXKTKavLe3T3yGFDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662044; c=relaxed/simple;
	bh=+YW6JSTSsHwcOZ86VXwTjFrJ/FbtgB9exGfaeF6vFb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOuga3ygY7RYJgItI7t6v7I2ziwpkyHqf6HpURnuoV/QWqAq3pZ0b738ghuwALAKVlinvzBpccUXryCjJ6mDGRHws7Q+4k18vWigCjGpVl6DJ6vzvSvnRIYkP1OUTQPv7qM0G9dNje1nb6KuGJglja7pIJU4p0irVMVBx6+oGsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVyyJ6Hj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVyyJ6Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6B31F000E9;
	Tue, 21 Jul 2026 19:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662042;
	bh=kv95REy0LSWIRTJ5gLeAgLXuKZDeLEx6A0JtVOWnWUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVyyJ6Hj/CI+aMDlIBp1d37c/2yskm79DU/X3/0pXWiadx3SgMaFoPZyCiHiVZbzF
	 bX0G4PHsLa0HzSzDe+pXqrdwXGhUsegEg+kAV6q3Wz3EGt9v6MlWT7IIS6BH3HdxEp
	 O1CDGe4R9PxE9CceuGhp8VEqmkI0o7e3w0gA8/nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0295/1276] NFSD: Handle layout stid in nfsd4_drop_revoked_stid()
Date: Tue, 21 Jul 2026 17:12:18 +0200
Message-ID: <20260721152452.690987628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 86b9898920a6d02b4149f4fef9efd77b8aa3b9ca ]

nfsd4_drop_revoked_stid() has no SC_TYPE_LAYOUT case, so when a
client sends FREE_STATEID for an admin-revoked layout stid, the
default branch releases cl_lock and returns without unhashing or
releasing the stid.  The stid remains in the IDR and on the
per-client list until the client is destroyed.

Remove the layout stid from the per-client list and call
nfs4_put_stid() to drop the creation reference.  When the
refcount reaches zero, nfsd4_free_layout_stateid() handles the
remaining cleanup: cancelling the fence worker, removing from
the per-file list, and freeing the slab object.

Fixes: 1e33e1414bec ("nfsd: allow layout state to be admin-revoked.")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f93f5bdfbb077e..342de8d2c4aa8f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4858,6 +4858,7 @@ static void nfsd4_drop_revoked_stid(struct nfs4_stid *s)
 {
 	struct nfs4_client *cl = s->sc_client;
 	LIST_HEAD(reaplist);
+	struct nfs4_layout_stateid *ls;
 	struct nfs4_ol_stateid *stp;
 	struct nfs4_delegation *dp;
 	bool unhashed;
@@ -4883,6 +4884,12 @@ static void nfsd4_drop_revoked_stid(struct nfs4_stid *s)
 		spin_unlock(&cl->cl_lock);
 		nfs4_put_stid(s);
 		break;
+	case SC_TYPE_LAYOUT:
+		ls = layoutstateid(s);
+		list_del_init(&ls->ls_perclnt);
+		spin_unlock(&cl->cl_lock);
+		nfs4_put_stid(s);
+		break;
 	default:
 		spin_unlock(&cl->cl_lock);
 	}
-- 
2.53.0



