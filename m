Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055183;
	b=z6ycJpI79p2la1TbzwunpSDG4m1kGxSq7kWTc0njwBTWJ46kHly1ijyIeqN5ljCjjhZr
	 ZGvR3QRr5PLNQW9mcKR3eCejbmEQBB7LbiGHG/2fBXXg+NL2os0Co9h1EiOjmYCeSad6K
	 ybzn5F7fTSoikqyqQbDQE2GyUd8ahIJLk31kT/gNqKxlfhDwaeeIeufhXUaWi4W33K80O
	 /Dju55akte7r8klHAaluf5EbGaNagw1nnMNyo8aC01ikNBvL1T+SNcJW7DXqt4x3lyeP4
	 0U2kVVv8tHRm6wIOA78NXAzOlLr3ZulYa52F0heAfHqR4ik/oRTNOFwou5PrdIRZK4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zDyEmGMTwG3lvOdK2UnMhd++8g54rHU4Nyn7RFt9gEY=;
	b=zu9cVFFVCzNrKFWSGSrFux71xGZEAy8P7Gz9eyNoBipjyW7YSfvy3Yv0gss5wyWGr1t1
	 CTWtjtylmKXdzsLJofpqNFe+7wHI//alqtn21qdPJ5Wo7llk8iyOSZFePfcEB34CcTv8C
	 geLfdRolMDJuA0Nem+sD10rL1If1Dr7iR0A7PsWbpn7ss5GbGYpb94X/Batj03ICdqb77
	 NK/SZlWHADKgzct/m+yTk3ikgdcUHpUFVBxChszpD6pdH+HdjucjS8jJVnIdU4SPv2wMe
	 kyBiW0q3trWwVb+aIasxNyv2fep4tstLEzLwsb2kQHTKKLV1NNQ7Idw1OdhT3cB2+Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nW4ODq9z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E9606A31C;
	Thu, 19 Nov 2026 02:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nW4ODq9z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EED1F000C4;
	Thu, 19 Nov 2026 02:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055182;
	bh=zDyEmGMTwG3lvOdK2UnMhd++8g54rHU4Nyn7RFt9gEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nW4ODq9zghsBCXekr1+f0rRy9upFtWBQp94mjLfya7rP5vl08gS5p1YwXJEeaqzXR
	 XDU+OYc4FGlipkkuzuwwDg0/qVKU1TO3B6kPBY4ZwaRYroffEkX1npuyGbpZBhMrHP
	 bZQ0fM9jPLNT4lBEmJSV6IRVwymEcq+YuKoa0bNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1539/2214] fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()
Date: Wed, 18 Nov 2026 15:53:35 +0100
Message-ID: <20261118150113.719630992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit a1972501ffb15313f7ae598989bb2cd32829e625 ]

At the end of attr_allocate_frame() the on-disk valid_size is meant to be
updated to the value passed in via @new_valid:

	valid_size = le64_to_cpu(attr_b->nres.valid_size);
	if (new_valid != valid_size) {
		attr_b->nres.valid_size = cpu_to_le64(valid_size);
		mi_b->dirty = true;
	}

but it writes back the old valid_size that was just read instead of
new_valid, so the field is never actually changed even though the record
is marked dirty -- the intended update is a no-op.

ni_update_parent() spells the same read-compare-write out correctly a few
hundred lines away, storing the newly derived value:

	valid_le = cpu_to_le64(new_valid);
	if (valid_le != attr->nres.valid_size) {
		attr->nres.valid_size = valid_le;

In practice that path, reached from ni_write_inode(), re-derives
nres.valid_size from ni->i_valid on inode write-back, which normally masks
this, so the visible impact is limited.  The assignment here is still
wrong though; store @new_valid as intended.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 872586e9598a7..5a210bea00641 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1686,7 +1686,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 		valid_size = le64_to_cpu(attr_b->nres.valid_size);
 		if (new_valid != valid_size) {
-			attr_b->nres.valid_size = cpu_to_le64(valid_size);
+			attr_b->nres.valid_size = cpu_to_le64(new_valid);
 			mi_b->dirty = true;
 		}
 	}
-- 
2.53.0



