Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775044;
	b=iIuZ4Htw3OSQAjjYw6gD6P/xkXgzDbsekby0hGAslEiavZUdGPWecqr4silgaLh7OA30
	 3NemYFmUW76eu/sVhQptIPv2fpiZxWr9hS8wFS/PKe+WL6sd7lNmO5pDnGwZHE/QLx4mK
	 kkS72EHjr3UrOWumXC6QtAWLNPR2dwtLcyxdlDN91GgnZ9xtCkQ/GLZfACdlwc7GGQiBp
	 4ZNWvSOYZ8Q/7/9MjA8xtABgdH1iW8zX6LjUBkP0b/F+nq1bC59HYEb9mrVpxeezRaOXY
	 6PIK4x4mZklI7Vc/PKj6WpFiXaLgjsNe/NdNx761FOsRyR1txEZmI5omws9UVzdiFRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PYd5+zEr7OpseWit229ObXi/F0RTJVhXkCa0rt8X36k=;
	b=nkBTZyQRlJzv4BGaWShBtUlKIGAdg5LJemn1do1cchZiA5DSxouGgJ00jMsRsobgLRBP
	 w8MlJSTEHb8/BYy0Ycu7UYNMDX0VSavF3isxX1xy9hZ2IjTSl3e5UBGEdKFb2i3guye1l
	 sm+qizASo3IxTIOamKjQAesuVeD1ydssTfPXjX/nwpThTE6C5JNZxDWhPkFEEU8jKKNpO
	 zp4ang2FatU704C3wjz43MXf23vOsquMygh+zH4KA5j+iBk9y2eLEa2BL+uEMnzgmFyST
	 RAXcNB50ROlcd3zH1BCMLrfY+CGPICpyihsb1OSeIK49YCjBHmt59Jfc0Pu+g3lk5tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srSEy6fN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93854606A31B;
	Fri, 23 Oct 2026 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srSEy6fN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D711C1F01829;
	Fri, 23 Oct 2026 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775043;
	bh=PYd5+zEr7OpseWit229ObXi/F0RTJVhXkCa0rt8X36k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srSEy6fN5OvqBy37FJosjuXQbVHRBZZjdYd9pyxBaujOJ5kpaOs1Vo+Z4pJ/CtmEk
	 GLfmP//9NfMn7Zo3I8oTFsv2nVBHdLmjzCaHWn44GaEoTj4rLIrTFe3uI3PZe3vwWB
	 2wLCdvK4X/b1hhnUw3lENoZOMxhs+ZoyCakt3w7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 241/242] ntfs: fix memmove overlap in ntfs_new_attr_flags
Date: Fri, 23 Oct 2026 18:41:23 +0200
Message-ID: <20261023163719.558415702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit acb1095fd2db884b417cb70808c886e4b615ff05 ]

When the record shrinks while the payload offsets increase (e.g., enabling
compression reduces padding, making arec_size < old_arec_size, but the header
grows by 8 bytes), moving the name first can overwrite the old mapping_pairs
before they are copied. Move mapping_pairs first in this case.

Since mp_ofs is derived from name_ofs, they always change in the same
direction. Checking name_ofs alone is sufficient.

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/ea.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -729,15 +729,36 @@ static int ntfs_new_attr_flags(struct nt
 	old_arec_size = le32_to_cpu(a->length);
 
 	/*
-	 * Move payloads before shrinking the record.  Otherwise resizing moves
+	 * Move payloads before shrinking the record. Otherwise resizing moves
 	 * the following attribute over the old payload before it can be copied.
+	 *
+	 * When offsets increase, move mapping_pairs first to avoid name
+	 * overwriting the start of mapping_pairs.
 	 */
 	if (arec_size < old_arec_size) {
-		if (a->name_length && name_ofs != old_name_ofs)
-			memmove((u8 *)a + name_ofs, (u8 *)a + old_name_ofs,
-				a->name_length * sizeof(__le16));
-		if (mp_ofs != old_mp_ofs)
-			memmove((u8 *)a + mp_ofs, (u8 *)a + old_mp_ofs, mp_size);
+		if (name_ofs > old_name_ofs) {
+			/* Payload offsets increased: move mapping pairs first. */
+			if (mp_ofs != old_mp_ofs)
+				memmove((u8 *)a + mp_ofs,
+						(u8 *)a + old_mp_ofs,
+						mp_size);
+			if (a->name_length && name_ofs != old_name_ofs)
+				memmove((u8 *)a + name_ofs,
+						(u8 *)a + old_name_ofs,
+						a->name_length *
+							sizeof(__le16));
+		} else {
+			/* Payload offsets decreased or unchanged: move name first. */
+			if (a->name_length && name_ofs != old_name_ofs)
+				memmove((u8 *)a + name_ofs,
+						(u8 *)a + old_name_ofs,
+						a->name_length *
+							sizeof(__le16));
+			if (mp_ofs != old_mp_ofs)
+				memmove((u8 *)a + mp_ofs,
+						(u8 *)a + old_mp_ofs,
+						mp_size);
+		}
 	}
 
 	err = ntfs_attr_record_resize(ctx->mrec, a, arec_size);


