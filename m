Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831573;
	b=5ZmDGV0N6aYzuP4elfhDWQ1TAR/CeB6hlM8m4yUoNgUc4O9NChwD3/KwxKZRnbWdPN7B
	 6A7lo1t7mayZHNjOt4giuW1pDn2mGiE67LqkHhmqCZtIwCme75G1mZRIjP9UIPA/dcEFJ
	 wMrsF24i4wv5tgpHeakyksfuhrzZ1L2yi99oi6DdwbsQvCk3ymnJu7R4hFEKtXNUelv1V
	 zkWvshHCsl5U7VkaSI55XkPdf2ry1APD8HYquAQU0WiZd9b5B0U5V/Md5SlYjTI43l5kb
	 ybxccgbM/OBdbt5azAuFpnNRIjDqz7P7pz9UNeheAg73v8bSt/dsKSzab9HM5eY8S/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vNkNEh1lgx7MJx4s3ebrm5ppUjoNwny6/Q5SZwnnnTc=;
	b=Fr8Z8fk94bzWRgXZsDd0h62j8hWsTUUYAX4PekoRsaiVP90vN/xVMTg0aagYxKJ/SvVo
	 8u/x7bwrnWOI+Yt5rOVbsfrUX0n0SXkRMKZ/aYZlyYNV59dZf/zqdfDakhBKEFbN4AsKn
	 sznURlavm6ca9P7u90fpht9KbtPSOJwU8RCsH24rnGZ3BmO1jtinTu0a6eNGGrud+prkz
	 k76DJtZUmMbEQVyRx0TYja351PvUwNKncnRafa8sOQabBnWdMflAFsZJ3Bs51M74yNf6u
	 +iCI6Y8OOIyPBIxjliSPbwQV5d84SBW/T6vHvv7hkXTBviSi2SEBbSkAMCxlNpfBroQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CS/460z1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ECF606A844;
	Wed,  4 Nov 2026 22:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CS/460z1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFD51F0093A;
	Wed,  4 Nov 2026 22:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831572;
	bh=vNkNEh1lgx7MJx4s3ebrm5ppUjoNwny6/Q5SZwnnnTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CS/460z1RHm2FnjlyEsT1gxZGM9VLk7YIP8Ny0N0MiJ6v6DcIgy03pBOY6iMsIOSe
	 i2XTSXhCTP8xtBHOAy0IPBtNuULyg/Z2SI/baATwhJxTWyzNT8kUSh0/iH0GcZIb3w
	 PAiTVeT2aTOhflRgV50UnS2SGzW13Y3zyzg/jE5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0784/1005] xfs: fix buffer overflow in corrupt inline attr structure
Date: Wed,  4 Nov 2026 16:08:37 -0500
Message-ID: <20261104211105.313617297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


