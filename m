Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A4B145340;
	Tue, 23 Apr 2024 21:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908586; cv=none; b=S128nvZB8wL0a7YFjdc8+5ZA+WsKMb6RNJ5cpErEptVKS1CIqjUxHBDteKhYY5IHokxTQn2jga7wwecdzT9QkdRd3Tm3SgUvAQm8UGmtqXUqZVU+HY86fWJihOTOtWm88XiVi9VxWg9RP00G5YoCZR0eya64avoU67gMiHjk0Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908586; c=relaxed/simple;
	bh=ZF/P/pkpJqH0tM/Q03iNgOLwdpt+zn8pMIm/XMXbeVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOFnyNSedwU/Vgz6+rmEjkrZxHAVx5EVfVEtxWunHiW2bcY/eR/O0sLcwpCiFO/Kw6pfwrmFOUt60e37mz0SyV9gFIJgEszoxqfMnmCRTbwIcTb16ItHbSZD+rDsYqJ9KxTKo0Z9Soa1eNR3cGKVfTIsRlmJy74LEH+OWos156E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMu2t7BW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMu2t7BW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4313DC3277B;
	Tue, 23 Apr 2024 21:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908586;
	bh=ZF/P/pkpJqH0tM/Q03iNgOLwdpt+zn8pMIm/XMXbeVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMu2t7BWMxmPubZttMl9UuDErzv62MKl65dVbGzKGMpMMx67DFROTYD7D/tbKRIKZ
	 El+9JbY8nDAIvqz2dsx9wSIvcqij1cCAxUt1Cu4UmkzOhp3HBf9ET6TwQg3lBMC/C6
	 mJMCWjfUiGMJSUxYAM3+yKi1IRKMWm1avYMmq+bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Xiubo Li <xiubli@redhat.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/158] ceph: redirty page before returning AOP_WRITEPAGE_ACTIVATE
Date: Tue, 23 Apr 2024 14:37:36 -0700
Message-ID: <20240423213856.343963071@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit b372e96bd0a32729d55d27f613c8bc80708a82e1 ]

The page has been marked clean before writepage is called.  If we don't
redirty it before postponing the write, it might never get written.

Cc: stable@vger.kernel.org
Fixes: 503d4fa6ee28 ("ceph: remove reliance on bdi congestion")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 28fa05a9d4d2f..da64bb7325dbc 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -803,8 +803,10 @@ static int ceph_writepage(struct page *page, struct writeback_control *wbc)
 	ihold(inode);
 
 	if (wbc->sync_mode == WB_SYNC_NONE &&
-	    ceph_inode_to_fs_client(inode)->write_congested)
+	    ceph_inode_to_fs_client(inode)->write_congested) {
+		redirty_page_for_writepage(wbc, page);
 		return AOP_WRITEPAGE_ACTIVATE;
+	}
 
 	wait_on_page_fscache(page);
 
-- 
2.43.0



