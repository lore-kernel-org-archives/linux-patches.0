Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B601B1C68C;
	Sun,  1 Sep 2024 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208948; cv=none; b=OCzTiwA0/ooWBDiRhP2Bm7uyVPZ68Ag59+Y9rinBPmClfhh9v9ROAwR5fWAXHIBxMBQNG8NnXb3UIelBGwKO0Nnq+avW4quY+zYNLQGiUkpfR3trwNE8K1RqeFgUctTPBGsCGua6iDh/MY/xVmPh1pvWX7HE7/GREbb/h1fvz3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208948; c=relaxed/simple;
	bh=XwR4Q1+/QlskJVDdUK22fy9bRmINxJFLld4hPiIVKkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5M137qkjMW+mixQNNaBtYtY7dVdEglftD6u30Y18Idtm+wd/GM/HRH93q5ubqh1gQQr31PcYextchJrEhzaj04cQWiD6s2ZeKgiNNepsWdse6LF/vrZ2hZYKJH2zLQkIBG3zQ+grWLOsP0GeEYhIsmisbZGFaGYDLOgqHOJl4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiKRoiwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiKRoiwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF57DC4CEC3;
	Sun,  1 Sep 2024 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208948;
	bh=XwR4Q1+/QlskJVDdUK22fy9bRmINxJFLld4hPiIVKkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiKRoiwqwkqNBLHl9xhHJDvWZfC6bi5oWFLQOD3NOWNeI4CzlL3pM/W37WolWGgsy
	 sTCT16BAocBb/Uu/ZOWA1123+qGARTKZO6eKFfQwHaOTju3VVWaX2KcKgGF7JTbpWA
	 XFf17SvvifKfx8ry5bL53HwWx0V2EYOe49Y1DN10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/134] btrfs: handle invalid root reference found in may_destroy_subvol()
Date: Sun,  1 Sep 2024 18:16:43 +0200
Message-ID: <20240901160812.251619594@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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
index 2c86be3fc25cd..d2a988bf9c895 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4520,7 +4520,14 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
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



