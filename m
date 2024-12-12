Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D202358BF;
	Thu, 12 Dec 2024 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022530; cv=none; b=XRnaJIV3VI5p8EjXg5smSgZQ5Ebgc5vmer+BDoAkdmAvWNqJzhg6wBtCzaDMvH/SF10TQidxHfWORH/K2Vv8gnAr0n/rFgF76xBsJrGzdcsF/BY5lhXy/b316mmxNl9irrEsWEdqRTxf38K7Ona+dWTOh8UlRsBeo+92jzXfVKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022530; c=relaxed/simple;
	bh=8GwtE/lOkUosBLm57g0ZHBlMKM+CUtijXpAFVEdZXQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RG9d8tSekU5difRj44+h72E+jB5hMvsLRL5PvXSeiOGRL3zdrX3q/FFggR32p9TKTm8AQIkE+PD/alEUJjjLdea8DIvCSjLcqHwZtvC9NMAFlgE7agHlYHhTAUtN+WPGyUHvXDx+uCIKAFvXdN9LSvvvz3GNN8yMEfpxASZAsBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyrqOgMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyrqOgMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D2FC4CECE;
	Thu, 12 Dec 2024 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022530;
	bh=8GwtE/lOkUosBLm57g0ZHBlMKM+CUtijXpAFVEdZXQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyrqOgMdeGLAeBp1dQ3szUkMFE5aBLfs+sOwSVHjPDrcJg0Dx5a9EquAWNBPG8125
	 rX1CwCU9QU2u0Q2Zuwo+jrq+lWxvbS4PF7wjD471y1Pt/INcpzLOprkPXKh0IELqYL
	 rtKh8U1x2mPnim0EdNuG9suHdnhiblfTl9SFoAgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/565] NFSD: Fix nfsd4_shutdown_copy()
Date: Thu, 12 Dec 2024 15:57:42 +0100
Message-ID: <20241212144322.021439001@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 0b698e25826fa..c48c1a3be5d2f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1256,7 +1256,7 @@ static void nfsd4_stop_copy(struct nfsd4_copy *copy)
 	nfs4_put_copy(copy);
 }
 
-static struct nfsd4_copy *nfsd4_get_copy(struct nfs4_client *clp)
+static struct nfsd4_copy *nfsd4_unhash_copy(struct nfs4_client *clp)
 {
 	struct nfsd4_copy *copy = NULL;
 
@@ -1265,6 +1265,9 @@ static struct nfsd4_copy *nfsd4_get_copy(struct nfs4_client *clp)
 		copy = list_first_entry(&clp->async_copies, struct nfsd4_copy,
 					copies);
 		refcount_inc(&copy->refcount);
+		copy->cp_clp = NULL;
+		if (!list_empty(&copy->copies))
+			list_del_init(&copy->copies);
 	}
 	spin_unlock(&clp->async_lock);
 	return copy;
@@ -1274,7 +1277,7 @@ void nfsd4_shutdown_copy(struct nfs4_client *clp)
 {
 	struct nfsd4_copy *copy;
 
-	while ((copy = nfsd4_get_copy(clp)) != NULL)
+	while ((copy = nfsd4_unhash_copy(clp)) != NULL)
 		nfsd4_stop_copy(copy);
 }
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
-- 
2.43.0



