Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EB91DE88E;
	Mon,  6 Jan 2025 15:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178326; cv=none; b=NjXWSeR6P+wp/NYDQ7Gy29S5eLG/j64kJEwSTxp0+Wsa9oQvnciw5PjmCuiInuBSde1n5VU/2JTiOSg3v+qUEvIgcSJOMMEYix8gT/bbklOUvdzpsRVdQ+cvTRm5XDsq11AMKBr+GoGLiD+EbTA2ap+NV0L2mu7rLTwi/xnLl5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178326; c=relaxed/simple;
	bh=J7DAnisxSEkDtxSpw3YDi8ionWxiU+1crQubXvqflsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMCgZ9mFZvcKyn6F2WomHf/VPxuvqU+Cmj5KDUGrAU8AyRQ/9Ewhmta07jWee0o9rQbir2xIvzQg7SL5TbxVn+87Ma13WnDqNDa7RdLtuFIicOjXvh+6t3KJIB0S1C2gWAGmvipP0LVMQctBngJ4X4e9iBDI9ZejTfIvq1WWqEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Cjz8AJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Cjz8AJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E66C4CEE1;
	Mon,  6 Jan 2025 15:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178326;
	bh=J7DAnisxSEkDtxSpw3YDi8ionWxiU+1crQubXvqflsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Cjz8AJ8CZY/sl0ozMYjxMsW3wdsrsymZb0/iSKxr1SCcnNXAi3ootvh6zuPbkexo
	 nNL37rDrMEC6L4vjVjz4YJE4YPzrN/HR/OiVE/7jtdIVmjfa8lTjJVTG4Ev8ggbtUF
	 XG7CoswEZrx+/ZxgA7GMBYVBppT+J7rLF0mIKv2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 080/138] btrfs: avoid monopolizing a core when activating a swap file
Date: Mon,  6 Jan 2025 16:16:44 +0100
Message-ID: <20250106151136.259565585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.

During swap activation we iterate over the extents of a file and we can
have many thousands of them, so we can end up in a busy loop monopolizing
a core. Avoid this by doing a voluntary reschedule after processing each
extent.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7128,6 +7128,8 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
+
+		cond_resched();
 	}
 
 	btrfs_release_path(path);


