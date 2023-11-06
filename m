Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DDC200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAe7lTsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A63DC433C8;
	Mon,  6 Nov 2023 13:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699275936;
	bh=lTYl4UpV7UeoT4zk6S6kRV2/gHlGjvR0s6VbmPvfAro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAe7lTsR4sVfX9n3/WTVqd6aCVMVOfKvahplcoKBZcg7qCAMIULH7zOvC6hqsdEfL
	 Mnn4eL10ADlLCxq7OaXFYz2GCnTnyrVwIrRNZFMLMfRZUTlgh1dEq4osKrIV+8worr
	 BhLQOoTDwOw7Idh05W85BQb4pcxYON4xCFnFCwns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/48] NFS: Dont call generic_error_remove_page() while holding locks
Date: Mon,  6 Nov 2023 14:03:05 +0100
Message-ID: <20231106130258.339876168@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>
References: <20231106130257.862199836@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 22876f540bdf19af9e4fca893ce02ba7ee65ebcc ]

The NFS read code can trigger writeback while holding the page lock.
If an error then triggers a call to nfs_write_error_remove_page(),
we can deadlock.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 010733c8bdcd3..1b5791d5537a3 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -587,9 +587,8 @@ nfs_lock_and_join_requests(struct page *page)
 
 static void nfs_write_error_remove_page(struct nfs_page *req)
 {
+	SetPageError(req->wb_page);
 	nfs_end_page_writeback(req);
-	generic_error_remove_page(page_file_mapping(req->wb_page),
-				  req->wb_page);
 	nfs_release_request(req);
 }
 
-- 
2.42.0



