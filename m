Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC3520B00
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwICY1Nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1275C433C7;
	Mon,  6 Nov 2023 13:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276203;
	bh=J3kt89sFEnc3jK+42ezI18F/Uht3esc/7CNwpBj3XRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwICY1NjRC89iQdaSY44JJsd92AJ8DQsZh8jA1d9ENdfdbjaefgFjCxw4jjGw94aQ
	 OcN7s0h3lIj/yDFwNEruT3DFXy3OcIKPGA+1XlHMhMHmOiqxNo2zV/VkSB6OIPCBbW
	 5neKYtPBABJRGw2EXaDneETX6yWLtT7bVrb83xz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 24/61] NFS: Dont call generic_error_remove_page() while holding locks
Date: Mon,  6 Nov 2023 14:03:20 +0100
Message-ID: <20231106130300.433681974@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130259.573843228@linuxfoundation.org>
References: <20231106130259.573843228@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ec0fd6b3d185a..65aaa6eaad2c1 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -598,9 +598,8 @@ nfs_lock_and_join_requests(struct page *page)
 
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



