Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829064;
	b=3H2Ut8uBo7XjkyVTGIBOKAw36EzwAXsy6YI04jSo++0L7sPZi/o9c9rlVWwloYrxiM48
	 VP9WeIbcR81+vQOpwmcG6sPN06Ceega77dQOZIzTq1Ni0KYFhzHgQ6kcyrP3E/rect1TE
	 Rw9bYknjJYpAddV98Zvv/Lstrr25l/Fv+C10CR5IzTzfw/136vFLhC0zfTqiGFJycMjJB
	 zswwOsXW4gPY4sWhwTA1ffbHD8z6sxdUkT5c4vvQCny4bPMwnKeNzvVrjgGm+4+HVPlcl
	 nsDXnB/KJpttjPSL4kb9G4VPA60bOz7Sh1hVKbw7OxtTGdzG1Q4+x025SkX3iK3QwmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7gtKkAe3x+9RbYlmMx+2lv77z3QaGQB7Chh0lVCei5w=;
	b=jiyuXeEK2YDbunA1X/f2avX7FChAnVHtD0ChcVT+fYTYZpbj2VWMirUlhulfWj5t+lV2
	 X9hs4iWGGl8+/Pjz+qhfPNI60t9gN+JsVzDUhzxhiOLU6eGFTkZiQUEJ13ru1OQLKjKDe
	 6NYotNV/EnjLMT8Q/g8Nwdqh5l78Y7vNaLNKT/1RQv8UXj2TaVtfcBgLAk5gbG94LPRqn
	 SuMs4w+Jp53WjGwgG7Dl+tkH1XfQ0lY9dmukIuUOlEXpQzih1lzlDsK0w08IxQDnSwC7k
	 yaXdF9VkX+6vGwGDYgV6XxPyH4MrA3sir04OuBS95vrmUVpN4TJifV54d4XUOBROEVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pCuDQB/t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7CE6070775;
	Wed,  4 Nov 2026 21:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCuDQB/t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2661F000C1;
	Wed,  4 Nov 2026 21:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829064;
	bh=7gtKkAe3x+9RbYlmMx+2lv77z3QaGQB7Chh0lVCei5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCuDQB/tJnqQB+133r7lYWCpkrKGK81RNf/CYYP/1hb+2jK521nn/oc8RLpK3pDiK
	 ljAkXVk71BvDjDE2GnHcT1YZ8pecSqPMKV3x6TR1/t8AG6MF1u1yv0h9kQmRzAb0oP
	 F/6BMq0a1uqKmlYEKUmjANtqYpfpwoUX8eY3Yiks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 420/547] nfsd: Fix id-to-name cache entry leak in idtoname_parse()
Date: Wed,  4 Nov 2026 16:10:04 -0500
Message-ID: <20261104211050.265306620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8ca3b74c0c447af17d0e27e76658a3d4cae3c5ba upstream.

idtoname_lookup() returns the id-to-name cache entry with a new
reference. The name is parsed between the lookup and the update call,
and when the parsed name is malformed (negative length or longer than
IDMAP_NAMESZ), idtoname_parse() jumps to the error label without
dropping the reference returned by idtoname_lookup(), leaking the cache
entry.

Release the reference with cache_put() before taking the error exit.

Fixes: f9ecc921b5b5 ("[PATCH] knfsd: Use new cache code for name/id lookup caches")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260917163154.2162438-1-vulab@iscas.ac.cn
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4idmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -253,8 +253,10 @@ idtoname_parse(struct cache_detail *cd,
 	/* Name */
 	error = -EINVAL;
 	len = qword_get(&buf, buf1, PAGE_SIZE);
-	if (len < 0 || len >= IDMAP_NAMESZ)
+	if (len < 0 || len >= IDMAP_NAMESZ) {
+		cache_put(&res->h, cd);
 		goto out;
+	}
 	if (len == 0)
 		set_bit(CACHE_NEGATIVE, &ent.h.flags);
 	else


