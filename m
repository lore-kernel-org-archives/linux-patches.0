Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214567;
	b=ZwBOAZ1we21gebUPporj/2/Z17Xb+M5oVAq3V7gIok0sfS+q3pEK2CmA/WU2mBQKYDqE
	 nB+Zn0wApPJWnDsb0YnKihyBi2FgCfSKyPe0IChHhmJsz4isk578mS7uXLvFLsvc0rBms
	 0KYNFXWE/xU8Q9br1X77+z0P8m9afZ2HOrj9ynRqNaftGzVp4kB7zVHYojS5kkhel2NZh
	 8g6zv3QtRarGnM0Dd/bXpBbLo8dssMwmNZBntwNjJP6jrL3je5E9TTqC4+nnIePeqv2WH
	 GIOHxONTBJRzXnTOXKNZtxhtGxq+V30omFVVHTt9aOvZy70P07vYNk29cMUhLM19COw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=187Fo/9GAFIYbhPISGeIstW/ayLG5VzLG2j7h0U2cHg=;
	b=LSzSyHo1+SIucTHVy3D575QDhebOrOpKdJdVc2fJ+NcCUoHvfGfiAmNWGITJ59y5u0WT
	 C6VzPi42WnpOtGYgPaj5V96RC3WjPywpM5PHQGEmQ6PTXtVqxvdhIIGKF8goptA6ezsl2
	 J9Z2hgOiegF/NunKu43WKhAmbjZ0BJn8MFny3jGyKdaboOVRLFwENIty18f8lTN3SKdOt
	 o+RcgwrOz95/013ef2JrH7loyK3vnmRssTNnIXT9U0RrLID1nnU3wgN0/caATJdbrEJXn
	 Mt5YY6JVveQZpkYbpat/axuRP74DNtaSaV21FockMEJHW+OaFRCrRWfTD6+vtZMamMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rpd/duoW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0193B606A31C;
	Wed, 28 Oct 2026 19:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpd/duoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521641F01828;
	Wed, 28 Oct 2026 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214566;
	bh=187Fo/9GAFIYbhPISGeIstW/ayLG5VzLG2j7h0U2cHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpd/duoWiez3zZnTDv7jKhBOpQ0gHpEMF13bVTP+ZxgFYSk7RLvSC4eEksESVaQBW
	 +hJgjJEc3WYSGKNsl7Ye+x2nJae8fVK+bqhbSnDYEvcpMJv5ZTMyL9S2fYvcnZsxok
	 hHgJzFi5k7aAwoINScsZBrD/GTxOKiF0TKoiVVPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0861/1887] f2fs: fix to avoid overflow while left shift operation
Date: Wed, 28 Oct 2026 17:49:17 +0100
Message-ID: <20261028170519.013765345@linuxfoundation.org>
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

[ Upstream commit 0fe1c6bec54ea68ed8c987b3890f2296364e77bb ]

Should cast type of folio->index from pgoff_t to loff_t to avoid overflow
while left shift operation.

Fixes: 3265d3db1f16 ("f2fs: support partial truncation on compressed inode")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index b882891fbf28d..37a684c682c7b 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1216,7 +1216,7 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 
 		for (i = cluster_size - 1; i >= 0; i--) {
 			struct folio *folio = page_folio(rpages[i]);
-			loff_t start = folio->index << PAGE_SHIFT;
+			loff_t start = (loff_t)folio->index << PAGE_SHIFT;
 
 			if (from <= start) {
 				folio_zero_segment(folio, 0, folio_size(folio));
-- 
2.53.0



