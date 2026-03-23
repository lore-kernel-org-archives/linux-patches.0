Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967073AC0F8;
	Mon, 23 Mar 2026 14:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275736; cv=none; b=aC5U11Zdt9ZE+vArpA+4jmyuej9nZYdGHjiA/wF6OKoB1nUcFEtNgXQrJj5VGM8U6UZhZVufQqz8nf+kgdjQXPPJUL7Bm1fIx9OKBYKWL/N/1pfDacYniptuEvLHb+eqau5a8jaKRbe7ZvEosPJ1f4f2PZpp7AYnrM6M8liJWgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275736; c=relaxed/simple;
	bh=qUKqRhQ94190J11mZGFzEMHhI8oT6wkF5ii+aEKF4Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pi+X9dx9HCIev1HM76gFtsn2XxjvkF4Urytv8VQj6by9lyDWARQtCXcAMBo/HPuPrPgfbDTU/HqFhrsVvDAgR/AXZjRGemghgpk3XwRdXw7vJeCiQx92Uz5upmsy5fyI7NXowlCBGYE5DTgS6OQTaMjDXWdEAq+AzpTZf6DFo3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/8ANJiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/8ANJiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18C9C2BCB4;
	Mon, 23 Mar 2026 14:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275736;
	bh=qUKqRhQ94190J11mZGFzEMHhI8oT6wkF5ii+aEKF4Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/8ANJiSExoai0plJ5gajcX/f4auWZMbDZhbN/TEPab79Z9Y2GNlL5HXCxKt8bsME
	 GAbIQLXm5345BQSUQ06uS0zqZglpGCXj5R+JbEQBFV0XJF3K7st2pow5DFkgXsQhsr
	 Y+nG+3TMtLK6nYfJtrGpq3VbEgozwiAyNTo5Q7KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 202/460] btrfs: abort transaction on failure to update root in the received subvol ioctl
Date: Mon, 23 Mar 2026 14:43:18 +0100
Message-ID: <20260323134531.500177146@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
@@ -4152,7 +4152,8 @@ static long _btrfs_ioctl_set_received_su
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
-	if (ret < 0) {
+	if (unlikely(ret < 0)) {
+		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
 		goto out;
 	}


