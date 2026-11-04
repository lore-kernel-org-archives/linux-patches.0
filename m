Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828975;
	b=4xujw90NdmhM16P44VTvAI8dOdYEW8IEnO8f82vLCSNLQXvsOL5gZbInzD8MiwVkQMLC
	 w58jgALT5yYdbHlrMLIIPZD3bTJBMBBll1awJbtROFbAa7YSXT+4quy7W/QToBh8gndzC
	 HAzHMPmCqeI8DdUouwSBF6ZNHBWEEEeWDozyYa9Wpq3Dr73YKChrNWfbnDVRsK+1gDdeN
	 UxkLrHLaF1jg8VMfWHFXP3KKISnt6tW89fHruz+W39Rklv4tN05dIYizXch7kI1bmZ2BE
	 AoIzHOtgkGxOvQrQAYZYrH5dJ3uGIKTDPrQjYhG3pql3t9I/H9azDVg9FR5L2nO3qHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BFas0GGsBbMn/iIgA9sP7FoxixCQLW/ilJb7Ys/VrY=;
	b=oNlH587h2gcJ5JRG9MKxd0IvKXeIW4RIVR8HblTA08YZP8Dsa0TQMwHiKC/GVzN3YmhL
	 kOrbG9skZNHR89HWmCVbX2EDoQfleLUPPxe7G3l6VxTpRHQZesRXyNGeX2Ae/DXA+NGOg
	 zMHYp9NiP/6E2FjiZMzrVV6EWciIKk0l14tVi6+ZHj4+w1fgnG2psyVw3qXg5I6iOPIE3
	 WKjDF1UVll+QJYxXGT3nKURz/FD+BSrT1bE5ScETyfVPEYNG34c1VueIqHdEpCnQDKnoQ
	 P+AT2LWH1xbDgpO/y/rSIy63R98WX33l40iD+l6Iiy58YJIVxNyWmEwrZcfuaw5wMkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FlAAfo9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04616072665;
	Wed,  4 Nov 2026 21:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FlAAfo9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF3E1F000C1;
	Wed,  4 Nov 2026 21:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828974;
	bh=0BFas0GGsBbMn/iIgA9sP7FoxixCQLW/ilJb7Ys/VrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlAAfo9jAGanMc0Zq9z2jRze4EjPEuW0O7WqX4VVsS4ZsYT79Bez/fgNJJEyeEMln
	 zr2a5pfVcYwafSAzzhFVGn0LfI3U+pH/B5RM8YI8Afka60W0cqti8ABsM58n/r6+fR
	 At8b/Uu00MpGfaEIAaouLMHuqO019Te6xWZEPSSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 364/547] xfs: dont try to scrub self-referential dirent in metapath checker
Date: Wed,  4 Nov 2026 16:09:08 -0500
Message-ID: <20261104211048.635586085@linuxfoundation.org>
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

commit 1e7337a3ecebab1bb2ba02187d88b94e5146e4f0 upstream.

LOLLM observes that the _ilock_both helper will loop forever trying to
double-lock the same inode if mpath->dp == sc->ip.  Callers are not
supposed to call us with parent == child because that makes no sense.
Trigger an assertion, mark the scan incomplete, and return IO error
so that this fails noisily.

Cc: stable@vger.kernel.org # v6.13
Fixes: b3c03efa5972f0 ("xfs: check metadata directory file path connectivity")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -325,6 +325,13 @@ xchk_metapath(
 		return 0;
 	}
 
+	/* Callers should not set the parent to the child. */
+	if (mpath->dp == sc->ip) {
+		ASSERT(mpath->dp != sc->ip);
+		xchk_set_incomplete(sc);
+		return -EIO;
+	}
+
 	xchk_trans_alloc_empty(sc);
 
 	error = xchk_metapath_ilock_both(mpath);


