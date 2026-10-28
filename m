Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210521;
	b=uwV8KEnG5dDebpPs3j5Y8eqFC27c/pzjZOxn8fNhafXGzITTItkulIoU6MMpbW361pXz
	 BQeYloIWXAKnmi2arUwdzMi1BotN1hz9F+pbhcD3Jh7yk0ahjj6VBp1tL+cwVq/lPtotx
	 v1J0U6xlTtJaVzA8FViAcYldBLGPY8SmIsUyWlrbCKUTKpFQPc6x+kQCiLu0EkcIO05xE
	 LlXEjGsywEImzQDBTKnsPiLpwZ2eba30URbtAwE1QV//VGEPiSAScc2df54NvtaoR3yp9
	 oeVJcdmFj2FDFf3JL1RJGbfsjTCE8dfVl6RxGCnwx4ZW51R5WcJhW4sh6aCbopGaTSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MHdHYTKw9lT8F5Xg8Ra+kuYzELjwVUeUCP4FV2igIF4=;
	b=HVahshyQiBGNFYzCfrul5xxmCGtd4oPKmulBE+TbtCyry4DXDxq7oDvrJcSzbN1TlBKO
	 ibXzQHmLlu9JQosfcYUyCxFLekrAkmZc6w/TaIyCfig+foSBBh9+79lPJPWs7qZEdb4ai
	 4FPczHK5bsvM0zTnh94aUDOZZHlG4oSYd44S51dTP+jugJJJMyZ4CcCq8feQpxiFJUyPs
	 VL1AiAOZyK9p8GTDeZyBQyLumLJ3SufHYGK3WC3OSFhhRfUVctOgkP/BPx8W9zzkLLTCc
	 ppCoZDLyMgU8FQLRClOt/IefKbpbG64B2cq+HIROMYeQ04vmb4uxsrZkckd+xBzqraw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vndBTqTL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C8A606A31D;
	Wed, 28 Oct 2026 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vndBTqTL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332C41F01829;
	Wed, 28 Oct 2026 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210520;
	bh=MHdHYTKw9lT8F5Xg8Ra+kuYzELjwVUeUCP4FV2igIF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vndBTqTLf//AbRwlx2sKaITYQJPwihzgyu6KgvhsfloQn1EROk4w9VYywGUWGBEET
	 rrV4cFzgdA/Q/Z5fnFWs9eKSd0aD8dhdF4ANmTm+aQI7nPo0TkDVSmmH3OkBF6Qq11
	 43IZAct77S3Yb8uA7qBVUiPgSgQC6Ab51jtuV3Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/571] cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0
Date: Wed, 28 Oct 2026 17:53:22 +0100
Message-ID: <20261028170009.333986258@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 6c322f5cf7476ded7a9a20f7be72462065a03c68 ]

With len == 0 (clone to EOF), the effective length is computed as:

    len = src_inode->i_size - off;

If off > i_size, this is a negative loff_t, corrupting the ByteCount
in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and inverting the range
in filemap_write_and_wait_range().  The existing off >= i_size check
fires only after the ioctl has already been sent.

Snapshot i_size_read() once for both the bounds check and the length
calculation, eliminating the TOCTOU and 32-bit torn-read risk.  Reject
off > src_size with -EINVAL.  Treat off == src_size as a no-op,
consistent with __generic_remap_file_range_prep().

Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ added the missing unlock label at the existing common unlock path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7bdeaecc6c508..e3572c30be4f9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1171,8 +1171,19 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	 */
 	lock_two_nondirectories(target_inode, src_inode);
 
-	if (len == 0)
-		len = src_inode->i_size - off;
+	if (len == 0) {
+		loff_t src_size = i_size_read(src_inode);
+
+		if (off > src_size) {
+			rc = -EINVAL;
+			goto unlock;
+		}
+		len = src_size - off;
+		if (!len) {
+			rc = 0;
+			goto unlock;
+		}
+	}
 
 	cifs_dbg(FYI, "about to flush pages\n");
 	/* should we flush first and last page first */
@@ -1188,6 +1199,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	/* force revalidate of size and timestamps of target file now
 	   that target is updated on the server */
 	CIFS_I(target_inode)->time = 0;
+unlock:
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
 	unlock_two_nondirectories(src_inode, target_inode);
-- 
2.53.0



