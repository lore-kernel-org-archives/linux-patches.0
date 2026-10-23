Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774992;
	b=PYQxGASVjw059b5EBO9wpgsZOlTqYbOy0ZX7GUHUL4y4uoVWDWxJsMmjhV5vOaUzN2H7
	 iYEgO+z2lndN/TeQcPkyIYkone7a28xPlNH28FllcM7OHnkVkwf/mXLOIinHLec82tEOm
	 PABr9frPWTjgOqjFmo2JxstKukchgWaeDnkTdg3M2pLQpPTSyDeYmASOPpOXN/J3bxqrB
	 om8vRg8DC0FPMn5p35R0crSdquOkU1XtiKcMckvN5w7VLr8x7nUESKoXGyVoO8wfrIInc
	 jZmIIZrJY1sxfTgRGGSQTP016JbsCGz15YSNiTcICtQO+eRRLpOoqj0WOsJXTvfIrDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hqaxmwBLDPFIQi5GDUvFK6yviJY64agYzQich0RDDIY=;
	b=lkSS6xHh4pnNggnEz+v9m4H6sI7HTo53RrW2A2d7ONXOhUR7nMlWH1Z0kYTYgYY88U+6
	 uDY+PWlLW8UHvUwKLAgkeHVB5su7n21LShF3rUfC2IjrzKTAUmaqu25Hi8Ulttjpa9EzL
	 a0UoJeyvH/b9trBkdBEnYI9A595Dn/bNimT/I7IvTaXdazW+mKiXEyMORJHaVRNeUT+NF
	 6ugMZEqvbmZ1qaAoIDZSikpMphDyndHDL/Xh7/blUqZqqSpipGrnoXzy5yJW2hDXoc6IO
	 iCQbbUuQ/Mcpu6vL3I40txpWE2ne1n61zzlYwkO7xGVwHJWRH1NkjRTjU5nWV7CYfKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4dMVFrp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E90606A31A;
	Fri, 23 Oct 2026 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4dMVFrp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276071F01825;
	Fri, 23 Oct 2026 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774991;
	bh=hqaxmwBLDPFIQi5GDUvFK6yviJY64agYzQich0RDDIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4dMVFrp970HU99z/CuaO7nHrOedkN+TyHcv3vBOSWEzl+77JCeBqPXUD7aYlASvC
	 U73z+1aUubypsnZ/mQEOWXPoJwUilc2f+vI3Tx8edogbCTCx6FUidh3EHysZNS+PoF
	 9TdkS5qvGOvhgy4dgtSfy1aJauqFD+6uoZj9rIs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 226/242] ntfs: fix incorrect MFT record pointer passed to ntfs_attr_record_resize
Date: Fri, 23 Oct 2026 18:41:08 +0200
Message-ID: <20261023163719.183134678@linuxfoundation.org>
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

commit 8d139e3635c86e2c97c78d55538ce0b00b6d9986 upstream.

ntfs_new_attr_flags() passes the wrong MFT record to ntfs_attr_record_resize().
When the attribute is in an extent record, ctx->mrec points to the extent
but the function receives the base record pointer m, causing incorrect
size calculations in memmove.

Fix by passing ctx->mrec (the actual MFT record containing the attribute)
instead of m (the base MFT record) to ntfs_attr_record_resize().

Fixes: fc053f05ca28 ("ntfs: add reparse and ea operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/ea.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -699,7 +699,7 @@ static int ntfs_new_attr_flags(struct nt
 	mp_ofs = (name_ofs + a->name_length * sizeof(__le16) + 7) & ~7;
 	arec_size = (mp_ofs + mp_size + 7) & ~7;
 
-	err = ntfs_attr_record_resize(m, a, arec_size);
+	err = ntfs_attr_record_resize(ctx->mrec, a, arec_size);
 	if (unlikely(err))
 		goto err_out;
 


