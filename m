Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0803FF8AD;
	Thu, 12 Mar 2026 20:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346412; cv=none; b=cFixffbHOKhJVg7E4t5PguNv051vLLqoEbBacEiUJrWOezqMhqGuv7XIbNOaFaOCuEQAnsag3bTsbFXn7Iz0Bww7Ne7N/jEk2OEP4XpHWX7Yko63NgLP7eBv0hCbPqGZLfrhHKRiY7WRSdC42+Hv1eiL0i5WTxbjiXFCWKiH1es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346412; c=relaxed/simple;
	bh=TNql/o7tcAMLHDE3aJPCbvDrXhYIHETAh87pGFnvcM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJTqNwNluwh6Rp2FGkMSb9ML49ixLt57rubivkMAjEkRDufFbxVAxDb5X/48mdBqyfExe3l5PCuFG43MPyQmfP7QQJW93kFS490V3LXO/k/i09O6WO/wrvICZ46szBEXwPu7w8vRJ80CHfjRSk1BPJp/QaqaC80WN4wDqlP+d+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ar95w1rO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ar95w1rO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02370C4CEF7;
	Thu, 12 Mar 2026 20:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346412;
	bh=TNql/o7tcAMLHDE3aJPCbvDrXhYIHETAh87pGFnvcM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ar95w1rOOojFT6aJ2t5V/ewStgb6u0WamOt67DiZf9QK0tH0kL2aIpU9oorfWY7j2
	 D4Pb1Mzg52Z0c3zeu8pBafGkZbos+Cwa+DRVu3G8wvs3JqlGbYy8h0emKun6qFEXYg
	 uNTWhUVGiuccdzcjPkDfQseD3d3+nIUBm2r9IZsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/265] btrfs: print correct subvol num if active swapfile prevents deletion
Date: Thu, 12 Mar 2026 21:07:03 +0100
Message-ID: <20260312201019.495599683@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 1c7e9111f4e6d6d42bc47759c9af1ef91f03ac2c ]

Fix the error message in btrfs_delete_subvolume() if we can't delete a
subvolume because it has an active swapfile: we were printing the number
of the parent rather than the target.

Fixes: 60021bd754c6 ("btrfs: prevent subvol with swapfile from being deleted")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b1d9595762ef6..09ebe5acbe439 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4629,7 +4629,7 @@ int btrfs_delete_subvolume(struct btrfs_inode *dir, struct dentry *dentry)
 		spin_unlock(&dest->root_item_lock);
 		btrfs_warn(fs_info,
 			   "attempt to delete subvolume %llu with active swapfile",
-			   btrfs_root_id(root));
+			   btrfs_root_id(dest));
 		ret = -EPERM;
 		goto out_up_write;
 	}
-- 
2.51.0



