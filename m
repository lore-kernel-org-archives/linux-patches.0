Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D885248880;
	Mon, 13 Apr 2026 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096225; cv=none; b=Qqptp7ZUMSIkuH4z+cy3Unjqid70723m6y548Fq19RW9YasCOQ7oNr7n5YeeBRNWXteADuz/Xmn6Sesy29u8B0MmygN9kLoIq91OeoOpgZST4ev3YYmB4pW4ZzDewVlCsnz2yCa1bFqjyW7KGWlABUGR4bkolVa1Ues6KQ6VqL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096225; c=relaxed/simple;
	bh=uT31W0AFp6OqXT5Zb5Vpes9Kj2Vdk54d4x6ctIyMULI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOlrcQ1o/TAW1gvI6UcvjfzXOw262AT4br4A5OGWtu8PkiH5LzURYDH4rXrLKQ1t2gtN+0S3u5MpOQKDesmWmBK0PC3DWeeLW8rReghmIZ5hvXTabXB9nmmPDo8i2GMLFAMY2tgmw9oWiCbS6KIcmXmU5SlF36097qGjjrh8pEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2BBHby0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2BBHby0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A95C2BCAF;
	Mon, 13 Apr 2026 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096225;
	bh=uT31W0AFp6OqXT5Zb5Vpes9Kj2Vdk54d4x6ctIyMULI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2BBHby0eahydpUM2rqG1Wx6EqCbq3kYRNDLu2IqVsB9c6rJvq+eAUKWkHUKpd+cC
	 RoRDsz4J7Ls3dMrY/kH38g5RXJSwwyFdpol8OpgpRH/Y/6utz1DPAiPvya0D00Ccka
	 vvEusJqqSi6iZPemkbBEkYmFuc+ZVcSfR8jHRCeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	robbieko <robbieko@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 16/86] btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()
Date: Mon, 13 Apr 2026 17:59:23 +0200
Message-ID: <20260413155732.184663659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index f2b1bc2107539..f5ca544e35431 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -476,7 +476,7 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 		if (key.objectid != bytenr ||
 		    key.type != BTRFS_EXTENT_DATA_REF_KEY)
-			return ret;
+			return -ENOENT;
 
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_data_ref);
-- 
2.53.0



