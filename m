Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E2E3D45E5;
	Wed, 30 Sep 2026 18:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794101; cv=none; b=jnW3Oj60r1WWlXc3yxLtDgUvfNv3HJP9lP6hWwfaPtsHpCYD0neeRz2rFrygQD/+pGXdHVO0uyM92lIU2fip1tRZveVHGr769AqWPsH2uo7en5lqSK0Q7pCYgJNrheQmE+8e60DUvyUlbAHG1ePU5mBlHT1PSCm/B6bzvoM64pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794101; c=relaxed/simple;
	bh=71+wSwWX975HwhLKhe5D6oXMR3nhfT7L1cUv76r0UHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBFTwmn+XOba0Q5pkfZIi4+gy4emXxOdJJ/aTzYQ1ZY0tgfDloVdSkX9RRinMki5PI+07f8IHkAfXCBODwV/jJBYNXytq2EbAKC8vBcA0ubJ2tTyzQ52/txWHU5hGQbOmyyWRvS2byUz+DpTwDp/z+VQunZDcAPMDWfGXzqsFhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ca8MJyvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ca8MJyvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CC21F000FF;
	Wed, 30 Sep 2026 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794100;
	bh=MnrRxuo4DfhUgCQascwWEYX2C9B34TEsDatPR4Dk1Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ca8MJyvyiKyV74jW2061UwVelZVCoOy5uxB63vKrtzs8dRgW/8PohHQ/QixPKUzwO
	 6Cao74chgAGwADs9WwSZ6BMHbZSdUFIGZhRoDrG0F5wCSHaVOi61Co6cjEjc4gwSA3
	 sOVTVzSjhAqKXTFgpixuysxTEmIQ1BnhLkQ/gCrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0091/1193] isofs: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:12:55 +0200
Message-ID: <20260930152436.263635155@linuxfoundation.org>
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
index d989bdcfaa26c..e7de6f3a5443b 100644
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



