Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C60C4F7CD1;
	Thu, 17 Sep 2026 16:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663973; cv=none; b=ZunP3eEXzVltxgpE7lRUPv54UhyMqkYlEUDlfbBak9zaqc/cNzU237QfRtgST6zGrGVuCQNk13MCBjmeBh7L5EEozCxcwc8r0LMobYtO+iNkieoz3Adwwrs7ZiADr5AQeLlXdMMYJPkgEQPhfLWRqt8n6EiC7Qbewu/SVfyK/FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663973; c=relaxed/simple;
	bh=3kczqoL/VO5W8yh84DVz11MEtnSCLuUx4bqQkcjxIKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQw4HjmH7rAxWbg+WU7PSIlYHfZPD5Fa/T1TFhqHskm/ReXXd8nCYjOykjX7Ez+JmdX9zOwYojODjz6RMEdevBiaESIujSkeknujaTLdXqyAiQ+RqYcQ7m3CCeMA+Bmpc26TDqtrzPytxK8LGOrONVfVIP/66Z9pVvUnfj4q2ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbX2uH4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbX2uH4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F531F000FF;
	Thu, 17 Sep 2026 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663972;
	bh=Do34lkNzKTrF/G3CRgWn13037PzrCly7TQS07vYzlqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbX2uH4zlYxMcYA+jEz6tbUQ9sNJ/6m1s61MeJCNk7G2tmRW3GldgRD3uhagAM4Os
	 EXE2y0tKknxM35+GpBYR4k2CsNhIQ2Ob58gs9JRF6heWs0I+rI1pmXE8CpierNNPDT
	 5WyNX3LAfhnbnuHobmTIcjmZnAYSs/Fbgv9PoR5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0178/1250] minix: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:33 +0100
Message-ID: <20260917151556.930789491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 38a03dc2bc71e7e0746cdb9ef5e9947f72470c67 ]

minix uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-9-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 7bdd240ea1584..5bfe42599a585 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -272,7 +272,8 @@ static int minix_fill_super(struct super_block *s, struct fs_context *fc)
 		sbi->s_namelen = 60;
 		sbi->s_version = MINIX_V3;
 		sbi->s_mount_state = MINIX_VALID_FS;
-		sb_set_blocksize(s, m3s->s_blocksize);
+		if (!sb_set_blocksize(s, m3s->s_blocksize))
+			goto out;
 		s->s_max_links = MINIX2_LINK_MAX;
 	} else
 		goto out_no_fs;
-- 
2.53.0



