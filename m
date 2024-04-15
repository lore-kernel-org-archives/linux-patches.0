Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581B678297;
	Mon, 15 Apr 2024 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191776; cv=none; b=GqyBRHww76wf/8Ewwb+JydJv1DSd9DiIoaCM/1z+ugeFafxXqbA+W79Aydqzfh6u7JKuPMeLLcgWYBZZJDaRPxcsL6cBVfeBJw09wduNiNOCDO3vsS3hi2Rq9Qr28vgVz36rX3rt2pWs9LJ2EC1h2u0H43L97uB7mWU86+gvR3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191776; c=relaxed/simple;
	bh=fC+BQyhJwX6NPfeIhGCjrKDZLhjwDFWlEGBKKv2B49s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJjPryHI2exOROwe/wDo9YrT92XZGawC04+uiHTTDnU4OPBPqqD8iw3iZ4IUsAL3Ko8YpzjyffVYXlJBp8+Kc89VXhUBTV3kA5sgdmlYhhRoV1ZjBO3xQW9ie8+gl37lO/6Q9043hyx9Sr2EysB6b5chuAA7W/PG5tE2th5MWxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaLYiSkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaLYiSkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59D5C113CC;
	Mon, 15 Apr 2024 14:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191776;
	bh=fC+BQyhJwX6NPfeIhGCjrKDZLhjwDFWlEGBKKv2B49s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaLYiSkJ38fDjuv/YkVkTNEvxsh/0m9+6pu5M711A9ORvSWOFOwNvXFhIHdXf54WB
	 BEtFEmNz0GWzF9rxCJ2UOPsjkrTfMj1AkwswW3Kd2PIRe5Jrib0exbzGdfRiuIXUD4
	 Bcj6j5fjbs1XPxZmAdtBc6/KWOLlU84bz5KWLpTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 081/122] btrfs: record delayed inode root in transaction
Date: Mon, 15 Apr 2024 16:20:46 +0200
Message-ID: <20240415141955.806443060@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 71537e35c324ea6fbd68377a4f26bb93a831ae35 upstream.

When running delayed inode updates, we do not record the inode's root in
the transaction, but we do allocate PREALLOC and thus converted PERTRANS
space for it. To be sure we free that PERTRANS meta rsv, we must ensure
that we record the root in the transaction.

Fixes: 4f5427ccce5d ("btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and item")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1120,6 +1120,9 @@ __btrfs_commit_inode_delayed_items(struc
 	if (ret)
 		return ret;
 
+	ret = btrfs_record_root_in_trans(trans, node->root);
+	if (ret)
+		return ret;
 	ret = btrfs_update_delayed_inode(trans, node->root, path, node);
 	return ret;
 }


