Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C91B3F926D;
	Wed, 30 Sep 2026 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784280; cv=none; b=PtYVatxprhniTfh+u00OawQXnOcmlGM6Y2ptlnoZ+WMmUI7yq05zhVJVZrSmyNSU9bw1Njq+1FlrU0gQCv46n9UadQ3hYxNW5Hy751enS5x0xOwx2CCzbeqzl0wSl9CiEDWE88OSjblUjRJAzR30+LELryKbRDZnpqdTUKjUSTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784280; c=relaxed/simple;
	bh=F2D8jVcb3rg62N4n+6Inz9Vwloo5hadwy6dgQGdRVPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcNVaZOVfbP/6pMmWMxgrNTphFyEz4bwXCMOyxtpxPerdMtZX3L1OBtjDWr+u+jpMvX7d6c71UbqhH3ES9F2os2HCltHdybhJAOu+mM+gISGP15eSCrssNazKR9viNtjoouxVp3u7kxWT+cA4vwAD8I/CyF21+y9NSeLAj0jtws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAmgfr9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAmgfr9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C2D1F000FF;
	Wed, 30 Sep 2026 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784275;
	bh=yY9cAuyoz/OTPmPEuyFVk3R7iXCT+xWNWZJiDYvbG/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAmgfr9uZ9evlyabfkIaKRsKd9gvoUQozjhJMQva01YDUogWLQl6p58OQDau3xD0G
	 T8XcCLRw9Nk6LUuPM8lVQjmjUz49znuQYYG74Vj//FAAq94x+Hs8EAa54/TlIrjb0V
	 bXewbfHzA1I6sbB0pqWHNe9WI+0ToJc2oMUvDbnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/982] jfs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:13:27 +0200
Message-ID: <20260930152418.329013929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 85d4f44f2ac4d..698470a2480c2 100644
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



