Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3F04963C8;
	Mon, 31 Aug 2026 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185247; cv=none; b=XjE5YqxsGwY1guY7u8nt2KQ31x7/phTSV8A/KcwPPCri+aD2+z9ZZ0YkRIMI3q8bQ4xHqFPFXxcKp3WyKox/f0s6VdVWJlbdoQGES1zAjw6W4SMndepu8hTnkDH9xZvDFQo6KfyWJ3KrHkk3J3+v0vwOB/GVRzlm3L80ty2xbcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185247; c=relaxed/simple;
	bh=HJMe8aCawg+gxxsMddA/iJ5nznWhX2BoMUUhDJTirnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1ZS9H0AAOczT2gOFsBeJjurlnviqsKCTjy9O/sqoyKVZ6Sj1vvJF8cYFQ8K/5UboOMmqBWTg/J+FJb5760PPvIgo21hmadhr1B4stOaXJa8lZJOcYZXIlzNIdSmKnBPhC6SXkz/q3DWKiGGDPrCBlMzfSvjY0LCvKd7Rnry3ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qg2+qK9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qg2+qK9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587C61F000E9;
	Mon, 31 Aug 2026 14:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185245;
	bh=bHDimD4/rdnstOM2zs6ZG8XbsYOtZDHtfT+bY3zWwH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qg2+qK9VNJfxMuyHTUxoTsqolqLE9rwm+sr8l3f1jGY6k7OGWpiYfXOEA3x5Z9HI4
	 G2g1vMN5kgu06RXzPyqVOL0HfX89dLYLWEurGSwavY0JqvHvMtQjIKId8nroTzOozG
	 07jwapulFh2arsRqLjfqOAZEnfZ9wkiM+g/+0luM=
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
Subject: [PATCH 5.10 33/43] mm/swap: reject swapon() on filesystem-level encrypted files
Date: Mon, 31 Aug 2026 15:35:41 +0200
Message-ID: <20260831133400.174029037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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
@@ -1068,6 +1068,10 @@ astute users may notice some differences
   give the length of the ciphertext, which will be slightly longer
   than the plaintext due to NUL-padding and an extra 2-byte overhead.
 
+- Encrypted files cannot be used directly as swap files.  To swap to
+  an encrypted file, set up a loopback device on top of it.
+  Alternatively, encrypted swap can use a dm-crypt device.
+
 - The maximum length of an encrypted symlink is 2 bytes shorter than
   the maximum length of an unencrypted symlink.  For example, on an
   EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3234,6 +3234,13 @@ SYSCALL_DEFINE2(swapon, const char __use
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


