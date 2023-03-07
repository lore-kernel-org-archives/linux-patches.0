Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900DDBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9266C433D2;
	Tue,  7 Mar 2023 17:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211268;
	bh=NQTrk7Pbj2lZODfbiKy7tAdSNx9l/MqrGk+tW0NhhcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQeAD80Jof9lvGI01/Iq85lguE132sBIRdr83gNsK0aKR/kMHpZUTDMtFr0xJi8N6
	 ZF4jbN07v4W6hzhJpq7AjwhQfnkjm4sOB0QplZm9PsyEURFBPTZXC5k+bDHja9nmW1
	 Th7RBlIkFYvJFe4u/Q2lCVvmqF3toQeIDtB5fiFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.2 0808/1001] f2fs: Revert "f2fs: truncate blocks in batch in __complete_revoke_list()"
Date: Tue,  7 Mar 2023 17:59:40 +0100
Message-Id: <20230307170056.800444640@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit c7dbc06688292db34c1bb9c715e29ac4935af994 upstream.

We should not truncate replaced blocks, and were supposed to truncate the first
part as well.

This reverts commit 78a99fe6254cad4be310cd84af39f6c46b668c72.

Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -262,19 +262,24 @@ static void __complete_revoke_list(struc
 					bool revoke)
 {
 	struct revoke_entry *cur, *tmp;
+	pgoff_t start_index = 0;
 	bool truncate = is_inode_flag_set(inode, FI_ATOMIC_REPLACE);
 
 	list_for_each_entry_safe(cur, tmp, head, list) {
-		if (revoke)
+		if (revoke) {
 			__replace_atomic_write_block(inode, cur->index,
 						cur->old_addr, NULL, true);
+		} else if (truncate) {
+			f2fs_truncate_hole(inode, start_index, cur->index);
+			start_index = cur->index + 1;
+		}
 
 		list_del(&cur->list);
 		kmem_cache_free(revoke_entry_slab, cur);
 	}
 
 	if (!revoke && truncate)
-		f2fs_do_truncate_blocks(inode, 0, false);
+		f2fs_do_truncate_blocks(inode, start_index * PAGE_SIZE, false);
 }
 
 static int __f2fs_commit_atomic_write(struct inode *inode)


