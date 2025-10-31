Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477532641FB;
	Fri, 31 Oct 2025 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919617; cv=none; b=qdV2KETvybghJf0Me35o3AMPDUDFugFtjGAXDmq5isS7KIn2iIOQDv3lJBOHe/LV8dr1TCL+tKvzdKcI4fEBinLh3U4aeZYlxtPUeBwXKdBlQNF/BCRSXPFbu8+rnuj5gs1EyQBmIinnPNs8ROUyer0DpU2417Qgy81ZJHJDl84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919617; c=relaxed/simple;
	bh=8YMiEgssjlglsK6ObUo0xQbrr27Ryq0nZpu3+IenPLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dS3SqRrsECTykyeinZElGX8KHDz+BE2Bt7MjNo0lcRoM5EClL8mnk+yn0rFznEI2rP5L04sn6W/Rt6g0rXNbtLQaHAJOglPyg/basnwE1sbzWXHtH5aVpgu3C1AkAQ9K7V01zNUX4Pq3AwzY54PE9vYcs5stVfLWLK9Mz/XtbMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShdAUpdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShdAUpdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D24C4CEF8;
	Fri, 31 Oct 2025 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919617;
	bh=8YMiEgssjlglsK6ObUo0xQbrr27Ryq0nZpu3+IenPLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShdAUpdMs/yJQ/kSi9JRCz+Q9fde+yhLSvcy9xDxpjs1XnwtavaOpGQSbd+kMqE3n
	 ulvmjEtE6rVdKHricgSj4rHs3BwLbU2BhcgjMpbOYHHd4Gc+SF0U821CklcWY3POjn
	 2+Um1d11fCbmH3hxJwwTU/DmN+JaCrEQrsmWrYso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 31/35] btrfs: abort transaction if we fail to update inode in log replay dir fixup
Date: Fri, 31 Oct 2025 15:01:39 +0100
Message-ID: <20251031140044.384566713@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5a0565cad3ef7cbf4cf43d1dd1e849b156205292 ]

If we fail to update the inode at link_to_fixup_dir(), we don't abort the
transaction and propagate the error up the call chain, which makes it hard
to pinpoint the error to the inode update. So abort the transaction if the
inode update call fails, so that if it happens we known immediately.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4f92aa15d9b1d..165d2ee500ca3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1796,6 +1796,8 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 		else
 			inc_nlink(vfs_inode);
 		ret = btrfs_update_inode(trans, inode);
+		if (ret)
+			btrfs_abort_transaction(trans, ret);
 	} else if (ret == -EEXIST) {
 		ret = 0;
 	}
-- 
2.51.0



