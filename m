Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057900;
	b=DHI+ay9wMYcDHs037tLJd0Ei4Hmub5+nqMCL/0vJMdFf3cb+u3BcjHDkRwto2cUJzBIR
	 LAyGN6nyOuqUh1b2aQVBIkxCcAYH+Oekz5IAGkrJ4hqipSFNw1q5jcmh9m+BkqnbiLqLw
	 ykQ3qFIAamaRhymVeXzzLnJ7jin12IO4sNGfLmzEF5mrRjE3b9Q2Pup8244i1R+6vuEDB
	 MKoH3UHhUU0bF/Zx7MoDFnLE04Hgdym+qmyjO9rs+4ERDAhPNnk7h+Oro9MsdVKbeNM/x
	 pF4LrJ4wtHrbFvklAJVr1gG2vd3PLsNUCi0GMyTsk6gGxIqGHStgOj8u6crIxT1X4kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=713IqDHo62Y9MJnLbIozEGR/oNGllUrayioliW5gpLM=;
	b=FMYMyeSNgngy2qulYHeca4eE+q+kEqMHz2Jp27ihbU5Jqrca+NHrCIwHfSm/1HeIvIcP
	 n7Ho1tgK8fM8BrYcGRgoreJdkMrYjJZJ4iqZ7VbUXV3dyTbHFSJUepJkYOyuEg/xr5pqr
	 cx67YSWBAP3l2t6PJTh2o0pgRAby0LPaJxSKJ8VavTF0u9512qStiitcj136tGRJHAKn1
	 RFnjbo9HuuyjkTr/br8ewV9V0NIAJfk/LFcO/uI/CV1w9IN28PkdD2AtNyCRcD8UQdlKM
	 drJcvc45rMrJcuBoZ/LDa2QsCt+NELn7mNROojZTHyFDIM5B31DciYWmyxXSwoWORjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2zhzB1s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76627606A31C;
	Thu, 19 Nov 2026 03:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n2zhzB1s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F8B1F000C4;
	Thu, 19 Nov 2026 03:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057900;
	bh=713IqDHo62Y9MJnLbIozEGR/oNGllUrayioliW5gpLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2zhzB1sb43llHKJCxavPCwbuN5zQlSKSDDPHj9h2drYIMpk2FhFOzQMKVLwJ+KX3
	 sle/qCC11FTXBVmmBFpMRBN3EHYSyYt3PI09d7WWSqtiLgvq1AliANQEYqtVBenQVP
	 x+MNtkuGvpOOE62KqFZSUCkPJi3c/c2rhpTAYVVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0293/1848] nfsd: Fix id-to-name cache entry leak in idtoname_parse()
Date: Wed, 18 Nov 2026 15:38:51 +0100
Message-ID: <20261118145924.345955382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -252,8 +252,10 @@ idtoname_parse(struct cache_detail *cd,
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


