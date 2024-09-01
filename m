Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B8717CA1F;
	Sun,  1 Sep 2024 16:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209631; cv=none; b=Ui6VtQmBhkfki/wxioE9Uc5F0zxq1VwJht3PEdQcQ50WTuN2RXvN8lPXjogq+l/yLEmgmiXDwNN/mNxT3Mt4CQrQnZzcGZwl6vjYzBZKAPZwYOtVi9ttgfti/NnuRrY6iE/OJuFSwz0zuDQ3Zx6am2NZ/lzxGyMdDzDaO1V4y+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209631; c=relaxed/simple;
	bh=Lyqntk+JGXpBb+dHAPnDnB8PSzb9dB6Ng2Y/JgoG3rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tdsbu3HbUikav1KDa+7IkTG+7c3daHU7emFyLo/zfxoVjbqW+EZTHMZcROgDcAWP6AdaqqRmjoHO/EZ+sSMFF2ptw6OcqQhhpvcY2Obq0fCrPo8J5dMmY7dE5OIicugdkNV1ahAWFmlN/EDT549aO4+MsLRyI0G33pqjW1d006c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExEp2k2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExEp2k2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB8CC4CEC3;
	Sun,  1 Sep 2024 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209631;
	bh=Lyqntk+JGXpBb+dHAPnDnB8PSzb9dB6Ng2Y/JgoG3rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExEp2k2tVw9Iqiycl9KtzLt9QmiLgEQUf+LD/SeATsTOzwqAnMioCPOl3z/XsmvP1
	 DUFhU8+4lgFEEUgiXeRZuEKKBVwgquwVIthkNRAhMuY6mQy2HlHC1U681eLLZ/lAcL
	 mZOFynfxh0DRcOndK/nzBJZBWjZ0ddMqG1BT7rkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/151] btrfs: handle invalid root reference found in may_destroy_subvol()
Date: Sun,  1 Sep 2024 18:17:05 +0200
Message-ID: <20240901160816.563534589@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1f99d7dced17a..4bf28f74605fd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3918,7 +3918,14 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
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



