Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F2E509F05;
	Wed, 30 Sep 2026 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784339; cv=none; b=Ngh+DyuEU1hSz5R70OaW+iC0mVqskDtawBxxyUmBniBfzjw3DKIDGnh1xpCMSmjGvJIFuyMAVMKIgrR6CI6kO/UijcuQykljifHzWYrvS/GsqP8BKQv5h3fa5quqXxZSOkFvBb3FCqqgWLCfzRRVtTZoiao3inpE8OYeuiL4jHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784339; c=relaxed/simple;
	bh=E4bGQzFn0/pQJWNrL7viiASToiHX80GN7NBe886s+JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyCjJsTKFzmETS16q/LE0Op5HiEmpjXuSC4FMyBqASJBLNU2ACQANwlyp3qCHIvt2pXE0rMxhTo4hGNCFBumxFD7eN0KV54Qt6nas0Aq8Xxwew5gFkDtP29YIbHFb19mzSxEd550pn6QMs6+uTwLksiy0sIeO01ZQOMoPj+bEWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kd6OAeMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kd6OAeMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9BC1F00893;
	Wed, 30 Sep 2026 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784332;
	bh=l93XVZwl1rifziIq4r/wHwprI3DsU92efD9MslSgQDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kd6OAeMQwU3IeZykQtnpOtHudc7YbeYTymGPVPAj7bWcP5tKy4Ymz+OFEakyj5mf7
	 1p+K5RfRLxc/qIO0Myvh4D2uLOQAlHgmeAtjKqZ6SHYdiHCciNbWrJmAQp/BIDnHgY
	 1bLWoXZwAuZ2Kk8F/4U1f5S63X4cxWEyAG5PWaGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/982] isofs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:13:30 +0200
Message-ID: <20260930152418.395007165@linuxfoundation.org>
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

[ Upstream commit 25ef4c4d9f0e96fb89c0ae0d7127c3f12a31bc32 ]

isofs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-8-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index e3052d3fe5dcd..8fd91f09086f1 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -859,7 +859,8 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	 * entries.  By forcing the blocksize in this way, we ensure
 	 * that we will never be required to do this.
 	 */
-	sb_set_blocksize(s, orig_zonesize);
+	if (!sb_set_blocksize(s, orig_zonesize))
+		goto out_freesbi;
 
 	sbi->s_nls_iocharset = NULL;
 
-- 
2.53.0



