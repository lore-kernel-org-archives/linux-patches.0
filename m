Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B16017E01C;
	Sun,  1 Sep 2024 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207652; cv=none; b=gxVRC7mce9jvCB5C6YlUk4oAD5XsfzgLBTwoDIEBIVQ9p5rGp6jTlS6q5fEX0pmIXBLLgG4pBfJg9+HV9deeML1QYlZRyn5j8JebWRXHU23GdUMnML8CvudZ12eOqXDNjGvSNc847IA1j/+V45DNdGeAtzOiWNnOHd1dZHX5K6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207652; c=relaxed/simple;
	bh=hPfffHJe+UY2pevyINT9srx/Zakw3X43IBlS+B0p83E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zn/bIljw4F9gogwAWWdj6Ssx4S1OLnPPzrP5s9l/b4813brrnXfrhtOqNybOXbUN6e/eYKQQBS0gW0clOTpYEysA5/JOipseI9rIg5JdJyOLh7FEbBARdzsT7ntng+qgLJLyMcIxouiWaSOYNBk73zwT4l/kbr63BGu9C6gacmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJsQI3os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJsQI3os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F260C4CEC3;
	Sun,  1 Sep 2024 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207651;
	bh=hPfffHJe+UY2pevyINT9srx/Zakw3X43IBlS+B0p83E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJsQI3osEezpwq00dcGt3CPyOCu2bw0vUGhvw1VWDCi48ckN0dNwzpoULSRTv1qx0
	 eeGsLljsADZhZbYu9f5Q6GR8UzVNyz6nZXeiATiZ8R/AtvXUkRapUd340EnG9OgKXf
	 31osg/UTM3A0eXKxCslhSzK5igZEYEhcWWmLhEpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 37/98] btrfs: handle invalid root reference found in may_destroy_subvol()
Date: Sun,  1 Sep 2024 18:16:07 +0200
Message-ID: <20240901160805.098421493@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 6fbc6f4ac1f4907da4fc674251527e7dc79ffbf6 ]

The may_destroy_subvol() looks up a root by a key, allowing to do an
inexact search when key->offset is -1.  It's never expected to find such
item, as it would break the allowed range of a root id.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7f675862ffb0e..15ebebed40056 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4296,7 +4296,14 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 	ret = btrfs_search_slot(NULL, fs_info->tree_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
-	BUG_ON(ret == 0);
+	if (ret == 0) {
+		/*
+		 * Key with offset -1 found, there would have to exist a root
+		 * with such id, but this is out of valid range.
+		 */
+		ret = -EUCLEAN;
+		goto out;
+	}
 
 	ret = 0;
 	if (path->slots[0] > 0) {
-- 
2.43.0



