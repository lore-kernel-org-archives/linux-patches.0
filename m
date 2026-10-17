Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA093B388C;
	Sat, 17 Oct 2026 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259838; cv=none; b=ujmN82ceNcuenryAjOasEFdzOsHTWQoO2GfeeilPujO2GU1P0PC1AuHy/TJnEGe3q/YdaprLVAMiYZd4D8aVf6POg8PhhOET64TXOZgvz82zplN4UV7tdJsylFU+GJ1ZPP7EnGwbwiXG7qT5g9f8sbkWo2latj7Syap6EBLeCHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259838; c=relaxed/simple;
	bh=eDlwt0zRQUzsCENICUiex5rsySAyVxeyV4sXOpu7VpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0v+wCf0gaAsoktZ2o88Aj+Huo/sLXfHzyalaTRPcRv4h9MOwvwtWSPO4dsuh4K1/2cU3aSQ1om3sZ/HSgfuY7zhFXB1d5M0w778VR2ia0zqvxyiYJSKGYJqYWOdUDGbDPqOr80a7r7j4Dm6QaqBg2PBMxwdyJnK/dqLjgLEn80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8b8gxBT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8b8gxBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B611F000C4;
	Sat, 17 Oct 2026 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259837;
	bh=eWiQbpSPsyO9Ozh9Is7cku0O+vr6dXlDQX9Lmf76UK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8b8gxBTzATS9GiOk8TMqmv40ucft3dZHckO0wRrQsWzQveD63apw2V1VBBYBpBn3
	 fkLgkpRPEzCkBB706GVU/ixGC7YWQ1m/xoLU13mYFePxmnWUi2im1mOsWdFqPXQxun
	 +rgx41VinrMb2VPtkXayMlBSn9mdDHTX9Qeu9sy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1347/1674] f2fs: fix to clear dirty flag on folio in error path
Date: Sat, 17 Oct 2026 18:00:19 +0200
Message-ID: <20261017160505.733703261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 5b86eab84ac8e9289b5afc52ef88ab18ba5bacab ]

If node block is corrupted due to chksum mismatch or inconsistent
footer info, it needs to drop clear flag of node folio, in order
to persist inconsistent node data to storage.

Cc: stable@kernel.org
Fixes: b42b179bda9f ("f2fs: fix to do checksum even if inode page is uptodate")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c6da0daece881..890ff1d341013 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1517,7 +1517,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 	f2fs_handle_error(sbi, ERROR_INCONSISTENT_FOOTER);
 	err = -EFSCORRUPTED;
 out_err:
-	ClearPageUptodate(page);
+	clear_node_page_dirty(page);
 out_put_err:
 	/* ENOENT comes from read_node_page which is not an error. */
 	if (err != -ENOENT)
-- 
2.53.0



