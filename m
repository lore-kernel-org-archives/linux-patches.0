Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9031E501;
	Mon, 15 Apr 2024 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192199; cv=none; b=TM6VVTpPOUEL5l8C6Ll2niV1BxV96P8FnOndg4ady3+zm4tpkpwaF0wqcEXIpxyLxG48YLv7shWq38OLuUarS9XJ6DvXTIJEEWOZfHfyXdQW+ud4cAqTLQb0DKim/SN1gEGk++LAdqgE6vgoZ14g1Ys5GBxjov/QdJkKkP3UJNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192199; c=relaxed/simple;
	bh=lCnP0HPxKOXGRjMcNaJcIiu5ecS9uP/RJpXMSOtC7OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiieF/lhNvq7frEmo9JuWI900k5Ff6btBaqIccLIh2FUM7iKPuUOB3Y67OeiB5ydrSFFwy9Ef/rAK2HXavmT3jKEOnore7SEybebFfIQE+2oPgLPk3RrSpOjkHtA3sBCdwHb1lGPkadqHWB7DSRVQMMdgj7Hd/GBND3O8H9oAQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZy85h8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZy85h8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AAAC113CC;
	Mon, 15 Apr 2024 14:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192199;
	bh=lCnP0HPxKOXGRjMcNaJcIiu5ecS9uP/RJpXMSOtC7OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZy85h8oweN546HdfOteIV9c1S2GL6XwhHllXiPA/8QdxY3TytO47YSz8oJaQkO7u
	 6DejYTv4+z6xOTYhW+CoBaUjOXXELA7Wp8I2eQqsSgSoMq4wDyL5sbC1Dbdh3Pw3tK
	 sn5ZvQ8WkrfRClgsP/zGiGxA5WZiJ5VWpj71wjsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 29/45] btrfs: qgroup: correctly model root qgroup rsv in convert
Date: Mon, 15 Apr 2024 16:21:36 +0200
Message-ID: <20240415141943.118206027@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
References: <20240415141942.235939111@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4080,6 +4080,8 @@ void btrfs_qgroup_convert_reserved_meta(
 				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	trace_qgroup_meta_convert(root, num_bytes);
 	qgroup_convert_meta(fs_info, root->root_key.objectid, num_bytes);
+	if (!sb_rdonly(fs_info->sb))
+		add_root_meta_rsv(root, num_bytes, BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
 /*


