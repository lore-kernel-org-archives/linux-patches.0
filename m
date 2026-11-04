Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828951;
	b=v7ZFYhXAMEM1zyp9Hp7o4DVmLNUCbWS5M6n9m+NNHS6qQNwIY+brnUJrsCTkTbJ8LIHj
	 H1JnF9vuCny9m+8f33fRnABVNK0B4DeLybvMM1DDN5+9mg/G59UKd/AtNm7rgwUYhruF/
	 1ASjGeJjFxMPyWYd3i8h6bD5r7Vl9+M7mxH5I7QmdTywqU2ek5ba62Pqs9udmeUN5LWng
	 yrfoiI5odu9DfeKLxxroEa/QXP0BCXxKNK56/zBBmcawFdTtzovSVQOFc+kn/ZC2283Ro
	 3iwl2oM9uRAIydjWEdiLhU8a25DSGCqIYJ7klvejjpf0/ClGFs7OKiFJZ2vUu3mlizA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2DA4qcLS1d1yKE0q1mYrpTlao4cBL6RkcK4lFpypg0A=;
	b=d/iegkdokIFE31xVa5DAshIzf6ElJOzFj7bOUnvSYjYYVHJHpYS8f2ecnIpbEdgmnQ0F
	 q+M4qVq6yzq5GCUPn5PmUOeVqJrUPHYa9M5PiLLbc/fEekBp/NL9A/9WEEWsCU8s+NCXr
	 oLg2mYrP6oJ5ZnFNqfMp2zZp4jfXGLNzcaMDS39l34uKI+5OcIOzDcMPiwKYN3LsoIt08
	 wUO9yMTnMaqGL1HEsx2iMLhcPEvioSZ7t+N60Sq4flIgHtuAkrDH/TilNJswQ3nFbyORL
	 zUqbfuE5MQx1lUwBsSyJmpQiP0xrUIRggQ8ePvhzbYf6AzBBNV70dMLemUoRPOqJHyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bysxtkr5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0852607E4A9;
	Wed,  4 Nov 2026 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bysxtkr5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611A21F000C1;
	Wed,  4 Nov 2026 21:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828950;
	bh=2DA4qcLS1d1yKE0q1mYrpTlao4cBL6RkcK4lFpypg0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bysxtkr57GK5DQEVq27k3+rJiS4xx4LXWIZq73Fs1rd/JqzlzGiSsGol+quelZAS3
	 x2rQCHWa4p5LdTyemTB8ym6hDdIOX8tKp4sO33rpY/V660FbxPszOIPRaDxT/q7Eiu
	 XJQ5TUW5iN/0GYqcffzYnQGDf2ac8rdT/u6sGHSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 308/547] xfs: fix unnecessary dapos truncation in xchk_dir_walk
Date: Wed,  4 Nov 2026 16:08:12 -0500
Message-ID: <20261104211046.963130620@linuxfoundation.org>
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

commit f60a2ef8d8a7ac6dedf4d0c3325cc3fc2fe0d948 upstream.

LOLLM points out that the all the implementations of xchk_dirent_fn can
handle a signed @dapos parameter, so the truncation here breaks the
information captured in scrub tracepoints if the directory is very
large.  I don't think it ever made sense to do the truncation for the
VFS readdir code for programs that can handle 64-bit offsets, but commit
15440319767942 has been around for 17 years without complaints so I'll
leave that alone.

Stumbled-over: 15440319767942 ("[XFS] truncate readdir offsets to signed 32 bit values")
Cc: stable@vger.kernel.org # v6.4
Fixes: 4c233b5c4f29df ("xfs: streamline the directory iteration code for scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -238,7 +238,7 @@ xchk_dir_walk_leaf(
 		dep = bp->b_addr + offset;
 		length = xfs_dir2_data_entsize(mp, dep->namelen);
 
-		dapos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		dapos = xfs_dir2_byte_to_dataptr(curoff);
 		ino = be64_to_cpu(dep->inumber);
 		name.name = dep->name;
 		name.len = dep->namelen;


