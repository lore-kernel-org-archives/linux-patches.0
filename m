Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828883;
	b=dFl+bK7Jgd9s/4veZqpTlr8FsydIQ2jJutOKXEOzqZl/ptsrpoGe1EJcu+1mpbGK6YLA
	 sqN5JttPw+PoJn7OL+5Qncic2TopghhJw24xzgc0ce3/qGMz8qLN2YTXpmF9CaLCQzP/l
	 90yVlVFjVbd0htygF4ZVHwU2z2HaYfjcxvsFKzwFORKMpfUf0fpmq6WXpnn4ShkmzILMb
	 RZIHGS0WyDFx0K+W/eDroAgB9imhJERMZqSV5RyWwE0qMqFv5O1VnoBV29XXWvOhBo+WK
	 o0XGevqQe1nxzAfm3+rwEJ6Yo65+5ObUcSi71i5mtvUxieQd3ga8jLl7v5ZCu7a22dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U9lM9707UYTEj4VxmHXLlcJTKsfa5n3BcLBu2/x06vQ=;
	b=oKZXdJdAjb10heVUaGd97lVlVeCPXIGR0HgPbVLLgt4inRtL3+1f4KyuG76xSk4PnfmO
	 GFXo2yNg5i6TTNb4EdZ2vaO6OIUyeE7GqIlYjSUWB/0E0FMN+yCYw4RS5dNVSxvusUcP9
	 IDG563V/Nam1zl3w4cGe+7fD2aYglYcv6wHI/brgT2SAYVyK8zhrgH773gDK1MTM5wxWC
	 nhwNdaFPKjAHJwJ+SuVU/1Svj1RBqGmjwHRvLba93/lC+tyBhyqofRO7sWfuEkI5PmVSR
	 J277z4gXNnjaOggyoFpR7DcW72UPHNHYkO8nhRQrAu2IVrW4iCXH0y9mUHmwxuHdq1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ijoa/+CF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A676071AC2;
	Wed,  4 Nov 2026 21:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ijoa/+CF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665ED1F00A18;
	Wed,  4 Nov 2026 21:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828882;
	bh=U9lM9707UYTEj4VxmHXLlcJTKsfa5n3BcLBu2/x06vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ijoa/+CF9+bU0n/G0Cb8vhAgBgOLKaFMGOf8HxfYDNxkj3TsRIijwCSxFC1tVgqpd
	 yGam2CZJRVjn8WPV2BocyUGj7ygN9lsYA5uN01DjjwJb+Hw6sJ+KstS2J1JeUgNBM5
	 7OqeSU20GiFI/v4MPgl+EDF17C+oFnJoKIHgIyNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 300/547] xfs: compute the correct fdblocks/frextents for repair when theyre negative
Date: Wed,  4 Nov 2026 16:08:04 -0500
Message-ID: <20261104211046.727199877@linuxfoundation.org>
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

commit f98d007017acf0eaec2e116ff9c0ece735f61bb3 upstream.

LOLLM observed that if either fdblocks or frextents are negative, we'll
set the CORRUPT flag and exit immediately.  This doesn't work for a
repair because we still have to walk the filesystem metadata to compute
the correct summary counters so that we can install the new values.
Currently we just write zeroes into the summary counters, which isn't
right.

Cc: stable@vger.kernel.org # v6.9
Fixes: 4ed080cd7cb077 ("xfs: repair summary counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -541,7 +541,10 @@ xchk_fscounters(
 			return -EDEADLOCK;
 
 		xchk_set_corrupt(sc);
-		return 0;
+
+		/* Need to compute all the fields in fsc for a repair */
+		if (!xchk_could_repair(sc))
+			return 0;
 	}
 
 	/* See if icount is obviously wrong. */


