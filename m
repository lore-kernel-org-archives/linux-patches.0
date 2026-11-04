Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828963;
	b=0O4SOeVhQ/kxq+57p+rzUU5e7kF8511wMkPK6yO/gNaKC1wr48X6eoV3WhhVH6m+7LRT
	 IPsrBj7fCeiiZiipHgbQ7vlCVtTPGW/dr/ilLAcIobrlfBhajmd2mYOG2+pCRXl9iUn/p
	 9PVBvc4j1n6rX5SOZdEm4zqbsHi+8q5rDDqbkzucAKCEFZuWMInMucNBm/fjE0Tm+sYDT
	 sX+sF3NuCIx/omvIM5uLxQGkhkrXw8nAs8VzGSgS/7XFP/f9R1ljNG7aD+ppDNHn2HBI1
	 wJwfHKSxPR/r4ri1yNbp6ujPc+wmHQbKlaXADO5NwllIG1KokxJpskq20AOLQgi+9Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jOiyPJ7+VhhpJjInRsCxagPgsvMGHQK0+p65l20dHt8=;
	b=wRp39wrx3+viuHwjEQaEj1m7ZorOut6EPSmM5pcuULa/kPE9s0c5BvNnA5Pqcr84aC2T
	 RGWi6SH9V8leBxNb8V6nrI7jD9prA44OHG+RoESplUQBfOI4Dz0/bRxqVCZdXD8M6Pr89
	 +e2y4JQF35PjgO8jdVydha6h4S5TFQ2N0+vCYEVAKSuiG5qxe4NVhYkxOBBMpLQXmiHeP
	 JBe9RCO3VNWfcoyh4v3VJ40CijyuED2l76686sqGmxoad/nWpyNuBCqTqFqlM/8ugSvjk
	 5+8+TEwLhKvb4kxxiVwTupXgmnX1U0p5iSxMEEuFkSKSOa1WNC+SIz1B57IyUmrhFqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLXuJCUW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2236070749;
	Wed,  4 Nov 2026 21:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLXuJCUW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F62B1F00919;
	Wed,  4 Nov 2026 21:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828962;
	bh=jOiyPJ7+VhhpJjInRsCxagPgsvMGHQK0+p65l20dHt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLXuJCUWiIn+fqBn2LwxF5A57435CZV/ytX5cK7HEvh0yOCX1qZAIUso7NXFI21Xu
	 1iRdtsPQMuY9/Qj6WcRYEHj58+laf/5eRbXFVUsNQr51VWEKtfB2ojXF1wz7qimGiL
	 UPN1f5j4RFT6BC7PSmqxAmp9lFOUqe+n6bfYYuJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 356/547] xfs: dont clear COWEXTSIZE on directories on reflink filesystems
Date: Wed,  4 Nov 2026 16:09:00 -0500
Message-ID: <20261104211048.397689431@linuxfoundation.org>
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

commit 3978b1f3109dfd5c648442bb040f9abd58608226 upstream.

LOLLM noticed that xrep_dinode_flags clears the COWEXTSIZE flag
unnecessarily on directories on reflink filesystems.  Directories just
pass the hint along to new children, so it's valid to leave the flag
set.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -563,6 +563,8 @@ xrep_dinode_flags(
 	 */
 	if (xfs_has_reflink(mp) && S_ISREG(mode))
 		flags2 |= XFS_DIFLAG2_REFLINK;
+	else if (xfs_has_reflink(mp) && S_ISDIR(mode))
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	else
 		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
 	if (!xfs_has_bigtime(mp))


