Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFBC5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEB7C433C8;
	Mon, 19 Jun 2023 10:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171587;
	bh=J/tTqgo641HYVk9EzkTqYtxqHXRyv7pA9oc9qdMCfGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVYXtc2CH/Z6kp4up7hGEFVarb5jq843ImlUxJQ1v51ZavfAWa6jzXIgFzbzz7xQd
	 H4haeJeudV5oqWloLWK+JsaSGD3z+sFI0IUJ0X1jaIJEvRH7PYicYcOQ0MtmemKfe3
	 qA1k2gYU0bduqO6N5fMLdb1D72GPY4+K3SfMq8+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 061/166] btrfs: can_nocow_file_extent should pass down args->strict from callers
Date: Mon, 19 Jun 2023 12:28:58 +0200
Message-ID: <20230619102157.758509442@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mason <clm@fb.com>

commit deccae40e4b30f98837e44225194d80c8baf2233 upstream.

Commit 619104ba453ad0 ("btrfs: move common NOCOW checks against a file
extent into a helper") changed our call to btrfs_cross_ref_exist() to
always pass false for the 'strict' parameter.  We're passing this down
through the stack so that we can do a full check for cross references
during swapfile activation.

With strict always false, this test fails:

  btrfs subvol create swappy
  chattr +C swappy
  fallocate -l1G swappy/swapfile
  chmod 600 swappy/swapfile
  mkswap swappy/swapfile

  btrfs subvol snap swappy swapsnap
  btrfs subvol del -C swapsnap

  btrfs fi sync /
  sync;sync;sync

  swapon swappy/swapfile

The fix is to just use args->strict, and everyone except swapfile
activation is passing false.

Fixes: 619104ba453ad0 ("btrfs: move common NOCOW checks against a file extent into a helper")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1849,7 +1849,7 @@ static int can_nocow_file_extent(struct
 
 	ret = btrfs_cross_ref_exist(root, btrfs_ino(inode),
 				    key->offset - args->extent_offset,
-				    args->disk_bytenr, false, path);
+				    args->disk_bytenr, args->strict, path);
 	WARN_ON_ONCE(ret > 0 && is_freespace_inode);
 	if (ret != 0)
 		goto out;


