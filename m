Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B33F14831F;
	Tue, 30 Jul 2024 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358087; cv=none; b=hhF0SGoMBdGqABOWDgN94gFTzuOnRysCt6gyZeE88leSWB4jOdgX8L8PsQpU0s51NIjBhCMym7TXtij3O8l+m8rPoyNrraFExemizMV4drG3r3Afg+6ulVCdBF9YFlHkuYML3ZzYfoljljjtZBfnOHv20uKh7kUnzaNj/Xt0azM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358087; c=relaxed/simple;
	bh=JT31WtKjCxAQbZMHxPXdlij/5FWqyQiHH+oQBjAoHLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+1zrVAP4zW/z5/7Y2OvTiBsR7pWLsdl/CF60wC0JWmas1psRoK6zRS2J1sGf2xyawSENtjVOHYzNqeSQPgBspDuu68+0u+YL23Ea/RWnyXpbH7ep15uI0LDR9Chahw2mvGBep1a0Glexv+UmN8wy1LHW5+QIlP560KhLDA+91E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haLK8irK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haLK8irK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F76C4AF0E;
	Tue, 30 Jul 2024 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358087;
	bh=JT31WtKjCxAQbZMHxPXdlij/5FWqyQiHH+oQBjAoHLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haLK8irK1Hd4AZTnc2Zkc++XXBd0XD+UpZoaMJDaKLiDK8OOS2oScTiOWp28adeFr
	 QTG+cVtvZ3dLDO1Jzzua7GmFB3mkOYlJ2gFlUnBnYJB7jUAVfqDI2KvTD9Xn5tItrd
	 3aJOEstux0UOALCpqXjiv0etcQMjoiga4HuEOf+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 324/568] fs/ntfs3: Add missing .dirty_folio in address_space_operations
Date: Tue, 30 Jul 2024 17:47:11 +0200
Message-ID: <20240730151652.539696774@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 0f9579d9e0331b6255132ac06bdf2c0a01cceb90 ]

After switching from pages to folio [1], it became evident that
the initialization of .dirty_folio for page cache operations was missed for
compressed files.

[1] https://lore.kernel.org/ntfs3/20240422193203.3534108-1-willy@infradead.org

Fixes: 82cae269cfa95 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index fab86300eb8a2..86ade4a9ec8f3 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -2117,5 +2117,6 @@ const struct address_space_operations ntfs_aops = {
 const struct address_space_operations ntfs_aops_cmpr = {
 	.read_folio	= ntfs_read_folio,
 	.readahead	= ntfs_readahead,
+	.dirty_folio	= block_dirty_folio,
 };
 // clang-format on
-- 
2.43.0



