Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101387474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FE0C433D2;
	Tue, 10 Jan 2023 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374416;
	bh=UmmP9nAoiVGcDPOobEbHkraUxstIymo9uKKeIwU19sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2CLHe+WtsajIIY0gipBgKof8XhjIC8KGxuDlVcSMndCRtSWOsolTO1C5KVto0/QLh
	 a3QgL3WlCihsV4r4/HRt1McVlHP7+jNC2mAgJcvlAhm0/UrycbwiY0+BOWsZimfvg2
	 jYEy1UE8DsQyW2GDmzoZZ8oo0w335Jz3oQOwzxJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/159] btrfs: fix an error handling path in btrfs_defrag_leaves()
Date: Tue, 10 Jan 2023 19:02:39 +0100
Message-Id: <20230110180018.667808652@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit db0a4a7b8e95f9312a59a67cbd5bc589f090e13d ]

All error handling paths end to 'out', except this memory allocation
failure.

This is spurious. So branch to the error handling path also in this case.
It will add a call to:

	memset(&root->defrag_progress, 0,
	       sizeof(root->defrag_progress));

Fixes: 6702ed490ca0 ("Btrfs: Add run time btree defrag, and an ioctl to force btree defrag")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-defrag.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index b6cf39f4e7e4..072ab9a1374b 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -31,8 +31,10 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		goto out;
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	level = btrfs_header_level(root->node);
 
-- 
2.35.1



