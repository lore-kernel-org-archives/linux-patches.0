Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BBE320CDB;
	Mon, 18 Aug 2025 13:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523096; cv=none; b=AAuskx023Ousn+XNJQoP+IoBVDQmmEXR+azNCKLBB0EdLdXa1jaNcW9u4VpmawKeZhFDKrxToaL5KPOhUCcAs72HruiOPzuTkvItQFUvezKLxhnnv49c3cKfwBF/cLMUn+XgmosuOGFnbScNh7gIdz0dmEvZV/IcOLZv3nm4ULo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523096; c=relaxed/simple;
	bh=k9R5dw89WnMdRXi1D3XsR0HuyWVts8VVe+Bk5xo2olw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThT8HbIuRpKE9pkxUmWap84mcn5XEb5dMgNLLPB92Rgilt5SChSvXZYTNyCNLMb70LwBvOHdsZTXzVLN3J4huVr4WkVfp8xFQCej50zyDG2PXJgC5+tNo83yJWKbX5nJL20TpOnyvr7dZVRgy+OiCLGbY4QRtqIBNGaIpXvtgJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukHWDEpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukHWDEpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25206C113D0;
	Mon, 18 Aug 2025 13:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523096;
	bh=k9R5dw89WnMdRXi1D3XsR0HuyWVts8VVe+Bk5xo2olw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukHWDEpO+UjWN3hFSMJ1syRTDGari92/WmUehAgxQKYf4uBsLCbQxmEBa7W1UdzAj
	 kw0qgzdcW0ybrm92Gffhfy6Qdg4A85w9kKXXE1pGfGiajwwf9aCP45kty2vNK+E6C0
	 0LzyLwyhMe13M0Zo/+GMGZBG9mQ3hrZyYkVGTJu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 069/515] erofs: fix block count report when 48-bit layout is on
Date: Mon, 18 Aug 2025 14:40:55 +0200
Message-ID: <20250818124501.051577161@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 0b96d9bed324a1c1b7d02bfb9596351ef178428d ]

Fix incorrect shift order when combining the 48-bit block count.

Fixes: 2e1473d5195f ("erofs: implement 48-bit block addressing for unencoded inodes")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250807082019.3093539-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 6e57b9cc6ed2..cfe454dbf415 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -313,8 +313,8 @@ static int erofs_read_superblock(struct super_block *sb)
 	sbi->islotbits = ilog2(sizeof(struct erofs_inode_compact));
 	if (erofs_sb_has_48bit(sbi) && dsb->rootnid_8b) {
 		sbi->root_nid = le64_to_cpu(dsb->rootnid_8b);
-		sbi->dif0.blocks = (sbi->dif0.blocks << 32) |
-				le16_to_cpu(dsb->rb.blocks_hi);
+		sbi->dif0.blocks = sbi->dif0.blocks |
+				((u64)le16_to_cpu(dsb->rb.blocks_hi) << 32);
 	} else {
 		sbi->root_nid = le16_to_cpu(dsb->rb.rootnid_2b);
 	}
-- 
2.50.1



