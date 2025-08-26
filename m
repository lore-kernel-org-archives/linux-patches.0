Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B270252904;
	Tue, 26 Aug 2025 13:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213772; cv=none; b=ln/haxWr2U54X7hiHBEIOe3XQZdwpLIVjqJnFDcUyYz4ga7GDKgCc/Lyc8af71sMnL7EIBCYTPyREibdb3fqznjfDCsr+1QSKsTbRbpxzcw3x3Z512Fz6qT33LDVodc0sEiIkl0nqFSHTBDIQEb0DrDZnBxpooshu2crxqjHecc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213772; c=relaxed/simple;
	bh=YeTN1meIwo4zd0PBATG/yy42ZnvbRBhbxIZSEZ/PjHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No9VZW96HSNVYJbLPv4ys3Q+rgmiX7WE1AY1omu0pOP0NJ78mbR4lIgI0U//4DJ3SpjVadC9P1/w/4s7atjBFF/DJrBxL7omt9zAv1rz90XeWM+Tgn8/dLXCOEbobQaNapH2aUZYD7XQc1F0vPXTjk0j33qeLcTcJf1LRIqrHYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XL+ncWYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XL+ncWYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C256C4CEF1;
	Tue, 26 Aug 2025 13:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213772;
	bh=YeTN1meIwo4zd0PBATG/yy42ZnvbRBhbxIZSEZ/PjHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XL+ncWYxNfHq3kCsCCwENHOEK/A/A2xvBrJu0Hx8IKaf1EsKfa+/e4V2rJlM9ByQL
	 BuP+W7sVmy7y0qYH/DMSoKeUYnx7rXcc7uHUwkyd1asjBimJcUCGIt2lJIk/TRfFu0
	 ueJoUMyqc4pFyQ2hW6ORfROIssxD6GtHZ0n7piRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 446/587] btrfs: move transaction aborts to the error site in add_block_group_free_space()
Date: Tue, 26 Aug 2025 13:09:55 +0200
Message-ID: <20250826111004.302516083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1396,16 +1396,17 @@ int add_block_group_free_space(struct bt
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
 


