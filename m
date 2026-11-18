Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048400;
	b=oDcK1ZYd70E827hRud8SAwMPYibsiP7bzldFSf+M4lQM9hVWqhbR6UtB+HFHzuxGmDBY
	 qXrcyHYT92EsSuR/fGUZ1r2oIvoMPxBgIlE98j6ZkjzKP7WJb+K7tca6snH+uZ961GBiq
	 XXVhqUKc/RO+djUQg1dTjGR4D/0k99/n/F3pX7pRgvsgZ40puWHx3EkMiSKqJiFPIymUx
	 en8cXnxQmCF7EEaeEkR2mGnPBgmp1VHxfm9Enaer+wSYhODNMv1gut0C5We+LKM2d4CLJ
	 RMXQN1gmHCc8OgPyBMG+UZd5hmQvGegBvW5tDrB2zt5zLLnbPMaUuu1LyxADLGS0f3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cQlGejhvor6fplyMg8qmu4ut0ef7N9p2pgLFcZwQ/Ac=;
	b=Uqd4FCTchVe9GcMSiCZXIH60svJeZS4PK+Yts5pwf1xEzwZuRNaPLzJb+F196KBxDuCj
	 vOXovTIUz2IkJpEQnKWBXhtXABhKFOjcXQx9xHLX0FFYTN0rJ/Mfysy1ZH67LCW7M8G3E
	 1TkgjGKewv1enIrwYixdHYkyfnGbaTg9tsWh1dZaxinMO9QI2KU3pQRHCoL3nD9+SAfBu
	 jUMjv1O2OEFoxp0NbeWpS5twoqIqJoyBNI2bF1yTxqY09b3eFgB2CX7qw6Q5+8bLJyCsB
	 xpOp154+G3JT/WKXRJEOdNefS8zSri64xOyjCIvjFcDrhmogaXFOYGPjj3NMS5bsOwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lx4z61Wv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC1B606A325;
	Thu, 19 Nov 2026 00:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lx4z61Wv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE841F000C4;
	Thu, 19 Nov 2026 00:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048400;
	bh=cQlGejhvor6fplyMg8qmu4ut0ef7N9p2pgLFcZwQ/Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lx4z61Wv/viF2G5LIDbTU0yeZXZw4PiIshguj5sDvWV06noQvgK48VTdga/u/fvHC
	 FG0GvPajLaRF/MUgkyaXHpvI8Q8pTy1WvlJrdBr0xCvVkecjUNDJ/kgWf6CCTUGN4n
	 ajcNusIjrba3oQjuIlsCo6F8LrHaMCVvpWm+pGus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1980/2857] fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()
Date: Wed, 18 Nov 2026 15:50:14 +0100
Message-ID: <20261118150312.677392185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8cf7ca39f9637..0ec6d8406a74c 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1850,7 +1850,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 		valid_size = le64_to_cpu(attr_b->nres.valid_size);
 		if (new_valid != valid_size) {
-			attr_b->nres.valid_size = cpu_to_le64(valid_size);
+			attr_b->nres.valid_size = cpu_to_le64(new_valid);
 			mi_b->dirty = true;
 		}
 	}
-- 
2.53.0



