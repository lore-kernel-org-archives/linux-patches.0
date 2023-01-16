Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875D16FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF34C433D2;
	Mon, 16 Jan 2023 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889328;
	bh=Y1lPqm4UJmZvsKkiZ++l6lYE2elJaGIuvgnIKAdSkUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bctT8vAY6gYfnw6dxiEh1K5K8z/S68bYtX3aX3rUncKQAqkKJY2TOuH2mb6GtcvUY
	 S+2isrojhYj3Z/kJ+w/8KT2MgU1UqkgOd8fizEIAJzBJRwsJWGOwJTpP4ps0PacTVV
	 dFRddoEkxUwzPFbA6dKBA4dW8PTrzPjRJRgrkD5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 316/338] udf: Fix extension of the last extent in the file
Date: Mon, 16 Jan 2023 16:53:09 +0100
Message-Id: <20230116154834.902986648@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index 0c80788cc429..2da65989ae5d 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -595,7 +595,7 @@ static void udf_do_extend_final_block(struct inode *inode,
 	 */
 	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
 		return;
-	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
+	added_bytes = new_elen - (last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
-- 
2.35.1



