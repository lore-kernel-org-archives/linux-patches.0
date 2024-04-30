Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC2D8801;
	Tue, 30 Apr 2024 11:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476034; cv=none; b=fFAdtwC89jWMNUMbd0SreSQSnfbpgzITh6HwENPVoYxc3Uw6uXPBp4xZhR86ANcOe9TmeHyH4H6jVwnwhUQbr22lqrEdePZKeOfrcRAn2DS7zneHchsEbNAKeNGiY9UkvlCT/O5B1FTj/zebWbqsjYlkF+YYXovEZMCq0ElYd1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476034; c=relaxed/simple;
	bh=5/7lR0q0V8NcAcWLLxlc45wc1i1G+YI7Cdt6C6xngL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtKEVC2AOT9ofxcS4hD7cV0/dYrBbLrU9wzwblzwyMiOU3DMIxR92beIVVp311nbKTNLjqtHvz8Xi5j95MELAGnsc4ox5HQwsr0rZbc6kQYi0KiJHUHY94nY7PV5dPyw2OX1JzjbeKQ0OtAaaJBORwZqoWnZDMdm3wTK12ZdIaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTCa3wee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTCa3wee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA9BC2BBFC;
	Tue, 30 Apr 2024 11:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476034;
	bh=5/7lR0q0V8NcAcWLLxlc45wc1i1G+YI7Cdt6C6xngL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTCa3wee8x7gACqw9pLqUnHWjtg0pb0UA0kjnM1iTN65ig1W0NWjlMd/RwG8xej0A
	 QwSFuD/oMWSt0rQBJiltrA1TjGNukOF4LSSFO3Xo7EIanD8AxAa5gKnAorBqmv6Ymg
	 UK6lZdPsGH9i6RM3kmftPTFQ7Af7k4dM+c8aOQSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 014/107] btrfs: qgroup: correctly model root qgroup rsv in convert
Date: Tue, 30 Apr 2024 12:39:34 +0200
Message-ID: <20240430103045.082310293@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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
@@ -4061,6 +4061,8 @@ void btrfs_qgroup_convert_reserved_meta(
 				      BTRFS_QGROUP_RSV_META_PREALLOC);
 	trace_qgroup_meta_convert(root, num_bytes);
 	qgroup_convert_meta(fs_info, root->root_key.objectid, num_bytes);
+	if (!sb_rdonly(fs_info->sb))
+		add_root_meta_rsv(root, num_bytes, BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
 /*


