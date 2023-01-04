Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1ABAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42288C433D2;
	Wed,  4 Jan 2023 16:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849564;
	bh=e12YwFE/LXc//Urf9Kqw6v3aUMtZNMZdauPRnVpDfu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jG3NgR6f52KANnX2E0n4C1J/GG1ai18Qc/mrQwY/UnmqwR54/u2Mg6TspnjviSGQ+
	 tvRT1//k9TfNkIU0xD1I32UJuYuZougT3XbCPYzazSx9quownD7g+iLTBLXRfcfQm/
	 For/Q8/oIp69frRC6VXINlIIqhzYJUmcdEjxlD4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.0 143/177] ext4: check and assert if marking an no_delete evicting inode dirty
Date: Wed,  4 Jan 2023 17:07:14 +0100
Message-Id: <20230104160511.994571109@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Yi <yi.zhang@huawei.com>

commit 318cdc822c63b6e2befcfdc2088378ae6fa18def upstream.

In ext4_evict_inode(), if we evicting an inode in the 'no_delete' path,
it cannot be raced by another mark_inode_dirty(). If it happens,
someone else may accidentally dirty it without holding inode refcount
and probably cause use-after-free issues in the writeback procedure.
It's indiscoverable and hard to debug, so add an WARN_ON_ONCE() to
check and detect this issue in advance.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220629112647.4141034-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -335,6 +335,12 @@ stop_handle:
 	ext4_xattr_inode_array_free(ea_inode_array);
 	return;
 no_delete:
+	/*
+	 * Check out some where else accidentally dirty the evicting inode,
+	 * which may probably cause inode use-after-free issues later.
+	 */
+	WARN_ON_ONCE(!list_empty_careful(&inode->i_io_list));
+
 	if (!list_empty(&EXT4_I(inode)->i_fc_list))
 		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */


