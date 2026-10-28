Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214564;
	b=4i0UnufATE3U6Kmc/oO5OgL1SjcagZwfmjuoA9r4UOllWAJ7+UC+LT/cViDrR5G1kiYV
	 zwn3RdKfAYcd/nbf0OlwfoePy0iSrkhNC0EYqk3LerHd/oEFeMVNVkRsdZL13hNcuUQ7Y
	 zuB8JRJ5QGSxeBtp/rQVI5w40P+tdq5DSuLSG5ThNeuuJmOFQlgfxhPVE0B03+YCC1Wy6
	 LzTYTLj/uF29BCCbjHaLeEQUHhe97DCbsrqxg87OpWQy4FwBXmZNZZHlETI61Ga0egUap
	 zFwUHQVk8HKK05SXVH61c+/n6YxI0QlkRPb6ocDGdKumGXwwjev+9gWcTBNFMnF7VOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UfvL+vnGQlS25XREQMkdzMNDRHYdeLUFk0HPeshArAw=;
	b=rDzx0HbCw/0CONfhihpMkqc6GA9jRrG7taZb5LWCXzO74G6xlQdZP+w6cJH2sxJ/uA7E
	 OGF7KBb8FOS31+x5fbCza7VpZFGaGL4bKxHqCzSyKNUFOr0GnridHdZkj3WHa/Jctdb0r
	 JgX7PkK7tbhF0FU1wDgbW/314RAq5N3oiiyFuHAJfJrgDRHihq2NdlzfSX4dy0+4NU8RP
	 ou4JLI+fhpInWlvfnUc+UILpaZeRrl4/dA4V27pUAfLU+OKPqs/ue7bXxs7v7TQBOsHDG
	 NQK+0b3UMf+suImrRIiDmhbd92lS+6cdDB8dhjXCPTPN2ni8mjYxCZlrgBd58vLudtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H349CmHa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416CA606A31C;
	Wed, 28 Oct 2026 19:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H349CmHa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759B91F01825;
	Wed, 28 Oct 2026 19:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214564;
	bh=UfvL+vnGQlS25XREQMkdzMNDRHYdeLUFk0HPeshArAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H349CmHaajKWsSu1IK58E+uOKco1Hv+cI9ExBcsis1v8unyw77hDYkTmWN3+w2Tq+
	 uU+zPdsFh8V7GOsoXNUCDl7vkNQAVljxicM8GUQkymYdGgPf8xXsWPZZSjpG0BC18v
	 TnmqrTggUNDl4JogF9J4fH6r/F9V1cKujhFjIGgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0860/1887] f2fs: Use a folio in f2fs_truncate_partial_cluster()
Date: Wed, 28 Oct 2026 17:49:16 +0100
Message-ID: <20261028170518.990798193@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 1cda5bc0b2fe93cdcb5f05a02f814a282d32742c ]

Convert the incoming page to a folio and use it throughout.
Removes an access to page->index.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 0fe1c6bec54e ("f2fs: fix to avoid overflow while left shift operation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index de64a621c729b..b882891fbf28d 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1215,13 +1215,14 @@ int f2fs_truncate_partial_cluster(struct inode *inode, u64 from, bool lock)
 		int i;
 
 		for (i = cluster_size - 1; i >= 0; i--) {
-			loff_t start = rpages[i]->index << PAGE_SHIFT;
+			struct folio *folio = page_folio(rpages[i]);
+			loff_t start = folio->index << PAGE_SHIFT;
 
 			if (from <= start) {
-				zero_user_segment(rpages[i], 0, PAGE_SIZE);
+				folio_zero_segment(folio, 0, folio_size(folio));
 			} else {
-				zero_user_segment(rpages[i], from - start,
-								PAGE_SIZE);
+				folio_zero_segment(folio, from - start,
+						folio_size(folio));
 				break;
 			}
 		}
-- 
2.53.0



