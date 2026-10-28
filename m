Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211308;
	b=AkD5gYUi6mmuvPR9bE4LdqNdFtjpucTL2e+BQhJnAh2Zh2fHK7fdPPS7kWfiV4WIfWoh
	 uSOOBqCibbGAUTge8Ky/bhFj0BGEeIPvalZFvc+h7aCiqJfmlyYCMnqIu3zK+cT6ym5er
	 49UjOLMHNDrZjK+K4dwseaF1WHqWcEF3ncw3lWWo6ilgbNq/Xc6WyaX3kk0tukXvEPTmM
	 RKwEYeS6Vm1eK7Iixh+DSouNee2ouaUxz18Rp+s/GqhEqoQPhuqCMGWzoc/Kk04qwSvJa
	 dGG5TsEJVXw4miYgd+Tq6TV8Z4e9aE+Nm42Mbs0fU+GshS2NhIHXf+nJqNRuPfxtSHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k+WzUMczeL+/WmOOjNyAjqFv8Q4H4mm7kfFVvcstcGs=;
	b=KEwY8tz8D7VwnYs5bubF6pbIGqi9SSPi5WtdD/sZ2jq0OwNNA36voX1dok5EghN//NcH
	 4uXX0WmPE9O+6thoWh+3ov9F9/eHAW6C/IRCgFNh1twLSfJd7/41UGykm4BzpxH2Y4PeU
	 w6XPJizfzwsYG/XW/rJp5X+VDWkmzBFegoEiuw+KANioqLzmNUe/MISZtIPzDlGm1duhz
	 KhoCQc7fhiwMvsr+ptvqjJimzYMFs977XcpWHcNttAGJejim4LWFI8g0CyNqvjKQwxaMD
	 60Ht9BuUp8POihL08NGD5xuXgMSGprmpF7TCWPKejQr2lr/qqdZ/LOZPzIATnRMn4jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4IBQy50;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844B6606A959;
	Wed, 28 Oct 2026 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s4IBQy50
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CAA1F01825;
	Wed, 28 Oct 2026 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211308;
	bh=k+WzUMczeL+/WmOOjNyAjqFv8Q4H4mm7kfFVvcstcGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4IBQy50RfOOclFPMXbCpD/IAbmPAlUF99RoVqlKmkCfAXY1Iy5zdtmdyRYcz6IWe
	 33jTKR+wqsFPC5dq0cd/+3PWDFHT7McMBYhMGygOVoZchW1uz0HKl7/u6M7RGJ42Qa
	 125R9/bai+MX1OLN0kyrEKjFEhY8xEYi45PhqIlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Zi Yan <ziy@nvidia.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/571] fs: Free any excess xarray nodes in clear_inode()
Date: Wed, 28 Oct 2026 17:58:00 +0100
Message-ID: <20261028170015.908753030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit ee3f011250104129893d8e9599147e457d4d7280 ]

For many years we've had a hard to hit leak of xarray nodes.  Hugh
documented it well in commit 786b31121a2c.  Recently people and
syzbot have found ways to force it to happen with madvise.  Rather
than fix the leaks where they happen, just call xa_destroy() which
has the side-effect of cycling the i_pages lock.

Cc: Rik van Riel <riel@surriel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Link: https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.com/
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20260623192850.1595958-1-willy@infradead.org
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 0a3a14b9ee46f..bfeec2830fb0d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -584,21 +584,18 @@ EXPORT_SYMBOL(__remove_inode_hash);
 void clear_inode(struct inode *inode)
 {
 	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __delete_from_page_cache())
-	 * and we must not free the mapping under it.
+	 * We have to cycle the i_pages lock here because reclaim
+	 * can be in the process of removing the last page (in
+	 * __delete_from_page_cache()) and we must not free the mapping
+	 * under it.  We also remove nodes which are empty; these
+	 * can occur in two different ways.  The first is that radix
+	 * tree expansion can fail partway and the second is that THP
+	 * collapse_file() can allocate some temporary nodes and not
+	 * clean them up.
 	 */
-	xa_lock_irq(&inode->i_data.i_pages);
+	xa_destroy(&inode->i_data.i_pages);
+
 	BUG_ON(inode->i_data.nrpages);
-	/*
-	 * Almost always, mapping_empty(&inode->i_data) here; but there are
-	 * two known and long-standing ways in which nodes may get left behind
-	 * (when deep radix-tree node allocation failed partway; or when THP
-	 * collapse_file() failed). Until those two known cases are cleaned up,
-	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
-	 * nor even WARN_ON(!mapping_empty).
-	 */
-	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-- 
2.53.0



