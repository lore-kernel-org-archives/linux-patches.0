Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD66196D8E;
	Thu,  6 Jun 2024 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682985; cv=none; b=HyrPIAaphJket9sFgo9kQE/+2ShQF+S8TGBizPqC8e+iGXR8IaUeLyWlySdQhL4wIQX1RyquN2eJAxdCZvyakTCrIADFMEuFUpkDkcTRAcdQKjEh1uBM/8ADt18+3025N+xq2AAqfKa9ujENQmC5/TB36zlOUXWFZ8BQcsDPrmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682985; c=relaxed/simple;
	bh=/UeY7yp0zQKpOAvtnsISmvFmcRwkblFv25Bsk9OqMAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAm+M7EQMw5l5tSQF1nW7a1HnKk22IdksTrDfZnMDGqVCfWmRGNPliPJ+Dzow+MYA3jpottlv/COV8+XxaZQrpYz5XI1UUkNvZgp0/NfQVnBbWKZDWsXjA0UY62ArbRPsG3S+mLMm7rwI0iPuRwDnTZwZaXcUQH6evcRY/g/GmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8rHSl4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8rHSl4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92A4C2BD10;
	Thu,  6 Jun 2024 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682984;
	bh=/UeY7yp0zQKpOAvtnsISmvFmcRwkblFv25Bsk9OqMAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8rHSl4vSblArr9mZphj9YMijzDKvmUj7MPO4AECyXFgMARCAlDL4EtaSS+7loD5h
	 znrFHTBW/tCYsMQ24coYB24wOcZH83oELW0bTcM7p09oej3hviYtbVplyTRdGWO2BH
	 rOo7oJcUUezkr3gq3FoPTtHU1LgJ9pRGIBrTO/oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 170/374] fs/ntfs3: Check folio pointer for NULL
Date: Thu,  6 Jun 2024 16:02:29 +0200
Message-ID: <20240606131657.591431135@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1cd6c96219c429ebcfa8e79a865277376c563803 ]

It can be NULL if bmap is called.

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index ba5a39a2f957d..90d4e9a9859e4 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -577,13 +577,18 @@ static noinline int ntfs_get_block_vbo(struct inode *inode, u64 vbo,
 	clear_buffer_uptodate(bh);
 
 	if (is_resident(ni)) {
-		ni_lock(ni);
-		err = attr_data_read_resident(ni, &folio->page);
-		ni_unlock(ni);
-
-		if (!err)
-			set_buffer_uptodate(bh);
+		bh->b_blocknr = RESIDENT_LCN;
 		bh->b_size = block_size;
+		if (!folio) {
+			err = 0;
+		} else {
+			ni_lock(ni);
+			err = attr_data_read_resident(ni, &folio->page);
+			ni_unlock(ni);
+
+			if (!err)
+				set_buffer_uptodate(bh);
+		}
 		return err;
 	}
 
-- 
2.43.0



