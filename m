Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6333D343882;
	Tue, 13 Oct 2026 12:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895491; cv=none; b=h2rR3+RKlaMEt9PTc2Vanca2sXZS6dAyRx1SPQlO4cKpVimfkygUS7yS2j9J9YD98qyiTisreHND7Thj1zIBlVUI/rpk66avLmVhjsA6tc9PVAd8JUu6t9KyDb12yz/vm24heDhdff1dc6ASHrmFuW55hDzOasWYQlPL75z4Tdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895491; c=relaxed/simple;
	bh=MlHE6Cuid2Bnr7LRNGLo57Fqrl+IgCvz1ot9s7Aa8Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXh7y1adhUwTe3fgS4JdNcA82uuOksUwq1jqf249eJApuzWjjIo/m8PURfLPi0mfhk5Vy6RKro474sEjWGGsiAQ0xQLPfGmo31EB+98w6ajRXEuc0pAFoSb/Q7QA55YF3uzUlF6DTUuLxa5pjj/KVEvWVwovl57XjN0O37lQGm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0wPSghE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0wPSghE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60651F000FF;
	Tue, 13 Oct 2026 12:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895490;
	bh=9h6WGM2S1wUS+Yk56/RS19kLldF2QtiNJ1OBvZ5i0kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0wPSghEfolYqxHgDeZU/kuEtl4PHukUYmYmLQkcVslha8b/U1h3Xr7R+UGHW1fvc
	 3Hus0AXdTBSYfYOyIkTnd1TS6brM0JWVODLIpiWiBF7KG8c9DQJaupkV7/lpvuxQl1
	 OIIfXjhXsN58/B+2V2yLUzyjifkOQ+zQAflC5EL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/497] fsverity: add dependency on 64K or smaller pages
Date: Tue, 13 Oct 2026 13:37:39 +0200
Message-ID: <20261013112914.828096787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index e1036e5353521..db8fc01df7983 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -2,6 +2,9 @@
 
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
+	# Filesystems cache the Merkle tree at a 64K aligned offset in the
+	# pagecache.  That approach assumes the page size is at most 64K.
+	depends on PAGE_SHIFT <= 16
 	select CRYPTO
 	select CRYPTO_HASH_INFO
 	# SHA-256 is implied as it's intended to be the default hash algorithm.
-- 
2.53.0



