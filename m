Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365183D565F;
	Wed, 30 Sep 2026 18:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794093; cv=none; b=O/+aXhmPjlxO6ZyyMzgcoylPc9B64d76dgnW1AxOK9HrAfzxO8XEo5jOPY3pWFFbokYVdEOfMukRyZrTA24TLT437gVxAU/SxjZ9fX0OIJEzOKlEzYTT8j15P5zIo9LZIQbMfwscFxNK7zU4zXbnsMATmMaqAdXeWHeuiM6bsjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794093; c=relaxed/simple;
	bh=xVUNpUwWLZ7cCefYVY/RE0phYaVuta97XlFv3nNIzN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZgneWE5cX2zalCms/c0JoA/WUDWabQA+I/XupNR4J7BLQBgBPOghGPxlhYh3JFGH74MI02/mttEGzdYzwlHxO5lsbVIPwCNYJpub1fowioVU22G8oHQOuSJNhbZ/YjvvTn8lKO4IL6sDdjTS0Scj5BzAoSNiUkEjO6HNTKCvNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O25ApFq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O25ApFq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9111A1F00898;
	Wed, 30 Sep 2026 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794092;
	bh=AL+ycLt+a2YY/9+F6nGOxgaAZuWcVXOkzVUsE3EzMnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O25ApFq6J56rhkS4/RL4NRmBxesNQEqDoq1GGJQ46hyoyH48Hlsnb3csEb+zMQYja
	 fmyl4TEXMW1pWcX8xKgHSStbnTe0h+HiiLMBAWW+KQ/4rg7skho81zhXkyFtJ/O464
	 lUGiIozY9XL3uoZwU9mx3VYPJixEeMqyJeQGgw9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0088/1193] jfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:52 +0200
Message-ID: <20260930152436.200089422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 05107f5602751fcfd3d108c1f579eb45aabead52 ]

jfs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-5-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index c4f565770d316..39031ff5151f5 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -524,7 +524,8 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 	/*
 	 * Initialize blocksize to 4K.
 	 */
-	sb_set_blocksize(sb, PSIZE);
+	if (!sb_set_blocksize(sb, PSIZE))
+		goto out_unload;
 
 	/*
 	 * Set method vectors.
-- 
2.53.0



