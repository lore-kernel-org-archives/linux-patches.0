Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3A82FDC59;
	Tue, 12 Aug 2025 18:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025044; cv=none; b=nssV2HfyovA8TUwHzRS/FrPlqvgBBsQwqZtjJr8uffgW3e1Rx5hEQjWe3Ghh73m/GBw3+OgOBavNEE1qKdpXQoBnlKZHjOczRgtPFWAgR/DXUpZNGK98W8earx4VQ5JAXwSODU9He4NhxsD9afmUVfauvaDoD4FIZRP2TfORNSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025044; c=relaxed/simple;
	bh=raFL+I/OvsODt8uXyWqFhvaf2ct7OArgm1xWu7fYh5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b70N8Dy4WlCVGrzKYPeh/U51zMZH+RDK3wJLhtxb5TwdO9UubDBXy2AMGaEXYGFCQlEThuV4zPYwPAoNk1cOIXFV+leSHX55tK/7vuroTC+cQczlcgBJxb7gV9GXYK43s47ggtODF2RhtP/pai2oUxnTapbrqwrp8XVD7QdVkt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyhmW8dF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyhmW8dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F361C4CEF0;
	Tue, 12 Aug 2025 18:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025044;
	bh=raFL+I/OvsODt8uXyWqFhvaf2ct7OArgm1xWu7fYh5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyhmW8dFawW+pwoAxe7+OB/6pdah7IiC555qBP4+BQg2+Y+ounuM+xRMucVfP2pXt
	 5u1qPt7LTJwXcWCYtUc1fxxXnzOwC4KFtBwwQg1CCYrYptlXKAjnAHGu9y2tQ4QpZU
	 vtivNS0wAUgvk1j/zU9sJ+2nkgAygY841YdIVL68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neil@brown.name>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 553/627] NFS/localio: nfs_uuid_put() fix the wake up after unlinking the file
Date: Tue, 12 Aug 2025 19:34:08 +0200
Message-ID: <20250812173452.937404405@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



