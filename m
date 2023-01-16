Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AE06FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC12C433D2;
	Mon, 16 Jan 2023 16:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888142;
	bh=ha/GU8zL0yqiZe7iwjBBmsiuYifTan2l3mkCgXcyR8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFyNkyYu3Pcltbao7Tx6ocUPldWj5OPqPf5CdBd6f7evfiZ7MgzXpTHMw+YZ+7fNB
	 Ad83D4ZF21lVgkAlvg2C7BHhXz6eLYGbBWryJ34hOTbbDzE1UiZ7285ASmCOYgawWs
	 XYbGuDv1jNt1btIS2Wr9LQLFyFNDfl0aSNOFFNKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Jan Kara <jack@suse.cz>,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 416/521] ext4: avoid unaccounted block allocation when expanding inode
Date: Mon, 16 Jan 2023 16:51:18 +0100
Message-Id: <20230116154905.724097015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

commit 8994d11395f8165b3deca1971946f549f0822630 upstream.

When expanding inode space in ext4_expand_extra_isize_ea() we may need
to allocate external xattr block. If quota is not initialized for the
inode, the block allocation will not be accounted into quota usage. Make
sure the quota is initialized before we try to expand inode space.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/all/Y5BT+k6xWqthZc1P@xpf.sh.intel.com
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20221207115937.26601-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6041,6 +6041,14 @@ static int __ext4_expand_extra_isize(str
 		return 0;
 	}
 
+	/*
+	 * We may need to allocate external xattr block so we need quotas
+	 * initialized. Here we can be called with various locks held so we
+	 * cannot affort to initialize quotas ourselves. So just bail.
+	 */
+	if (dquot_initialize_needed(inode))
+		return -EAGAIN;
+
 	/* try to expand with EAs present */
 	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
 					   raw_inode, handle);


