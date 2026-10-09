Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11C4EC645;
	Fri,  9 Oct 2026 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557151; cv=none; b=nVi7A/a1tN+Zga6rIPGmyY1v8ntoROE9gk/9tf8a32XH6l4YRnDwZM+3IfhdfZw0qzZpFYqxgOvbjlXIPQbMtMQxZkhygr15J3en8Z6xvpc65VntMtpEoXlSB0wtinFKLKJKYJy6Qhk7vq5Cf7crKaUNEV9AJm/3h4xpfW24C10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557151; c=relaxed/simple;
	bh=p4tHOyoYcwt3KQoci5onSuDp0dRMQwpwSMy16tuOBxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLUv+4+BtjeKzrGMkGKWNI05kvlJm5Hsp4q2ReNy2AdiRcxvWb/o/7J3MqB7zV7M4so1nqzBC/VEJSwV6nVDHPh0IH9xVdOQ535oHlhgq3vQhBrkVTAo/TB3W5w+QznO1tQlwXPH3cDCbP+RtYIMdDekisjAjGPJ3tYf8mED6XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nArWyEWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nArWyEWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44651F000FF;
	Fri,  9 Oct 2026 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557150;
	bh=yidb++R9+X7lYEnQVvHxz8u+/45Al4SNY5XVseTzpAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nArWyEWnl+sv8M+7Qc4N2eSa0h0vBLquaJD5L3DoDaL3qaj/+N/aFze3nZFGnp/yo
	 xWnc6Asv9fEFUvmrkVP2gDzzakMYLia4TWAgfnVVWp7TwxFsPizbrsdu/WQmsbmyeo
	 WcCUwo//wpGbUKZw2MBZGOZYoRSx/vthD6Og2lBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 354/403] fsverity: add dependency on 64K or smaller pages
Date: Fri,  9 Oct 2026 16:11:55 +0200
Message-ID: <20261009141000.558136033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -2,6 +2,9 @@
 
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
+	# Filesystems cache the Merkle tree at a 64K aligned offset in the
+	# pagecache.  That approach assumes the page size is at most 64K.
+	depends on PAGE_SHIFT <= 16
 	select CRYPTO_HASH_INFO
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512


