Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216225;
	b=vqrgZc433U2LJAa8UBSP2hN+718VwOJ8O42dVs5VakPcZJ/krldYeyKyfECwiF9bOtua
	 +cLxTPfIEK26EprKLjTZ/zxb9LMRms+Qr4wV7KTCNeqreloL5YlfAZmREo81rvS7OMsC9
	 uxjw7O4XxRFoyrq6nf8sRl9A2GN6daCXTN7METhCCb6ntRk5OrRPk2XnqScABIbMBsyM4
	 g0yT2obmotUZdosGTGqIS2bZkEYL5oGVqAiGddkybALKy5Dxe+p3fRntO0xsnjp6UH4MP
	 5DhGzYV54Km/MYZ8ovcwH96UhpMrov3YnFJPApXo6jZGxZ7Ru+MyaasNJ6r7pzTY72A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4JjHSvdoWc119pkB0s/yMi6ZkMtjMdldgeTZM7nLslE=;
	b=Znl865ke5esbdhYrISJSXWC+D2hOak1LOChnEJRRIqq5ISvFxOhAqikzypVxTzUDwZRa
	 w+5Lv4je1rCm1+8iJizNVxuRnsxOrx41WDpxWyv5NgwJuvkgDWCQq/x/kBadxIfzIsYh2
	 wjpWiuohyzpjso8ofeoc+/hK19Sy0qsgsGCg2od0WOzyV0T6pX+bkRBb875nYUud7M+He
	 5abnIjoI1Y3MBD6mrsgACCLJbn06Fl/7LIFEYPHKfSlzP2HbAs3Z6zmKdbBOWyrDQ1Vh5
	 9LLNSWKHQLEjWDWomR/1FyAMIYSk4KJdJQCMDh7ZSglznpAwDalHMJGZuqaAWx+vsMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5dptoDA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94F606A333;
	Wed, 28 Oct 2026 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O5dptoDA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A951F01828;
	Wed, 28 Oct 2026 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216225;
	bh=4JjHSvdoWc119pkB0s/yMi6ZkMtjMdldgeTZM7nLslE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5dptoDAftG7901hEeuAYSOVyeMh7bqPC0TlIsKSUXIq86+PLSnTyg3fJk2AewOup
	 467CCRbtqoAIY+Ko2U1hLkmmT7TsKWqj8oOQnc4snGVy6FzWzSsLzbBgJjOBzz0VDW
	 Nwd7WR6oRfTqRH+5je81j4Z8zLtCg97/bbeSXXFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1484/1887] f2fs: fix to clear dirty flag on folio in error path
Date: Wed, 28 Oct 2026 17:59:40 +0100
Message-ID: <20261028170533.221181343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8df943d6ee626..81ca7b42b984c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1510,7 +1510,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
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



