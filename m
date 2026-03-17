Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFECC364E9E;
	Tue, 17 Mar 2026 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768356; cv=none; b=s9bbic0Ufot2FHEXDlBvapQTZkLnLY7yU2uRgD8guS2wBHjUTJLpagQPQZzEQKrnHT4PdE0PGwnapoiBn0+v0ZJtCTnQcXw9BDT7QMFWIgKmx3Owt6Zav1tDRD7kAr9d9YhaRdeZXpjbAkx+aVTtQFM57V/AJlG97mKj9EpVdNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768356; c=relaxed/simple;
	bh=drNvPLCg6gks7gbY1fX2pLNyO9KoznJ0Wb1PzD6gngw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ys2yPJFDacnI36Z2oKUTOHETdN3ZXHr+Q0iz78MgtYrSs9O+BS5E2c0UYwbI6u07F9zJZAQnJiYT95qol80TKbaZXb36sysV06wZzxzXCzi6BooYRX8EiL4Af80mXCVKx9ELOM7BOkTqsK0O+uSgXL39opENiymQKk2BiigMQG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FH2sDk+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FH2sDk+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB96C4CEF7;
	Tue, 17 Mar 2026 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768355;
	bh=drNvPLCg6gks7gbY1fX2pLNyO9KoznJ0Wb1PzD6gngw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FH2sDk+OnduY+RDO0WolirGXdRk64DnVBPlv4jiZgSmBz/EKvrcRphCUzZG7ntLnr
	 B8YIILJnaDXLpUJDJTpGR2hbqxcywMl/evZJF2k3b+tZNx+flsfjrUQgZGjWR2BJMW
	 YnAYO2Tjbzkgu1Ayd+jpixuk3noGbq4TcjNW5Kc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.18 291/333] btrfs: abort transaction on failure to update root in the received subvol ioctl
Date: Tue, 17 Mar 2026 17:35:20 +0100
Message-ID: <20260317163010.185012557@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4039,7 +4039,8 @@ static long _btrfs_ioctl_set_received_su
 
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
-	if (ret < 0) {
+	if (unlikely(ret < 0)) {
+		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
 		goto out;
 	}


