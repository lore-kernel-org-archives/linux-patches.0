Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06431F7540;
	Tue,  3 Dec 2024 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239326; cv=none; b=Am2fkqYY365OSRJchMXkXMfvL+KyzTtAnT2A0zgxUfCDmCrbQ1ykUQBg4joEAkXmR1Vxii2Z+xNlcflVMvJgsvCxSyB/7sFE56Blj+9SRoMrW4JPlABQGjBP/mFyccPh+C82fA2VTWBRXHi8Zt3ai1wlkmm6gxbOUhCrPUHH0YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239326; c=relaxed/simple;
	bh=IxToqpmsgAP1wYCUOg9UlBkFjt0nYOVEezQ8inaxZHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBlQ0mXU0RzBdkHZIyBH+wNpu1zMp4ec9SEaTkIuovhr0+AVG7PQXe+zWdwmV1ULCMu9IXaeReYqrajAAJyP0nooiVL2w7b6NqpVAoYp8DxDpwO6ZnrapCzI+B9kjBaLVT9AKQmU0ZcskhGNmihISQ6jfks3xJ+/KXnFKK4tTec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmkHp4Vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmkHp4Vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3085C4CECF;
	Tue,  3 Dec 2024 15:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239326;
	bh=IxToqpmsgAP1wYCUOg9UlBkFjt0nYOVEezQ8inaxZHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmkHp4VpQce10uXuz8QxvOZzPVXAuTJm1p6C/ePEqHCg7T9JEyK39TDYLAMaTQ7fl
	 djVVVjk75RGLoS2c6natmYHjxTLyD0S4Xijvssw86adO4FNdVLEfu/cEZWyK8cbHdq
	 fXk9oadve7f1O3VCoXtBEc9doBVWyQFG6VQhXfww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 544/817] NFSD: Fix nfsd4_shutdown_copy()
Date: Tue,  3 Dec 2024 15:41:56 +0100
Message-ID: <20241203144017.138180695@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 62a8642ba00aa8ceb0a02ade942f5ec52e877c95 ]

nfsd4_shutdown_copy() is just this:

	while ((copy = nfsd4_get_copy(clp)) != NULL)
		nfsd4_stop_copy(copy);

nfsd4_get_copy() bumps @copy's reference count, preventing
nfsd4_stop_copy() from releasing @copy.

A while loop like this usually works by removing the first element
of the list, but neither nfsd4_get_copy() nor nfsd4_stop_copy()
alters the async_copies list.

Best I can tell, then, is that nfsd4_shutdown_copy() continues to
loop until other threads manage to remove all the items from this
list. The spinning loop blocks shutdown until these items are gone.

Possibly the reason we haven't seen this issue in the field is
because client_has_state() prevents __destroy_client() from calling
nfsd4_shutdown_copy() if there are any items on this list. In a
subsequent patch I plan to remove that restriction.

Fixes: e0639dc5805a ("NFSD introduce async copy feature")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 8b78d493e301f..0d6505ac1a33e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1291,7 +1291,7 @@ static void nfsd4_stop_copy(struct nfsd4_copy *copy)
 	nfs4_put_copy(copy);
 }
 
-static struct nfsd4_copy *nfsd4_get_copy(struct nfs4_client *clp)
+static struct nfsd4_copy *nfsd4_unhash_copy(struct nfs4_client *clp)
 {
 	struct nfsd4_copy *copy = NULL;
 
@@ -1300,6 +1300,9 @@ static struct nfsd4_copy *nfsd4_get_copy(struct nfs4_client *clp)
 		copy = list_first_entry(&clp->async_copies, struct nfsd4_copy,
 					copies);
 		refcount_inc(&copy->refcount);
+		copy->cp_clp = NULL;
+		if (!list_empty(&copy->copies))
+			list_del_init(&copy->copies);
 	}
 	spin_unlock(&clp->async_lock);
 	return copy;
@@ -1309,7 +1312,7 @@ void nfsd4_shutdown_copy(struct nfs4_client *clp)
 {
 	struct nfsd4_copy *copy;
 
-	while ((copy = nfsd4_get_copy(clp)) != NULL)
+	while ((copy = nfsd4_unhash_copy(clp)) != NULL)
 		nfsd4_stop_copy(copy);
 }
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
-- 
2.43.0



