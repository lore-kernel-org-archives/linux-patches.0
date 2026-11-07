Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061722;
	b=N3xyhLlBLkapipTjcMkKnQ0TtLGBYacrnWsx3qv/pqv6Vz9vrOObwE4E5sdUM6UN9vw0
	 M3zz6PLLflI2Z2uPzO0WIjMqIxwx8D0z5NombVORFypk0CdUG/V4v0aDiGINrsjrR2v41
	 GHuntNjXNTHc34A2x99fbx05p50O0XOSIpRXGi1gmbuZsEPaPs6y1YdUnyjwwgSDgJ643
	 lOmnmz1GtSwrz+tixgM4TKM3k8oH+IwObbPgIoNXzC7L2JVQ1PaW5HPVBQCmr+QjfWb09
	 L2i66k8Q2Br5W/5nzpsgVTy0HtzIk+5ETmnGwwrFjjWi7FMt61D1zY2mqf8OSuOydkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=83Q8SCfBiLBSQ0yo6eF8Gm4YCwMDXZgPQ0YT/YLM4iI=;
	b=phft7fOh9iPxobhALqOTqxTnWQdq7G9qJC9rUPgzBDFL3mHYuKU+TlRu2e5VniD+KC04
	 pranPH7UtzNiG/Rn8BrpeEpE3gtXTJJgXrbV2dOkjz0I8ShIzXC3P94zda4umHZb/QVH5
	 T6BxcKRWxIK4o23YRuETMemwbLqDPyltlUW3KrBAzy9nkvnCJx88QzapX49dg9EI5DIQX
	 6B5jA+p6kD6183gsrXw2Co7wAxkUNlKewUY7Rmik8EhhW6+/vM4CRAG+QA7Cg0jHKwoTU
	 mXMKWJ7e9tpnRgOYWkexXE5s2AnDkNZV9IEgFoxkjbC64HasvsflxZdl7njsgTk01DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sGRxshui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BA6606A32C;
	Sat,  7 Nov 2026 14:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sGRxshui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E0F1F0089F;
	Sat,  7 Nov 2026 14:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061721;
	bh=83Q8SCfBiLBSQ0yo6eF8Gm4YCwMDXZgPQ0YT/YLM4iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGRxshuittHfOwpx89TkryjnS/wXIzM0DPtAMveq9ooq1imnPBrlXU/IBPim0kWA4
	 V4i+IXWkZEza4VRh/NLOs/aZSA0qODPSyTsuqzDytbrq6hnPcs+oiOQ5c77ipgGxb8
	 YAbNT2SQM8j7qj0LWtJa7lIZe+m0LIHREMfXodaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0766/1536] nfsd: Fix id-to-name cache entry leak in idtoname_parse()
Date: Sat,  7 Nov 2026 08:46:22 -0500
Message-ID: <20261107135019.046439777@linuxfoundation.org>
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


