Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB8F29D26A;
	Tue, 26 Aug 2025 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207520; cv=none; b=QRA8QYyU82oxKo/LBaqKkps7NEeW0YG7khkfpEQNq4ltWIMMjsWNFRL5O3P/egIz+rklD61uiw7O0hpuSoWNTvbzZAsGdhEeM82cO9XrR6fD3cR/c4WBxLZcPdfgX/+TDnAtaiR0VVEXKU/wwRbAMqsUhL8a5XnqN3xNSU0GgMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207520; c=relaxed/simple;
	bh=n8RP4xWxLKNzgtJkLhjyAbXmwCBTdvXw/N5kSfJDKzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmpsV9cFEyyqc8ufm6yPkrEX7DTEsBJWl+8RYF+++bih6fdjvUui1L+Rc8TXazodyyT9T8ASzvgTAFZ4BJfRdwhU5sItwwkg3oIin6Xqtz4b1IUrTjKfHWGSsvbhHD+BGTha5M7jeMI4hayMDea9CLcttRPnkYqkVbL6AMoxDjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLNjxJb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLNjxJb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1ADC4CEF1;
	Tue, 26 Aug 2025 11:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207520;
	bh=n8RP4xWxLKNzgtJkLhjyAbXmwCBTdvXw/N5kSfJDKzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLNjxJb69DioDV/gHOlI7CA94CSCNQYIUVN3AEvW4kBdOhD9pDqh45qiLW/eKnTo1
	 FZl9bzWzgIcVD7d3uG+ED+k4KqjUFViOfN8VulhyyMD5hb2bFifyfkGiekry5gfYQa
	 9QVdveHHdqHwDSlLr6WPPLgp/GjTtQmG6fOcGP9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 212/457] btrfs: move transaction aborts to the error site in add_block_group_free_space()
Date: Tue, 26 Aug 2025 13:08:16 +0200
Message-ID: <20250826110942.601789080@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit b63c8c1ede4407835cb8c8bed2014d96619389f3 ]

Transaction aborts should be done next to the place the error happens,
which was not done in add_block_group_free_space().

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 1f06c942aa70 ("btrfs: always abort transaction on failure to add block group to free space tree")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-tree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1456,16 +1456,17 @@ int add_block_group_free_space(struct bt
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
+		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 
 	ret = __add_block_group_free_space(trans, block_group, path);
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
 
 out:
 	btrfs_free_path(path);
 	mutex_unlock(&block_group->free_space_lock);
-	if (ret)
-		btrfs_abort_transaction(trans, ret);
 	return ret;
 }
 


