Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F76727703A;
	Tue, 12 Aug 2025 19:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026696; cv=none; b=KfwzmzqyW9W7OqWOFNG45I4H9P/IZgP9i2QADqK4TmIOat1YGrTXHFvJ5lCCgjvcbtaFWDlCz6+AuNPnDZpbv0CcTEW544A/49AN7p0iFFDrk8nZVGhuT9ncHyAvKCTZzkueIYtNpM7Tq9XON5boxsThq/v5e6SvHmeNY+/tFdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026696; c=relaxed/simple;
	bh=JKtai1BnxmAsEONftRHBNbcIZektASwwPatzKmJd+h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxQuBIC0LUIxIO7b4+b5jvFhvxb+rpCWTZAUoUBTWK+M8SHKgzcavjjX2ufvYiUZAzV2gqXzxdn+zTsgZdayiBpMfn9HwL8pyypvw5ASwQJqezI9D5SdKqjQjDjsMHTbvACNOqYR8SrMDHR2Xfm2jBW3SY7CXlaGLkIWrZiah94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxFtzOVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxFtzOVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6525C4CEF1;
	Tue, 12 Aug 2025 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026696;
	bh=JKtai1BnxmAsEONftRHBNbcIZektASwwPatzKmJd+h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxFtzOVE7otib0kAl51mdmpUMz3A/DQRfLLrzfSAX2DG5PJM/AS0hFz7LWK5rxIUZ
	 QvAWQiMh62CGESpkmDhJrosQPV6oYKTy/waBtw5KyTQ3Qlx3YfzXgHUEvO5oHjNvjB
	 BaaYRZUyJOmuq49tjcrrBS4dlN1YFvFVuMqj4Erk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neil@brown.name>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 414/480] NFS/localio: nfs_uuid_put() fix the wake up after unlinking the file
Date: Tue, 12 Aug 2025 19:50:22 +0200
Message-ID: <20250812174414.495315781@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 4ec752ce6debd5a0e7e0febf6bcf780ccda6ab5e ]

Use store_release_wake_up() instead of wake_up_var_locked(), because the
waiter cannot retake the nfs_uuid->lock.

Acked-by: Mike Snitzer <snitzer@kernel.org>
Tested-by: Mike Snitzer <snitzer@kernel.org>
Suggested-by: NeilBrown <neil@brown.name>
Link: https://lore.kernel.org/all/175262948827.2234665.1891349021754495573@noble.neil.brown.name/
Fixes: 21fb44034695 ("nfs_localio: protect race between nfs_uuid_put() and nfs_close_local_fh()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/nfslocalio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index f1f1592ac134..dd715cdb6c04 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -198,8 +198,7 @@ static bool nfs_uuid_put(nfs_uuid_t *nfs_uuid)
 		/* Now we can allow racing nfs_close_local_fh() to
 		 * skip the locking.
 		 */
-		RCU_INIT_POINTER(nfl->nfs_uuid, NULL);
-		wake_up_var_locked(&nfl->nfs_uuid, &nfs_uuid->lock);
+		store_release_wake_up(&nfl->nfs_uuid, RCU_INITIALIZER(NULL));
 	}
 
 	/* Remove client from nn->local_clients */
-- 
2.39.5



