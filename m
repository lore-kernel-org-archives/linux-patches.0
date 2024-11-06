Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0991E00B0;
	Wed,  6 Nov 2024 13:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898935; cv=none; b=NIjDAtjYASiEybvLKtkj+rKr6Hh4c45YMS/j+7ihrQGvhwt8T/WosamvilfFyG0DkFDhgrVoMPPjeoblrbvKxWR/0+jTet6RWlsYZq31ECsCIsy4RStKBXqhOc+4+2bZeoaCU7Gry/NwooPU/W4uXZC8+YQBKCgBBLUIKZF8kl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898935; c=relaxed/simple;
	bh=UCC3Wf3XuguOimEMlDb1iSIts23cd4tdQOjI4a6gQ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHfjJ5rre1eOzIDXEYNpHjxHLX/IU/jGSBZeVixLEo21uyFPl+mlJUNKLBflqQhYjRRlkDvOvY6KDVlX0gPB0Z6eaxTKmSt4oLMccw3y6vV3XRWYahlunK4k6SkdpROl4DKlDIpfGJ7hjZISW6B+R4SdIgkdcEN6qQ0tnha/HGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V32p1JFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V32p1JFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9983C4CECD;
	Wed,  6 Nov 2024 13:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898935;
	bh=UCC3Wf3XuguOimEMlDb1iSIts23cd4tdQOjI4a6gQ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V32p1JFnilul/D1j5s1tpwuaCdyF+M+flXfnGWMAGI38ggWM/qCcjhFvyhUePTh4h
	 aMASze6BUMc/gAeF+8FFnCe7ouEbcl7HnJUsA8AHs2KbjLDLiblhAjo4Kg0r00CVn4
	 f7DRsR7h7MTFq0lmzXUdJJ0pDTXkLwwsh4VVq6GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8901c4560b7ab5c2f9df@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.com>,
	Gianfranco Trad <gianf.trad@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 405/462] udf: fix uninit-value use in udf_get_fileshortad
Date: Wed,  6 Nov 2024 13:04:58 +0100
Message-ID: <20241106120341.525331004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fef6e5e06e3f2..7d878e36759b2 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2193,12 +2193,15 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
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



