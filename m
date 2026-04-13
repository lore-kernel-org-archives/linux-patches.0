Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63A2223DCE;
	Mon, 13 Apr 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098889; cv=none; b=SDIQl89HX/Ak9PnlUQHVAMh+moF8OEMthfuiKLy1M15ZSchItNa3AK6+08mDS0hJyU8sOmSO10KCqlyywc/v5FNP+i7EtaRTPknwWj2E6Bw9yHHv3p1zeALA4jxuNqmo1WW0QlylwB4YEU7WgEibjM6RRwQe6XJlwK4NT3jwlY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098889; c=relaxed/simple;
	bh=uIcJokF7lnLajI/suzw/C9maCReUQwwBlOB6GzE7SSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clCDBBNkvLI4ehnkmb6MPy5iOrdsTGZSIm0MALCAKpsr0x5RQJuiV1ZMa7bEpfkIyaEaAVciTmLQLfiaDeKVcwKyW3VoJjX6FjkVyoroR1Bxl9MSR0XB6BKqJ9ThW9yVgKcmLcYysU2cExOXsMlfNTNGuPvbgvGNP0jNyaDsaPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVd7mnSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVd7mnSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E017C2BCAF;
	Mon, 13 Apr 2026 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098889;
	bh=uIcJokF7lnLajI/suzw/C9maCReUQwwBlOB6GzE7SSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVd7mnSknhvRaxhtnQUbLEKptdvLWqJA8sR9568qKsNoma96Yu2n0pu0Ziox0W68a
	 Aszb3+L2C7+UYdnkA8WUZgCnLNMjy6iWqWG0SQJ2u8amZamlsfctP6XYGrF81LvULX
	 dLZREDrwvuZWTboJ7G/Lj6Bwux9V61hL3vYoiw1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 128/491] btrfs: abort transaction on failure to update root in the received subvol ioctl
Date: Mon, 13 Apr 2026 17:56:13 +0200
Message-ID: <20260413155823.832990024@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 0f475ee0ebce5c9492b260027cd95270191675fa upstream.

If we failed to update the root we don't abort the transaction, which is
wrong since we already used the transaction to remove an item from the
uuid tree.

Fixes: dd5f9615fc5c ("Btrfs: maintain subvolume items in the UUID tree")
CC: stable@vger.kernel.org # 3.12+
Reviewed-by: Anand Jain <asj@kernel.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4524,7 +4524,8 @@ static long _btrfs_ioctl_set_received_su
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
-	if (ret < 0) {
+	if (unlikely(ret < 0)) {
+		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
 		goto out;
 	}


