Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B79078C8A;
	Mon, 15 Apr 2024 14:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191328; cv=none; b=DpvDGydWSsJdA89UqVLnjCH5QvdwbGaibjqLLcKL9SKPfzRJ7J3PibaUatDbUVsTsTp76YJ+81SMj7agRvTcBYHa/syNip23eNg8Uivd4MoR8AxmW6MelYhrrZ+7xAXQnrI6P98KDMCST5pm5DfrTGaMFKopUYAIUiJTWR0q1HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191328; c=relaxed/simple;
	bh=lwnSdzPY92eacu2aV8J6ad1o17f0pkW6bnh4xbjg1to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xi49gNh53/131R1RsVQIXzALxfR5ZlSvwRGn+jg9kGlYlKb31tMYSo02qWEEoBZNoECFrKllmhhbz2lFS/GnCTklUn28fnKdQz6ywU3JxH751JG5TTVklZJFYqEDU/gLLDX527mVPo6whN5cTC4oTXCFe9sUnocNgUVlDK4wGxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQQqTnP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQQqTnP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642C1C113CC;
	Mon, 15 Apr 2024 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191327;
	bh=lwnSdzPY92eacu2aV8J6ad1o17f0pkW6bnh4xbjg1to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQQqTnP9RSD6qaM4HySnDNoQit+Sr9AUznX2L6dTRFSMKI0S+xOK4nWVLo7fvQY0M
	 DHJaS71pOEyK03ZMlCoZX4505oDY5tcv5LzMuDhjUmrM5ZAHftYqelaBpV8ZGUSw6W
	 +zSLChSeWBzLmWBOQkJidfhkzHfAvKbZ0loUwYww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 108/172] btrfs: qgroup: correctly model root qgroup rsv in convert
Date: Mon, 15 Apr 2024 16:20:07 +0200
Message-ID: <20240415142003.670533332@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 141fb8cd206ace23c02cd2791c6da52c1d77d42a upstream.

We use add_root_meta_rsv and sub_root_meta_rsv to track prealloc and
pertrans reservations for subvolumes when quotas are enabled. The
convert function does not properly increment pertrans after decrementing
prealloc, so the count is not accurate.

Note: we check that the fs is not read-only to mirror the logic in
qgroup_convert_meta, which checks that before adding to the pertrans rsv.

Fixes: 8287475a2055 ("btrfs: qgroup: Use root::qgroup_meta_rsv_* to record qgroup meta reserved space")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4432,6 +4432,8 @@ void btrfs_qgroup_convert_reserved_meta(
 				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	trace_qgroup_meta_convert(root, num_bytes);
 	qgroup_convert_meta(fs_info, root->root_key.objectid, num_bytes);
+	if (!sb_rdonly(fs_info->sb))
+		add_root_meta_rsv(root, num_bytes, BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
 /*


