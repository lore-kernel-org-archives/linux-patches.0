Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC54386C1C;
	Tue, 21 Jul 2026 20:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667240; cv=none; b=C2yVpoEzzpsRIF1vnH1DIek3gpMfSriB+2PmrF9Kmq9e13ehs5zchHH16suBxny88VQ5Xpz6JjKMLu+VfFMYM8oUWogJove0CkQxopLTDCs9blaUD/6jU0nD0rLmBp3MmngVxfQZSlABwcUHI5CfykHFJGLeRjMkkFQOWKOGQ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667240; c=relaxed/simple;
	bh=QW7q9+HJSz6TlHNE5wwZRNO11wAPQkkQ9UA3/nORk/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cw8/tX6CiAIDmn1ie9oTT8qBhYJCaFZkQm0DWhv5KB1aPmHmnHgt2htxe4XRpoTWbpClwidJScmSi16VlbEsUa1uJpnOO6gQUW0K1kQNcBXXXjrCmm7nkKJ3M+84cb3PmD9Svd8vWrv19TdYFpw0cgSjp0ZM4RFJgaTM7XXf1E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlJbqdvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlJbqdvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DDD1F000E9;
	Tue, 21 Jul 2026 20:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667239;
	bh=+gog41cKWHI4VqJVsqSSKLBLsYHVhlun/JKUV9C0bzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlJbqdvxWfs85n4K4zKN96lX29HJT5qwATOdZO1owRBu0KngeVV3Uvsa7Br4dT4Jh
	 0gYRc3nFaWWOlES4l7IJ9CS0Q124UKuWoJA26MV6gTFYn3cuIO+/Z1eDAvwtMf0y3q
	 DKpmBWtZAFFEIo3cpD80idjpVxzzqwSTYbcRyVDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 0986/1266] ntfs3: fix out-of-bounds read in decompress_lznt
Date: Tue, 21 Jul 2026 17:23:43 +0200
Message-ID: <20260721152503.900168793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 7160a57192fb16d7a6fa9b7f5c7ac341d2444a89 upstream.

decompress_lznt() does not validate array index bounds before accessing
the decompression table. A corrupted NTFS3 image with invalid compressed
data can trigger an out-of-bounds read.

Add index bounds checking to prevent the OOB access.

Reported-by: syzbot+39b2fb0f2638669008ec@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/lznt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/lznt.c
+++ b/fs/ntfs3/lznt.c
@@ -240,7 +240,7 @@ static inline ssize_t decompress_chunk(u
 		if (up - unc > LZNT_CHUNK_SIZE)
 			return -EINVAL;
 		/* Correct index */
-		while (unc + s_max_off[index] < up)
+		while (index < ARRAY_SIZE(s_max_off) - 1 && unc + s_max_off[index] < up)
 			index += 1;
 
 		/* Check the current flag for zero. */


