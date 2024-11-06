Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFC11DF726;
	Wed,  6 Nov 2024 12:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895706; cv=none; b=XygkU/W6AYqr21gGcR3cCVqHmC+h0EgEQ8fgwotbg1Gxe6Yvm1P8oP+aZb10Mwk5rAsoDNEczajJM0ggqUFIdSlVX1EHXFpJv8b144ejlUlOYnsjfaLJNxJiUgaf4aFXVPvhPe3zz+lTGsddgsLS09D/6a8DQQyilJhiKTVA75U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895706; c=relaxed/simple;
	bh=PpGtntJUgGvIhBY4hSye9TjEjMxI5J7EIRm1dnT+r6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEBo2dJxQlz4Kb/pHRA3Xm099pPgfEFf5bRs6Fksg5HHGEMQpo4QP340S53EcHgfxjFlX/NsPzsGmxcAdpq3DEoswdtXoa6FSNcLf2keGbb88XDogD0uFYuaPfcfB09dcLdQRgZ9xMt+gNvQEps4iPi08O5dKEoyfLa+mAiNCSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLG5EoLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLG5EoLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24023C4CECD;
	Wed,  6 Nov 2024 12:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895706;
	bh=PpGtntJUgGvIhBY4hSye9TjEjMxI5J7EIRm1dnT+r6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLG5EoLLI0Ik6gfiZU3HYQb5KdPDP8/6c1ClosgypyXI674kPfRg6uEJH2Gc2wcNC
	 ZtBDzzVKiaqC+4ZILJXu6IQrmJUVy5fGW7c0wGZCUn76D7Av/7rScuCHWGqTq0WN8T
	 cm/+fCJZVO0+5bciRWvtJFW8Pd+aO6AwqPim6mCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.com>,
	Gianfranco Trad <gianf.trad@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 308/350] udf: fix uninit-value use in udf_get_fileshortad
Date: Wed,  6 Nov 2024 13:03:56 +0100
Message-ID: <20241106120328.389200169@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianfranco Trad <gianf.trad@gmail.com>

[ Upstream commit 264db9d666ad9a35075cc9ed9ec09d021580fbb1 ]

Check for overflow when computing alen in udf_current_aext to mitigate
later uninit-value use in udf_get_fileshortad KMSAN bug[1].
After applying the patch reproducer did not trigger any issue[2].

[1] https://syzkaller.appspot.com/bug?extid=8901c4560b7ab5c2f9df
[2] https://syzkaller.appspot.com/x/log.txt?x=10242227980000

Reported-by: syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8901c4560b7ab5c2f9df
Tested-by: syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com
Suggested-by: Jan Kara <jack@suse.com>
Signed-off-by: Gianfranco Trad <gianf.trad@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240925074613.8475-3-gianf.trad@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 08d7208eb7b75..76bb8be01b8d9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2166,12 +2166,15 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
 		alen = udf_file_entry_alloc_offset(inode) +
 							iinfo->i_lenAlloc;
 	} else {
+		struct allocExtDesc *header =
+			(struct allocExtDesc *)epos->bh->b_data;
+
 		if (!epos->offset)
 			epos->offset = sizeof(struct allocExtDesc);
 		ptr = epos->bh->b_data + epos->offset;
-		alen = sizeof(struct allocExtDesc) +
-			le32_to_cpu(((struct allocExtDesc *)epos->bh->b_data)->
-							lengthAllocDescs);
+		if (check_add_overflow(sizeof(struct allocExtDesc),
+				le32_to_cpu(header->lengthAllocDescs), &alen))
+			return -1;
 	}
 
 	switch (iinfo->i_alloc_type) {
-- 
2.43.0



