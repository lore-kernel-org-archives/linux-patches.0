Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1743C7B1;
	Mon, 31 Aug 2026 13:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184640; cv=none; b=u1dbh/QRzxKJUw0WsZl1J9rJik45jEo+ANzXQtG7DqSASy+Exm0vkOyitwl+ZdKnroTyfN2EOHNAr3QcgztnNM20u/1pvjIXxc0mMVsGYdrrNOyBY40Vps43IjfIdy/ZPuKEXYHotnmHaBSAg1Zh3OJV/RxbAYNKWiMHW8vgDMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184640; c=relaxed/simple;
	bh=qL+b7TTg8trHHaVQvi5vW89M233i6MWOUDl6u8MrLUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Loey+eu6t2uESUuiTDIgG45oMgdYex7XjsZs2eWnshCbgTSlhCkPVXjEk/2waVLt69JPFl9EgwIc6GwhA9msAelWWDZbXPCkwNoJTWAaaHJNtdMp2gji43n4TxsLKKFdhuxqGXVJ5uxScwqN1sdPrPeQuvEWdCKmlFHZ2NjKiz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQL+OjIj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQL+OjIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328C31F000E9;
	Mon, 31 Aug 2026 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184637;
	bh=clVlyTq6Y7tUjRBBmdvTaffDVajb4FbauBFb+F+XDOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQL+OjIjlBCCyGw+BeE7KVAlL9683g2Py0q0y3wwQyXX+TtTPd6Y9+zSx3IOjLanY
	 aBGXEOVpy+aPeSpJvZ2ZNWWLcByfDsoLLog0eaEcFu/j3HNSk49OU1Laf7SOns8AlE
	 UAZzQBL1dO05V8Zdd0DDA2LqFE3jSr8E/QdHS3RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 78/91] mm/swap: reject swapon() on filesystem-level encrypted files
Date: Mon, 31 Aug 2026 15:35:06 +0200
Message-ID: <20260831133403.635176610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit c310a8932a3107c9bc8f01d473e9d085f8aa9c98 upstream.

ext4 and f2fs don't prevent filesystem-level encrypted files from being
set up directly as swap files.  In this case, encryption is bypassed.

No one should be doing this, vs.  the methods of encrypted swap that
actually do work (such as swapping to a dm-crypt device, or swapping to a
loopback device on top of a filesystem-level encrypted file).

Nevertheless, to prevent user error, make swapon() explicitly reject this
case.  Document this behavior in fscrypt.rst as well.

Link: https://lore.kernel.org/20260803180426.3123-1-ebiggers@kernel.org
Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/filesystems/fscrypt.rst |    4 ++++
 mm/swapfile.c                         |    7 +++++++
 2 files changed, 11 insertions(+)

--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1158,6 +1158,10 @@ astute users may notice some differences
 
 - DAX (Direct Access) is not supported on encrypted files.
 
+- Encrypted files cannot be used directly as swap files.  To swap to
+  an encrypted file, set up a loopback device on top of it.
+  Alternatively, encrypted swap can use a dm-crypt device.
+
 - The maximum length of an encrypted symlink is 2 bytes shorter than
   the maximum length of an unencrypted symlink.  For example, on an
   EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3051,6 +3051,13 @@ SYSCALL_DEFINE2(swapon, const char __use
 		error = -EBUSY;
 		goto bad_swap_unlock_inode;
 	}
+	if (IS_ENCRYPTED(inode)) {
+		pr_warn_once(
+			"Filesystem-level encrypted swapfile '%s' is unsupported. Create a loop device over it, or use dm-crypt\n",
+			name->name);
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
 
 	/*
 	 * Read the swap header.


