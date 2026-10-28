Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211322;
	b=g4QrFk3fPodRLMITVv61PjzLwv6R+zO5zSwqSyH/SO5e6yHAFtGQC1aw2Bs2y5QZfxCO
	 nhF7aMsnOABC97gz2/NGi7CFbGa7/hiDw44jOBQadoPK2eNzA5WUieqWDXM9SgK1cmyci
	 /txj7yU4ilYwKhtfO5AlRFXCfSwAcqUbtgE/NUBayEbtgdGjcHiJmaWZp9Ry+oomIyIid
	 ZSzaBUj/UOHvcVsj35qY7zcxteL0PmojN3o/JdWloquMdxwp50xapZ/1iZ5ClRcnns3LT
	 /xxJ8BsilA8C7W33WDapOtdJj7XNsFqtNYagGtapnZyhqapkjL4ynAwjlRxTUDCdqdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dCbbW/+Y9uwRRwEZgS+yaLwLiL6WGu2S4v5rIdwzx3Y=;
	b=EGxDwy7apv6TuskdDUEmW6CVC03raCUTNhNJOD5Ad+11awWyE29i2Khl0F8twBeMJpNW
	 6GN/kzo7W/dGVpqdzsNlEFOGTB4vImaRadIfDD5Ews6FI5KKt0QHDn/55Y1Mim7I91X9p
	 Haf6IDp4puRzUSr7BVeLPRw/f4xh6ObQ3IaXfHZnQRvMQJ9m+rgK1XrR2TPaV971fAQvp
	 nOCnfSBVrBrbIKb3978Sv4iKADraYdsQVIaVKVZcejplqI9Neei3JfrNYNWDqih2xahXT
	 1MUAyRsQmJAYQhezHFvSSjGqIwPE7LkDkqvnx8Ahffe/B+slzaqrk2K9vaWL10+hQJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxajyLwC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83552606A333;
	Wed, 28 Oct 2026 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxajyLwC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3BD1F01825;
	Wed, 28 Oct 2026 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211322;
	bh=dCbbW/+Y9uwRRwEZgS+yaLwLiL6WGu2S4v5rIdwzx3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxajyLwC9thlbVPsOW9hF2zTSrkv7xjQoQ4DccCdtFui/1tddhbJP0mHr002bDnzw
	 lLxiO6eKaTxFc+b6qE81yT/ZDTJIeNGBMMWqE21ncDmN3NxbTVrL+wHYFKZTAYMLj/
	 W9TaiayjdRgzKY7m07ADi0cZ2BSwxfWDrtfFf4TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/571] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Wed, 28 Oct 2026 17:58:04 +0100
Message-ID: <20261028170016.009935633@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit da4fe97fb6c730d9c94a115c7bfa6f98e0d578d0 ]

smb3_zero_range() removed the pagecache only for the range being zeroed,
so when it extends the file the folio straddling the old EOF - which may
hold data dirtied past EOF through an mmap - was never dropped and became
visible as file content once the file was extended.

Lower the discard boundary to the smaller of the zero-range offset and the
old EOF.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Replaced the unavailable local i_size variable with i_size_read(inode). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index deed3b5e78065..2f5c446de223c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3601,8 +3601,12 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
+	 *
+	 * Start at the old EOF when extending so the folio straddling it, which
+	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	truncate_pagecache_range(inode, offset, offset + len - 1);
+	truncate_pagecache_range(inode, min(offset, i_size_read(inode)),
+				 offset + len - 1);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))
-- 
2.53.0



