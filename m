Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211211;
	b=R2f0OnM8MFZyL1fp+GLeL6WwyAPwtvHX9LXvGjeTcAq/DSU0Jrpg97yy/n97X8k4owpB
	 DoCb9Ia5w1sGvPlwOZAWlvWEUWgpmV0VRiRKKbpnAS4C3x1GD79HNtV+L8vD3ksFAUUs6
	 iqL5MicSJU+E/TF0DmGYZHUNuZ0JpuDzSweJlytMqG0I5l1Ms++ALbwKrmrvRm+tGM5ND
	 R9JAmwSasN07Hmapusi8oZDIjJ6yM2tvEVApgIW3bgkn64lN4SQnd6J/g73Uefo6kjR5/
	 +Fq4H91du40GayqMuixk2p4My9O6TLfJzSFFq+whndjGpcP+Xzw5UYs2SOslG2Yz4xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tD2Q+XOzgy8zaqeFXxTCtpWvvlAmnnRIPvJsgQ+DBBI=;
	b=Pu1xWOU0p+wXamGN/sTcLqGdUjeW6zzZ1Rv9r/6Z8FvPDz41SDlgBY1e95yGIBQC+x6E
	 IxPe447Iie5uOX4h0YIpfapSGg2pzPoZJFF/BV/Dp46nNhBREyuqFc1j67UZWIRImHNcG
	 lWr7delfsLsyW/iq2eSVMjcub30UVpKc4jiq8GGb0SyiZEO3tfF0K05IyudMujeH8dFDk
	 l7zIW6kxM5Vxi66LIUKdyJkLD+1MDLKewnXdu4op8AKsbN1YGDJVsE3QlVbNKaMMNKhpV
	 zgW8DwJNq2zns67E66aUZyJlzg04ymattEz2pYypWy3M7JcLfBMMx1xH1Q738TNv+qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dh5urwK+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E104606A33C;
	Wed, 28 Oct 2026 18:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dh5urwK+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F6A1F01828;
	Wed, 28 Oct 2026 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211211;
	bh=tD2Q+XOzgy8zaqeFXxTCtpWvvlAmnnRIPvJsgQ+DBBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dh5urwK+KSiufN8cjxj+Z+69JBvm0o3V/DsZ/f79df4QzXdUuQwaYvrBG3nyl2uQ+
	 L/DXNc1u4ocG2eMXQKpznQPYs4fANzgNWSXkal250Z4T7yjmgp8JKmDJS4Sn9Kz0QY
	 MtjYjaX1KjHZrIO4jvu5+DD7WYGl+KGSqZU4GI3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/571] fsverity: add dependency on 64K or smaller pages
Date: Wed, 28 Oct 2026 17:57:25 +0100
Message-ID: <20261028170015.070344678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 24d1b54de8079..4e3327ce27561 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -2,6 +2,9 @@
 
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
+	# Filesystems cache the Merkle tree at a 64K aligned offset in the
+	# pagecache.  That approach assumes the page size is at most 64K.
+	depends on !PAGE_SIZE_256KB && !PPC_256K_PAGES
 	select CRYPTO
 	# SHA-256 is implied as it's intended to be the default hash algorithm.
 	# To avoid bloat, other wanted algorithms must be selected explicitly.
-- 
2.53.0



