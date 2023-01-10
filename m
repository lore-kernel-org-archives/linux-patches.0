Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D547474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2FCC433EF;
	Tue, 10 Jan 2023 18:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375594;
	bh=A/ExnhSVHK7qignorG62La22hdVT0sMzzctwBDzImmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s46YpNymQ0tnKcMEhF8TsuBVhYeugQTflKg8G2+BWfZBXwZRPgslX2Y8NPrdZMAQp
	 8CSeIuFXLxl6yTgBqavSQ++AySdXLRgZTjwnK2UpaYaL0VyXNI7znECSwBt+75/iBg
	 VckWnVWMIPb/vpkm2ppGfXoWVQVaOzaZFN3W+o9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/290] btrfs: fix an error handling path in btrfs_defrag_leaves()
Date: Tue, 10 Jan 2023 19:04:50 +0100
Message-Id: <20230110180038.799192375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
index 7c45d960b53c..259a3b5f9303 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -39,8 +39,10 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
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



