Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CAE255E43;
	Sat, 17 Oct 2026 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256920; cv=none; b=XmWt08eVN7ky8WFZY4mGYFM8lmBujaxod5ofTrllEtiYCBMkAZC0Q5nI0yIWWqbfi7EtMUVJFBC3tJochCjz6XZTKgWnPEWupdnSbZw2Bz/seiEOUXQupJ+Z8MipxpXi0x6ZJQt/Hih4Ny9gBXB5p0LiFMf23s29l4/Q11lLZag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256920; c=relaxed/simple;
	bh=7pGNKLZIlJTDm9QES6kgBAIrIhTBAjOLcBUjwxViz1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYEV9xtM/4PlY6g2ASoHbigu3+nAyuDQAbOLRV/sG43kqOEYmamiE/QPvu8QLfJirjq2xeKQVlhxQfdQll4oQOOV9pyI7maVNOZKTbqZ4cthWuUTVl5HskL2WZGn3zA+wbEDW8WHNrc9fJdh+gWo+nf/KAGQYKIsw7KaAUWg5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zapfhhRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zapfhhRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E761E1F000C4;
	Sat, 17 Oct 2026 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256919;
	bh=hrfFKDaJoxEFMPqkUQDzwYdQ430O+7adwe7IaGBHdwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zapfhhRzSawR0pV9AtZfA4o2YhrvsyrfgM7UtGu7A5KX6D4v1bg1UXtjYgsJpYR6o
	 zfTj9vMVEoo3eGbHCrVaXPCH1Ez4MHFm1xD61ZlXQF2HR17KX89Xtbf/n9lmh+rdpF
	 NWD+xmOOUBIvUqedL6nJyQiqtvuZ00LO3Jk9xiQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0387/1674] fsverity: add dependency on 64K or smaller pages
Date: Sat, 17 Oct 2026 17:44:19 +0200
Message-ID: <20261017160441.045465919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index e1036e5353521..5ff8d9a9052b8 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -2,6 +2,9 @@
 
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
+	# Filesystems cache the Merkle tree at a 64K aligned offset in the
+	# pagecache.  That approach assumes the page size is at most 64K.
+	depends on !PAGE_SIZE_256KB
 	select CRYPTO
 	select CRYPTO_HASH_INFO
 	# SHA-256 is implied as it's intended to be the default hash algorithm.
-- 
2.53.0



