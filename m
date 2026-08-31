Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94C94E0858;
	Mon, 31 Aug 2026 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183583; cv=none; b=or4FSMfpGRpKPqkkRrRHR4nGJb8RMNZGSixmObn8+naRPdJ6B++Obrp3dM+rDNv72t5Kw8IBUqaq/yBmUx+MxozyacE7V2oGO1NZyFbPNBzC6CWIoeSWa4FI1yaxA2ZA4+5QlimoNYA/W+SNEgneJPX7+J9vY1duvJBm6L6fdIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183583; c=relaxed/simple;
	bh=XRDMmnyRTWp3HTEHgVPN9uicrd6M9zIo53OHG50xCFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWpZzff68bK5smaDXEVR5N34z6socCdSiwxgmyGRBw6j4bdhYbgepZaD7/+GL5cC2p3hNOsvocAshfOAgvdRmkNocNJWI9m7X4PqylOX5MoEJZSrN4zmXOUtu1KUnIXPNKCplAkw50tVwlyd8dVny9K5xcnPIB+Vtpr1vMCF+yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCr21EOD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCr21EOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8481F00ADF;
	Mon, 31 Aug 2026 13:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183581;
	bh=FZwJtu+hxcLUgzddGfgzI9qjblekxLm6N+DPs1dCMOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCr21EOD3td0l22bWpoquM365WiKqzXhwuK8+P+s8cp54M8usFBqeClM4HC0sjUGr
	 HIf6H+Gixa+5NWrrz8+X5PM7gLjiNp7Md/NYcjr0Ettf9vKYZQbHsUwRoZhNSm+2+F
	 QD6bJ/Fc8GyiYD02XyteGuNw+02h1cnjWEno+4wM=
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
Subject: [PATCH 7.2 47/71] mm/swap: reject swapon() on filesystem-level encrypted files
Date: Mon, 31 Aug 2026 15:34:12 +0200
Message-ID: <20260831133401.679211969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1238,6 +1238,10 @@ astute users may notice some differences
 
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
@@ -3650,6 +3650,13 @@ SYSCALL_DEFINE2(swapon, const char __use
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
 	 * The swap subsystem needs a major overhaul to support this.


