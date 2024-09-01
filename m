Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0E75381A;
	Sun,  1 Sep 2024 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208412; cv=none; b=ZuFTMStvOydh5wNNmwuLhMu8tEyzQRljYjQS0Pp2XjOy6n+TAmvRA87HAXH9r8c2qg9soO6HUkHyGxIJhfsrqs7gYWGIw4M6akqXkoivZ/9Ke5+oc/rRdXN6g7lmbei5grkguIjG3SgHvf9kemanVtR7Gp4zk0Vscz6WpowLsTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208412; c=relaxed/simple;
	bh=PbfS4eiBJ4Q534elt8IhUoy+VKOYGanLiy/m2g/93fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XikqHS0fePQv8uWYRJMy4GDAY32bPUn8eJqcmnYFn59Pqzfjg+pUpy1hX0NNyJOfTFGHltiiVoJObzYmUD/Ae8YwH5/8dCSI33ZejMxm3eC4ZYnaBEOiPm6mWzFAyZCGwtfJfChmHOfnave9ofkanaYQAUzPFJGWHp4BcwwFfK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmW1U3KY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmW1U3KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6086C4CEC3;
	Sun,  1 Sep 2024 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208412;
	bh=PbfS4eiBJ4Q534elt8IhUoy+VKOYGanLiy/m2g/93fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmW1U3KYYJUsFtQgQdbfh5f4UYKvRWF1AjbINxKuwiz9g4ljdoPIxM8vvuMuxAIEF
	 acHOvc8M8YQsYuJHMzTwBX5m3h1Px+svKi0SqsgsuApmvcv0UGuiwdD51tbPIsvp/Q
	 KkvQu7AVY9oN+JgWQVdpNQccplJOipMhWrVvwcrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 074/149] nfsd: fix potential UAF in nfsd4_cb_getattr_release
Date: Sun,  1 Sep 2024 18:16:25 +0200
Message-ID: <20240901160820.248764915@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1116e0e372eb16dd907ec571ce5d4af325c55c10 ]

Once we drop the delegation reference, the fields embedded in it are no
longer safe to access. Do that last.

Fixes: c5967721e106 ("NFSD: handle GETATTR conflict with write delegation")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 19d39872be325..02d43f95146ee 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3078,9 +3078,9 @@ nfsd4_cb_getattr_release(struct nfsd4_callback *cb)
 	struct nfs4_delegation *dp =
 			container_of(ncf, struct nfs4_delegation, dl_cb_fattr);
 
-	nfs4_put_stid(&dp->dl_stid);
 	clear_bit(CB_GETATTR_BUSY, &ncf->ncf_cb_flags);
 	wake_up_bit(&ncf->ncf_cb_flags, CB_GETATTR_BUSY);
+	nfs4_put_stid(&dp->dl_stid);
 }
 
 static const struct nfsd4_callback_ops nfsd4_cb_recall_any_ops = {
-- 
2.43.0



