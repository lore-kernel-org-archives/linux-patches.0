Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124542ED868;
	Tue, 17 Jun 2025 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178282; cv=none; b=dEla1YPpAfsxjspNkJ/ZhENVdTls/GsPMQDW21i/pYCvh3WcLhMiu2qPqtL3uVByazOTJG/n2Ndd4bVskwLhXQKc/tIULwrPjCplmDasEw6gTYkSeiDxFBbT5xJEdSG/ZZToYzTqpqdrSsgKbRHo86MZyRSU++W9H0u9MVPtO0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178282; c=relaxed/simple;
	bh=5dcjVnaOMSLjgICac2xpXr26VhbFfxrE9Z+0E+IwO5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MijQxxBQvVQKpEg65GCezbnOMNIqk2f+DPb6lA9jHE4o7OJZWfWfoKyvzjLGKzuugf2YlDprYSXPH0elMdZ/sky9T1bbuadk+GRcYklZ17QTkxCMFC6fVN0n8pc6uzMZUWoQfrSBBG4pF0I+O693nYh73fsibsvvdgPWGr+EqeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhEZJsRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhEZJsRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCA5C4CEE3;
	Tue, 17 Jun 2025 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178281;
	bh=5dcjVnaOMSLjgICac2xpXr26VhbFfxrE9Z+0E+IwO5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhEZJsRqCY9xDmef0QQhTfoEOclxsQkA4CWz2DiysV+d3kFT2GIWgv0//hfhoIap/
	 SdDZB6tfcbkg723RRkF9UpMlA/UflTZz0j8ZqwKXtuKNiAPtUUpkKzPwvOZs7e8Fz2
	 LTOOVfrGxL1+is0vNbDjgwtURAORAaXioE29upZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 473/512] btrfs: exit after state split error at set_extent_bit()
Date: Tue, 17 Jun 2025 17:27:19 +0200
Message-ID: <20250617152438.743500412@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 41d69d4d78d8b179bf3bcdfc56d28a12b3a608d2 ]

If split_state() returned an error we call extent_io_tree_panic() which
will trigger a BUG() call. However if CONFIG_BUG is disabled, which is an
uncommon and exotic scenario, then we fallthrough and hit a use after free
when calling set_state_bits() since the extent state record which the
local variable 'prealloc' points to was freed by split_state().

So jump to the label 'out' after calling extent_io_tree_panic() and set
the 'prealloc' pointer to NULL since split_state() has already freed it
when it hit an error.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-io-tree.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index bb3aaf610652a..5f9a43734812e 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -1252,8 +1252,11 @@ static int __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		if (!prealloc)
 			goto search_again;
 		ret = split_state(tree, state, prealloc, end + 1);
-		if (ret)
+		if (ret) {
 			extent_io_tree_panic(tree, state, "split", ret);
+			prealloc = NULL;
+			goto out;
+		}
 
 		set_state_bits(tree, prealloc, bits, changeset);
 		cache_state(prealloc, cached_state);
-- 
2.39.5



