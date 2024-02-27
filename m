Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF8813B2B4;
	Tue, 27 Feb 2024 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043299; cv=none; b=TA5u6qB7JGRgjfn0pjCknJkyETG72QTq1vB3y48NBRSoSkYko7W8nv73x7jO4B5mOnPr4miwE15Hz26bUrxt/98EPfmgeWMfSEVfrJaR122AanOueRUvhQM/0Dn4F2bMdF2D3KR3CrgSVbei5rylcVY7GUqEhfdAGzl7gZzIkJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043299; c=relaxed/simple;
	bh=TVmbcU/Rlw4ww89Jgrr4N3n1L7u2WGwbnigz0kKk46g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6mR6R6o3dbkvohN9uW2YvYklk/0eWt1QkN+SWgVBKqscD/PwBJvT0G8lduOuPNwEE5KuxU+XNskAbm3j7nkRhT4EiL9wcy3qZ+P392lHkwBH83aIokV2WCwamYww6TUZi5j3YXyYBOI6Sxyws0TK89t/usdhtlOd7qdZCK4MGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/Mkl9MO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/Mkl9MO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FECC433F1;
	Tue, 27 Feb 2024 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043299;
	bh=TVmbcU/Rlw4ww89Jgrr4N3n1L7u2WGwbnigz0kKk46g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/Mkl9MOg3fwTyO9QId4na1SOiTIJNkbRth2NUAE5nR4O2fs0iIyL6xb+EUU/sECb
	 6blSbF+5ydxw9hXexgMvTkB3rdK0Luwl+RqDgCn1a6FPiXmqMWOZ7NxtZI09wvI2bn
	 xVoPqbPH+5MYSwXDH+q8Sn/+/wuzE10KTRMQTiT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/195] fs/ntfs3: Print warning while fixing hard links count
Date: Tue, 27 Feb 2024 14:25:18 +0100
Message-ID: <20240227131612.390628089@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 85ba2a75faee759809a7e43b4c103ac59bac1026 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index dc937089a464a..42dd9fdaf4151 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -402,7 +402,6 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		goto out;
 
 	if (!is_match && name) {
-		/* Reuse rec as buffer for ascii name. */
 		err = -ENOENT;
 		goto out;
 	}
@@ -417,6 +416,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 	if (names != le16_to_cpu(rec->hard_links)) {
 		/* Correct minor error on the fly. Do not mark inode as dirty. */
+		ntfs_inode_warn(inode, "Correct links count -> %u.", names);
 		rec->hard_links = cpu_to_le16(names);
 		ni->mi.dirty = true;
 	}
-- 
2.43.0



