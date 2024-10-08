Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4C8183CB8;
	Tue,  8 Oct 2024 12:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391627; cv=none; b=O+3lBxphAkysbO18Xu1Z9ZiBj86q+raZyOwfkCxclhZV0Q5rkIwPcQPuB8cPUcM8xWypNqxVpOsoayoM+EyxPuXZ6a3WsvVfdXwK+UrsQ+NZTgU+NoExIm/RtiQOKlm9En/l4rWwe88ypXzE+VJ+CPFW0azchv2BKrdffN6dP8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391627; c=relaxed/simple;
	bh=4eYkAgSSSi4FSEN99sK6I417O2HDXW2YKeAsX/2V+JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfbqZigdh8aRETw/rhZmRqI8NFHGEshNA2RyRcbL/Wqk+uVIwnRh27QZuWQFd7G1O6Ym/nlopnsu32w87WgbcZDi9bQB3OVdR9nvH6qbmH9ND3Pgb/8Walx8O2WKfnDIz2nf0xHGYSGT+hbY1LkeejxjWquWpjC56CVF+JTGPPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8sNasFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8sNasFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F09BC4CEC7;
	Tue,  8 Oct 2024 12:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391627;
	bh=4eYkAgSSSi4FSEN99sK6I417O2HDXW2YKeAsX/2V+JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8sNasFnQRP41ApWeFFuzo84kMxwvlr2TwwJsxzUaFLzW/o2TT6UvfMwGxZqMZSRd
	 7jeXBmH+SRcvGaNSZygXzJstLYh/jYeQMrTIHSiQkGx4r8mwaKVPNoPuIjw1c6G8JT
	 n1DNS8Ts/S6A/aXcZBP4Lf9cfItkF+6kIkLdFWls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 144/558] vfs: use RCU in ilookup
Date: Tue,  8 Oct 2024 14:02:54 +0200
Message-ID: <20241008115708.030320901@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit 122381a46954ad592ee93d7da2bef5074b396247 ]

A soft lockup in ilookup was reported when stress-testing a 512-way
system [1] (see [2] for full context) and it was verified that not
taking the lock shifts issues back to mm.

[1] https://lore.kernel.org/linux-mm/56865e57-c250-44da-9713-cf1404595bcc@amd.com/
[2] https://lore.kernel.org/linux-mm/d2841226-e27b-4d3d-a578-63587a3aa4f3@amd.com/

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/r/20240715071324.265879-1-mjguzik@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 551ba352072fa..30d42ab137f0a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1578,9 +1578,7 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
 	struct hlist_head *head = inode_hashtable + hash(sb, ino);
 	struct inode *inode;
 again:
-	spin_lock(&inode_hash_lock);
-	inode = find_inode_fast(sb, head, ino, true);
-	spin_unlock(&inode_hash_lock);
+	inode = find_inode_fast(sb, head, ino, false);
 
 	if (inode) {
 		if (IS_ERR(inode))
-- 
2.43.0



