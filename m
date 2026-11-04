Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828911;
	b=Ip8Yo2dMWnTd3LHtZbNynj1i/wiqzCnBuNzFqjQpsTWIZfi8zC8zK27T7hpd1YnVyhBN
	 eLqg1y/CGz6GMY6OAy6ir1m4yO7sKlj3YvEtTeTiDZZe3rzszE1nEK7btVK68AmLYcs4R
	 hL9WLzHoH8cnKthMF1T2CFgG+21dhrCSx7+S07F3eQVPjA8ROtniOIeJCIQURYbsL46gM
	 vMzBSZbea2iWvYEu75h63VT/Wxr/bgM4kPAbI6rOgYsmTm7nIMT/z8iqlwTzKGHhBI4wL
	 UirZI51wYIm+LRKFi79UpXLeRDXIlrD9NtdBoLVLucJLWc7Bucz7fZAYMxIm9oHySlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vEjueqxjv+HST0lBYwmBRYkeXwIXjb3y6abEw6t41c=;
	b=1ZISkWWg4t8wyKFVpVmZQZm7g3Pu+ImEe7mjz+SmNan1lmeE6wnLFzr7FMnTEr7YW8nv
	 Tii3M5Ir+1gldva5YSNxqa5F7gutZiVjklw1UV2yB3XF8UK6XUOdgqkaFTigq8OZhEdFp
	 0KMEhooDUXi465xrGJVxGq80/LdN7ivIXLleMocE8nCHwwa4tOFN/MhTaXW73imOoZYAp
	 5R/cV/agSpEbJ80PTzwC0ZAzybAyP5ZkzI5w7AckeAJ926yIpdH0teqA0KMKtlV4LiEIZ
	 XPRMIzkazxRlAWZg8X0lEGmWPAhWk/iE8kP27evASLnBeywnIDx4y4cNadLd0FvPCkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O354Ku19;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58696072648;
	Wed,  4 Nov 2026 21:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O354Ku19
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5611E1F00A17;
	Wed,  4 Nov 2026 21:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828910;
	bh=9vEjueqxjv+HST0lBYwmBRYkeXwIXjb3y6abEw6t41c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O354Ku19WiyteNeAOJ3hoGnOOpZvoeMvw/sjDRGwhK5ENlulcwduuNI6dpYCNLrRy
	 hS5eOHqW/Qq4ue8kCwllfugnjYLpItxsmp8gcto+62bbx7hOxF+VJSKg8Xl9PHILMD
	 2iTBip5Kv+UT5WyKP92JukpKq3mXsOPDpvAbyabM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 321/547] xfs: fix lost errno returned from xfarray_foliosort
Date: Wed,  4 Nov 2026 16:08:25 -0500
Message-ID: <20261104211047.341180106@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 8c4f172c246717b1420f138a159ed15c315a58bd upstream.

LOLLM noticed that we stop the sort early but don't actually pass along
the error code, which could enable repair code to continue running with
an unsorted array.  Fix that.

Cc: stable@vger.kernel.org # v6.9
Fixes: ee13fc67205b98 ("xfs: convert xfarray_pagesort to deal with large folios")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/xfarray.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -943,8 +943,10 @@ xfarray_sort(
 		 * problems, we're done.
 		 */
 		ret = xfarray_foliosort(si, lo, hi);
-		if (ret < 0)
+		if (ret < 0) {
+			error = ret;
 			goto out_free;
+		}
 		if (ret == 1) {
 			si->stack_depth--;
 			continue;


