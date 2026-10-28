Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208886;
	b=3mo8tctQ+6VvaewRBZNX2Jq9jxuevHVFs3wk1JCZnH5HAak3qbJNnDkv51FGp7Ovv6yy
	 DdnKJXVhvlKZ9QrCGcrI6TRRueW2vcanPYDIm9sDoVrcMUuBb93IuiP8Nq025fC5fG4xx
	 /FwC5C2FWDiZf8sL5liOn5za3+H4Gm/D+aVsiAGvGni+AXBNsA7m8Sfjj4i0iTCOZXweB
	 RiUgs6lbhn3449MaFZUCDAPCVGVrvtbO1w8TVMV3caBpJ6qGp8APzv6MH/DhlF5QvzHqP
	 ZvA9MCfoaRnrls8Fshl5GxtdVuNq0b8CQeOxItp0loN3fp0K6qmBeWy+QXTjn0ldEKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gDejcydvmhDUBMC+4blNXZGbtxxTTzmkHDE3nY1g46E=;
	b=5LAvzCgCB4NMhNbnNymVbjcQxegg7SIlepprGMAhrJdk18iKalvJn5D6vd2z9uTaukj5
	 8TV6CQqD5fItwUlUw3Sj3Cd6s76Tggul2PghY91IrgbucSQbktf9qaxMysCCpHMxsZnvl
	 311PAeEKD0BB2Dyh7VrVkIAp4DRKvlLi+KUmdxsEbvrik3m+xoKW0y7ldbnXqBB56Wknc
	 0gU2iWAMTyZvL/w993v8Csoh1lqFaBm18Lwke3SWZiGP9ynOrCxK95MfQLnzEEUyqW4lU
	 uxJRC/KaaBUxxWkX/hwTXHqey0NV4YqPr7N6FtUUYCoEavehGxQ6lMyKXVIsL2gQ/oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8aAavU1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA77606A31C;
	Wed, 28 Oct 2026 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8aAavU1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4981F01828;
	Wed, 28 Oct 2026 17:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208886;
	bh=gDejcydvmhDUBMC+4blNXZGbtxxTTzmkHDE3nY1g46E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8aAavU1xUWs5eb8aTgg9wD4v3XswbdTjIinFEYizG/i4RuDjJEXeCS/UZCjkTmo7
	 F8Tkfs5hmBy/0REYtJ7wRrXkeGZfTlM36a26QXINWtKNyowkNVwOqGRxXdkAvYZVqo
	 9jpx0zxsWaPTa2GtrWLt3vFMNgR2hUFcMslymDcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/516] fsverity: add dependency on 64K or smaller pages
Date: Wed, 28 Oct 2026 17:57:07 +0100
Message-ID: <20261028170010.007122540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit a300000233a9ff842e2fb450fb9a79f7827a586d upstream.

Currently, all filesystems that support fsverity (ext4, f2fs, and btrfs)
cache the Merkle tree in the pagecache at a 64K aligned offset after the
end of the file data.  This offset needs to be a multiple of the page
size, which is guaranteed only when the page size is 64K or smaller.

64K was chosen to be the "largest reasonable page size".  But it isn't
the largest *possible* page size: the hexagon and powerpc ports of Linux
support 256K pages, though that configuration is rarely used.

For now, just disable support for FS_VERITY in these odd configurations
to ensure it isn't used in cases where it would have incorrect behavior.

Fixes: 671e67b47e9f ("fs-verity: add Kconfig and the helper functions for hashing")
Reported-by: Christoph Hellwig <hch@lst.de>
Closes: https://lore.kernel.org/r/20260119063349.GA643@lst.de
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20260221204525.30426-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/verity/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
index 88fb25119899d..e74030597aa92 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -2,6 +2,9 @@
 
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
+	# Filesystems cache the Merkle tree at a 64K aligned offset in the
+	# pagecache.  That approach assumes the page size is at most 64K.
+	depends on !PAGE_SIZE_256KB && !PPC_256K_PAGES
 	select CRYPTO
 	# SHA-256 is selected as it's intended to be the default hash algorithm.
 	# To avoid bloat, other wanted algorithms must be selected explicitly.
-- 
2.53.0



