Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828952;
	b=K16m89TrFCzqMRr+/R/gW54Ln3nXwcGBawRZbkaj77ewZadd02GkpQWqWMNuAESAME/h
	 PGGsrhvHuISfpmTjvLrRVUbGMvwVjMWOP77/3v2jr6LLB10k4GlrYnMGnI/4ejvD2//uL
	 rRDc0x0iBgo0WvIgjiqIhXaaiPOwXYu1/Az6Grvpm8DNRe1spuvu5BGWg8vlnSwbpgnFe
	 lR9QlG5v1nyykpSSBAAqnJXaFVZLfZnjdK+iGB5JnpVIlWfRs81YHPpk58XXIjbNOAV4Y
	 aAoW5xKbkcpjxLtAcON0aDDKavrmxMi8Rg07me9X7ygHeNo+reDhLsHRUmi1h0iuzGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j/jQHAXOv9Lvd8wfYf+MgdUh2QqE4hxUR0hEJbYhwTs=;
	b=DJRe2MlQsIS/7rOnba7VlY+ESY80xMc6ckbOmPdef8aaGHhQgHIRFJXQGMVKu8/3C9Nj
	 H42Of80c6on+G8r9eYHAtBhjLmNN15T+lMWU7VLPwfB/UxqF5UFHrEGLpQbOiiwIjhG6p
	 BKzi7yVHqH9XHa6GRNcVNmFmY4Sr4w0xAfYcLeW09Qgl2gFxIGLjobvxiPd9M3ux+UFJr
	 NqD0NoEANxHYdcssdixBfiJ+1aiFBfxpZHZD37sYgUEL2Ves81yy7j/6hXtzA8CN+leJN
	 K3XrPaFqUAqzDCs0iwrGy7H63fBUDWPpgZeL9IuW8Q3+qTeUj5hO7AplpOlsRpiVafA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pC0zKcIK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2F5607E4AE;
	Wed,  4 Nov 2026 21:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pC0zKcIK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB871F000C1;
	Wed,  4 Nov 2026 21:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828952;
	bh=j/jQHAXOv9Lvd8wfYf+MgdUh2QqE4hxUR0hEJbYhwTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pC0zKcIKvBjLRoNKBaZf1ZhkhHSKBY+xCAibqD+HgylaXBXdDaxK1o1S/WizJ2bZi
	 wE0QZsRAo63Ogva3ilJsBMOALXp9VgEShPeDg8AlX9yUDhPeEd9s2rE3HOAAEkcv+o
	 2VrslnmwIpWwlgsYw3osiGfGm/59/NxfacW/dV0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 309/547] xfs: fix buffer overflow in corrupt inline attr structure
Date: Wed,  4 Nov 2026 16:08:13 -0500
Message-ID: <20261104211046.993122863@linuxfoundation.org>
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

commit 017dd7a84ff4cd2275eb62f4ee6d63c705bac107 upstream.

LOLLM noticed a buffer overrun if the xattr scrubber encounters a file
with a shortform attr fork with sf->count > 0 but if_bytes ==
sizeof(struct xfs_attr_sf_hdr).  Basically, we have enough data to have
a header with a nonzero count, but no space for any of those shortform
entries.  In this case, the xfs_attr_sf_nextentry() call will run off
the end of if_data and blow up.

Cc: stable@vger.kernel.org # v6.4
Fixes: ae0506eba78fd1 ("xfs: check used space of shortform xattr structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr.c        |   11 +++++++++--
 fs/xfs/scrub/attr_repair.c |    3 +++
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -590,12 +590,17 @@ xchk_xattr_check_sf(
 	}
 
 	for (i = 0; i < sf->count; i++) {
-		unsigned char		*name = sfe->nameval;
-		unsigned char		*value = &sfe->nameval[sfe->namelen];
+		unsigned char		*name;
+		unsigned char		*value;
 
 		if (xchk_should_terminate(sc, &error))
 			return error;
 
+		if ((unsigned char *)(sfe + 1) >= end) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		next = xfs_attr_sf_nextentry(sfe);
 		if ((unsigned char *)next > end) {
 			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
@@ -618,6 +623,7 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		name = sfe->nameval;
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)name - (char *)sf,
 				sfe->namelen)) {
@@ -625,6 +631,7 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		value = &sfe->nameval[sfe->namelen];
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)value - (char *)sf,
 				sfe->valuelen)) {
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -477,6 +477,9 @@ xrep_xattr_recover_sf(
 		if (xchk_should_terminate(sc, &error))
 			return error;
 
+		if ((unsigned char *)(sfe + 1) >= end)
+			break;
+
 		next = xfs_attr_sf_nextentry(sfe);
 		if ((unsigned char *)next > end)
 			break;


