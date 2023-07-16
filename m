Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B8F8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF33C433C7;
	Sun, 16 Jul 2023 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540879;
	bh=WQcKjjLYlKbnUYpXszo2uOPFLgRuV0gEoPpcSOmMR4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNfSLL8aEhphMf6kARQdGqfFTjh7usVpFblPrDPP+qzYZ2YwzN5ky5QMTLhJfmY0A
	 WREgYydVKCpvnmw84tJX5+L8HEXFSZmI8kH3QH+c2Bpz6xgnrus1pCnrWetwUhG5PB
	 gFCpYN/kfQ9FdXFyme9fAVD7SUpeXUpVWqUbgul8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 493/591] f2fs: fix error path handling in truncate_dnode()
Date: Sun, 16 Jul 2023 21:50:32 +0200
Message-ID: <20230716194936.647254875@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0135c482fa97e2fd8245cb462784112a00ed1211 ]

If truncate_node() fails in truncate_dnode(), it missed to call
f2fs_put_page(), fix it.

Fixes: 7735730d39d7 ("f2fs: fix to propagate error from __get_meta_page()")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 07419c3e42a52..a010b4bc36d2c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -941,8 +941,10 @@ static int truncate_dnode(struct dnode_of_data *dn)
 	dn->ofs_in_node = 0;
 	f2fs_truncate_data_blocks(dn);
 	err = truncate_node(dn);
-	if (err)
+	if (err) {
+		f2fs_put_page(page, 1);
 		return err;
+	}
 
 	return 1;
 }
-- 
2.39.2



