Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C149A25A2C9;
	Mon, 13 Apr 2026 16:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096761; cv=none; b=B0kSqylvwsfFVBFTFVHQYRcCFy5iEQEKBWYS/qhu296OEeoqdqZFjkYnlA5gzcMFXs6s61u48+ruWFsmOovMah6xbZcaLQtJXMAN0QgxSk0p0PX8Mp9Nm+SiveMz61uusgjJonQJeyA14lKqRVZKJUx19mnaIMuVHXcPuXLiAik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096761; c=relaxed/simple;
	bh=7WQe4eJQxD0hX5iPXHZ0XEEw/+Oxx3msv7JBkU89LFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyesKc6+f2OkcOkAnRJM4RSQFbQPBJ13M+GREEkRKSD3qqHxrkEWO+nbbW3jrcXvekNv30OVlVYdDnSTFPO/D3W3HwoFOStytrrUM/IzqyEN/epF7h50AVkN+t0l4Kd1ovPWPq/FshfpLqJiDGa5vqX6hHM1XmMj4tANCjVsWuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0jn0BDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0jn0BDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58405C2BCAF;
	Mon, 13 Apr 2026 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096761;
	bh=7WQe4eJQxD0hX5iPXHZ0XEEw/+Oxx3msv7JBkU89LFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0jn0BDb05RzeIvTqaFWEVcoOaLKUwiK9ChWdN5NcOQFsEs/jGCZUnDhiFe74F/Vw
	 uV6bDdhf3RphQe95BU9N0gOJk6if3BniRnB6QHx+zVNpySynddOQ871qxn1Nz4vU85
	 9pHaVHfk4vGaOdND3W0emXY6tgUwIDC4wzb9ezxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	robbieko <robbieko@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 20/70] btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()
Date: Mon, 13 Apr 2026 18:00:15 +0200
Message-ID: <20260413155728.940553088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: robbieko <robbieko@synology.com>

[ Upstream commit 316fb1b3169efb081d2db910cbbfef445afa03b9 ]

After commit 1618aa3c2e01 ("btrfs: simplify return variables in
lookup_extent_data_ref()"), the err and ret variables were merged into
a single ret variable. However, when btrfs_next_leaf() returns 0
(success), ret is overwritten from -ENOENT to 0. If the first key in
the next leaf does not match (different objectid or type), the function
returns 0 instead of -ENOENT, making the caller believe the lookup
succeeded when it did not. This can lead to operations on the wrong
extent tree item, potentially causing extent tree corruption.

Fix this by returning -ENOENT directly when the key does not match,
instead of relying on the ret variable.

Fixes: 1618aa3c2e01 ("btrfs: simplify return variables in lookup_extent_data_ref()")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: robbieko <robbieko@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 28da7a7b42296..3e44a303dea70 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -479,7 +479,7 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		if (key.objectid != bytenr ||
 		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
-			return ret;
+			return -ENOENT;
 
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_data_ref);
-- 
2.53.0



