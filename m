Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831697;
	b=oYZTyfTU5Crxdbb1fuPIs/PAmHIWYZtwCffouqX1fNBmfqLLFw1OMw0I3UD2Pr2E34Dg
	 95XFSuWgd9Ll0aByldhoSB0z/yK9PeCxHrK/ZxJJWuY+jOBYV1g5BzjLS0FeWOZyqIn0+
	 udN1Jl/XhiJ2CNkfq+Ii5//jk3ltXbzC/dWIk8MbGPT75fJHTJMfCB3ZScm1OKbI4+z1Z
	 q0nYtJn/5gq5R5vdBFdwfJV93prQMX3TbfSTLDtAH5spsBbzNZQbWQ/6S4KtX2HiOxlsW
	 5u+/nv0pw2bOTFaQqmju781aOWai7mvSbSgp1rN/oawtZMheoNTp6FKXlwMG+TkSLew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q/WLuMx3pJHVGmBB/lu1vXXmkho+vC4jJ0woq1lo6S8=;
	b=LTn4y5zbYdNMMx5GbsK7114sCrNbL88CW47OoN15S0dggszzScgl78E2MkX3oculwZ3T
	 CsVuySYa3joA9h1D0hDFIGYycadrI2cDkLSJab2YpNtUa8XXGx/y45PdIb90CoQI4DWyF
	 X2kAOOYvhnZdi923++zqZaWqd+7aRyyiewMxWrgSn78l2eelSOnHI4p/sfgqmSKqGp6Av
	 50uCCA0aqduISrRwQt5QTlPWzJ/lB0aKqLRPmUo+BWu7xMglllhT4/aa1Nj3JATrySMCX
	 yUMbgAXjqURRwmDCZ10eC90tGVgBwnlcN7EhUHWZo9o3skLc0cXtI9NkQ5vsmweWaJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXc8VLTz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3479606A332;
	Wed,  4 Nov 2026 22:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXc8VLTz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC051F000C1;
	Wed,  4 Nov 2026 22:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831696;
	bh=Q/WLuMx3pJHVGmBB/lu1vXXmkho+vC4jJ0woq1lo6S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXc8VLTzjJ/0LqSSkvcGlSV0wEs2Qs2SlmpcsIz0mWhEdaRgSsju/ySLfXUY8Seeg
	 uCo7dIVTvleoZKzoPSnmmrTHtS2/faJl0o8BWnp2SNnNdR/9rzope6oB0n+sNK6OWi
	 jq7yi+yptCrxCkh40sZncNsJoyJBaIbuToZtpjeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0861/1005] xfs: opportunistically skip btree block checks
Date: Wed,  4 Nov 2026 16:09:54 -0500
Message-ID: <20261104211107.397122204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 4ce244b234c251963fca6dff9de6edf26a209d08 upstream.

LOLLM notices that both callers of xchk_btree_get_block will return
early if *pblock is NULL after a successful return.  However,
xchk_btree_get_block itself can return 0 after flagging a corruption.
There's no point in continuing after we've found a corruption, so null
the pointer out.

Cc: stable@vger.kernel.org # v4.15
Fixes: cc3e0948d2686f ("xfs: scrub the shape of a metadata btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/btree.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -608,6 +608,14 @@ xchk_btree_get_block(
 	xfs_btree_get_block(bs->cur, level, pbp);
 	if (__xfs_btree_check_block(bs->cur, *pblock, level, *pbp)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+		/*
+		 * The btree block fails basic checks, so we know it's corrupt.
+		 * There's no need to continue looking for corruptions, so we
+		 * null out pblock.  If *pbp is non-null then it's also
+		 * attached to the transaction so we won't leak it despite the
+		 * 0 return code.
+		 */
+		*pblock = NULL;
 		return 0;
 	}
 	if (*pbp)


