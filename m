Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4332379C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74E2C433EF;
	Thu, 12 Jan 2023 14:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534286;
	bh=u9hCgZ2AXcHETWOnuScc0sFsv5s87jus7O6Xu+JnTf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4s+3GVwNUgBVDz17MA+mrE1Pq2bUcTZXBmmAqpybRT2yTV5TdIqR4Xb7d/qUY2hb
	 taenXGVtayAYNUUYFPRY1plU19JxrtWmgF3UIFKWeI6wJPhFDitH0uZlXPrGVIToZW
	 M3Sy1aM6McoBHTnSnGSAwyuutbNst5YPq3ydPG2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 757/783] udf: Fix extension of the last extent in the file
Date: Thu, 12 Jan 2023 14:57:53 +0100
Message-Id: <20230112135559.451839002@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 83c7423d1eb6806d13c521d1002cc1a012111719 ]

When extending the last extent in the file within the last block, we
wrongly computed the length of the last extent. This is mostly a
cosmetical problem since the extent does not contain any data and the
length will be fixed up by following operations but still.

Fixes: 1f3868f06855 ("udf: Fix extending file within last block")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index e94a18bb7f99..2132bfab67f3 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -599,7 +599,7 @@ static void udf_do_extend_final_block(struct inode *inode,
 	 */
 	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
 		return;
-	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
+	added_bytes = new_elen - (last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
-- 
2.35.1



