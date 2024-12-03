Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2649F1F755B;
	Tue,  3 Dec 2024 16:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241830; cv=none; b=gtDCJ/RpS+8/jFLUomueqISluuDMiIRLqOk/h2CPX4SRmn0hHfg6fmkFL6mBpZdgavz/6G7xChkp10NYVa4QodZoNidJ1XpxQJdt3Vo937f0+7PKZ9m/R5RZ0CpYZx+bCqCqiaphwSUlURg3KW40xSo8j/FnDsJ5HUxsAwGMjOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241830; c=relaxed/simple;
	bh=IrCIng0ergirWJ6hWgRtEJqZeBB5zIugjiesZ9D8Ovo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyE9bi25N0C2cvpcWYgDOOX4oHGpEASfhhiCixQt3eg0Ag/lvOikJoEbwB+vra1Wpuwtbq15jm+gr5eRn3xkeEdUZaILSvAiInC7Rg9EMombWhhyWCecCPJtzjUnKCErwLdONHuxe32bhfW0Bp36bdxKnz2Y6uPFF9rooBRT6Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i267Vp0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i267Vp0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D2EC4CECF;
	Tue,  3 Dec 2024 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241829;
	bh=IrCIng0ergirWJ6hWgRtEJqZeBB5zIugjiesZ9D8Ovo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i267Vp0DdM3/x9DMnfFgSNyfnlfjqPk3JKUTilJyg2U1yFjSlNWHRyj0V89ydvgkE
	 FaMpa0mO28H9WXGmUgqRRjzXTSS0ihJLMODnCAt80s7zF7rUkUi6OrDpb8Gdx88hks
	 +12qI44R/+BA0j4n41w3VgF1vSuIf2ekw6tHoBAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 529/826] NFSD: Fix nfsd4_shutdown_copy()
Date: Tue,  3 Dec 2024 15:44:16 +0100
Message-ID: <20241203144804.391996396@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d32f2dfd148fe..7a1fdafa42ea1 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1292,7 +1292,7 @@ static void nfsd4_stop_copy(struct nfsd4_copy *copy)
 	nfs4_put_copy(copy);
 }
 
-static struct nfsd4_copy *nfsd4_get_copy(struct nfs4_client *clp)
+static struct nfsd4_copy *nfsd4_unhash_copy(struct nfs4_client *clp)
 {
 	struct nfsd4_copy *copy = NULL;
 
@@ -1301,6 +1301,9 @@ static struct nfsd4_copy *nfsd4_get_copy(struct nfs4_client *clp)
 		copy = list_first_entry(&clp->async_copies, struct nfsd4_copy,
 					copies);
 		refcount_inc(&copy->refcount);
+		copy->cp_clp = NULL;
+		if (!list_empty(&copy->copies))
+			list_del_init(&copy->copies);
 	}
 	spin_unlock(&clp->async_lock);
 	return copy;
@@ -1310,7 +1313,7 @@ void nfsd4_shutdown_copy(struct nfs4_client *clp)
 {
 	struct nfsd4_copy *copy;
 
-	while ((copy = nfsd4_get_copy(clp)) != NULL)
+	while ((copy = nfsd4_unhash_copy(clp)) != NULL)
 		nfsd4_stop_copy(copy);
 }
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
-- 
2.43.0



