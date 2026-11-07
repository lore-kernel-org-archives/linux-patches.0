Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061630;
	b=olDfiBYQNj5OfR83lPnVbhrD5bpfkXOdk95upLOU0TjcGJhk6eqw5QLMHsM8Sr4i/hVm
	 RXnzcP/UCFNct/4y5blUOFUeoJncFSnGS0g46HvF/jlpiP3O25Ifw2y+uq4QZDdOGSt/8
	 1wi7kd+C8sCrLK6FhD0SsjuM2cOC7wMMDxYYTBkQr7PU0xcavH2s/+9un9rFeLX74vwxz
	 SLo27VsSr7VAtxwbdHInRec6LGWOCLZnzdf8B3T7iD7VgbT+nIYA/KaZaC/jnSRzEFsTY
	 5TJOEIhKaPoMwH4nZX7QxsRJUGUJPq1YCJyVY5QGJqjHwnCGPaRSWuLVzGskxPbbo8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DHy5cYCxkLG0hyQI7LYGobhKLq3A/4XIaXCUYu1fi5w=;
	b=RMqW67dsVymCjvlEQfPurtkLR139rIc8BkSPN5enu6lyxvZZt5c6P/6D4BdbEzzBaqaN
	 eOcLv1KAYyYyJt3V12NMxEljqvPT07xWdzjd1Wmlzmx0aOlirsEEQ+z7odu0pTJFOy14x
	 FRqIbNDmIUyQ+iy5rRzSlRkqHxqrGs5B/EQsSyu5DKDCYE0drkImiiRt9oCxX9iNis9i5
	 CzPgdCMhbfQE1Eud6MmFzcGeEc+9pl0DJAVbCLKRp6/jTxUoXF/GYho2nRBhKCLyzNXun
	 86hr9G461cSufOtWFsIZDTTfIl3vDQRiWxhAcOtxAE5myrXH3aigqVxk8pBV7gjTTpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UU+ubD2l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334F6606A330;
	Sat,  7 Nov 2026 14:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UU+ubD2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30CA1F0089F;
	Sat,  7 Nov 2026 14:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061630;
	bh=DHy5cYCxkLG0hyQI7LYGobhKLq3A/4XIaXCUYu1fi5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UU+ubD2l2ALfyw9cM2G5Cw7tTid595kFXi1JnAFXUge2avSTEnrZ+B/KK4ROs3GZG
	 x4T6DohCPomuNg3DlIhc6aOSLLL+LH7ySkFqC8+hzKNCu9zVowWh5M+EhFIaGq9iWl
	 D3yAFE8OF3j13aPgrjsq2GaKAtjMEb05xPaDhHP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0695/1536] xfs: fix buffer overflow in corrupt inline attr structure
Date: Sat,  7 Nov 2026 08:45:11 -0500
Message-ID: <20261107135017.011712445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 017dd7a84ff4cd2275eb62f4ee6d63c705bac107 upstream.

LOLLM noticed a buffer overrun if the xattr scrubber encounters a file
with a shortform attr fork with sf->count > 0 but if_bytes ==
sizeof(struct xfs_attr_sf_hdr).  Basically, we have enough data to have
a header with a nonzero count, but no space for any of those shortform
entries.  In this case, the xfs_attr_sf_nextentry() call will run off
the end of if_data and blow up.

Cc: stable@vger.kernel.org # v6.4
Fixes: ae0506eba78fd1 ("xfs: check used space of shortform xattr structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr.c        |   11 +++++++++--
 fs/xfs/scrub/attr_repair.c |    3 +++
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -590,12 +590,17 @@ xchk_xattr_check_sf(
 	}
 
 	for (i = 0; i < sf->count; i++) {
-		unsigned char		*name = sfe->nameval;
-		unsigned char		*value = &sfe->nameval[sfe->namelen];
+		unsigned char		*name;
+		unsigned char		*value;
 
 		if (xchk_should_terminate(sc, &error))
 			return error;
 
+		if ((unsigned char *)(sfe + 1) >= end) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		next = xfs_attr_sf_nextentry(sfe);
 		if ((unsigned char *)next > end) {
 			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
@@ -618,6 +623,7 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		name = sfe->nameval;
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)name - (char *)sf,
 				sfe->namelen)) {
@@ -625,6 +631,7 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		value = &sfe->nameval[sfe->namelen];
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)value - (char *)sf,
 				sfe->valuelen)) {
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -477,6 +477,9 @@ xrep_xattr_recover_sf(
 		if (xchk_should_terminate(sc, &error))
 			return error;
 
+		if ((unsigned char *)(sfe + 1) >= end)
+			break;
+
 		next = xfs_attr_sf_nextentry(sfe);
 		if ((unsigned char *)next > end)
 			break;


