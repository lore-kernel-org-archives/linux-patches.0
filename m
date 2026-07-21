Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109A348C8C4;
	Tue, 21 Jul 2026 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649547; cv=none; b=DpfNzm0Oo03Zlm+DJU22U0/YAAnbJC7T/QJTczm1tLAjYD48y++lxHylRAetk95C43s+PsNMuqXEl4gsK7lazQCkVOX74dxKfWLxwfxKDsnacfXXVxyK2jUuPOgmgt14sh1gS0ERRcF/9mGyNCZquTmIQZKSv8mKfSjbQ62rbqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649547; c=relaxed/simple;
	bh=xImIZdV7V9GO3VnoeF7JjSZzS9BcXCufj+l9cz8y1Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqgSEDddmsRbhMWhwp42L7VMgmSkIu9OIWofxprMlYBRtzcLigY6l4xYQidHrU+eYoxxq2fLxpIBP1ORL2Uq/cjAeYFQlD1y2AF62gdttRsn/NcoYdPUdU1hVHrlF6qJTOVPvQ29Qx4YnxZRv4YJv/xtGx3fM4ZkmvgwpAUSR4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0CqME3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0CqME3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752931F000E9;
	Tue, 21 Jul 2026 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649546;
	bh=0MpQr4WGhc90SE+lJlbQTogGw7D436L23HZAEMVQPXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0CqME3c+Cg42vTw07wH0Ip/0MkT2+hPwKK0x1KxfsdOxm/VKSdNVFCrZQG9npKdS
	 WUYBNdYAZ5+gj/pF7orwlC/gZAj3nUpQeUYplLf4xR3UgA2iMWGa8IWd6yeFwTe7GJ
	 hD9lYtS5WY/JJx1+jtBN56/L8UrNW8saKXIxVVuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0619/2077] NFSD: Handle layout stid in nfsd4_drop_revoked_stid()
Date: Tue, 21 Jul 2026 17:04:52 +0200
Message-ID: <20260721152607.403339869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2696a9fef0291c..523db702464c17 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5056,6 +5056,7 @@ static void nfsd4_drop_revoked_stid(struct nfs4_stid *s)
 {
 	struct nfs4_client *cl = s->sc_client;
 	LIST_HEAD(reaplist);
+	struct nfs4_layout_stateid *ls;
 	struct nfs4_ol_stateid *stp;
 	struct nfs4_delegation *dp;
 	bool unhashed;
@@ -5081,6 +5082,12 @@ static void nfsd4_drop_revoked_stid(struct nfs4_stid *s)
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



