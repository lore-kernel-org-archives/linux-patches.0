Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057858;
	b=pQrfa7QcGcQKUDrM4wAcIwcEIQugUU7w4E9uyEsJCRnxzcm/NHsSPzvgJ68Gb3SY4Gbw
	 z1u8D1dg0Nf3siixzWJIiW/imCJ+4goxs42fePuJu0+D1QN86nouDFUGdkQDb9SAZIOcB
	 aVC08V5ITL0Q7Lhn00TW8B0yMB0fz2O9gulAVFcPTlyt2EqWNV1fsyyiAbU3zEmXkmtaX
	 eui2AOpKDUF9esgC/MN821hGkb0boadWygDy2lobhR0xh9JeYU0fyPEB7gSharaBJG73R
	 yB61+2KkMQ54y78xigkd6fpVpqa5F3J4iRNfbuOtGjT37947zu6sNnaH26cb6zJ8K+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qSGHU4xjyW911vO1Edf1rTBrzkAJ3Cmtbu5ChoST34k=;
	b=fFvyNR2U+u4s4n8ytQ53m9iud3lYP5RPEwTgvy6Ups+rfkLEshg5/h+aCUoEeBgNARAq
	 kMOHnZQtCinrI5DphbVlZtz1cAdyn5Ewrfsif8lRJARDn4CIGE4awsn5Ao/IH9bZlRwU5
	 nbeCYSAxk2JSmTmBRG3EnCwtg6xlWYLnQ1rSczMYsn2DjcS38nAowFoYZcoKy1bcd4sZI
	 gL6M69KIatKoYSyxU47x8be6Sb8z622NX8qzFyQakOZM0uNfLnP38S1UXJRL2CFqJ8ABS
	 HIhHW7nkZPd2LsfyoBeWEy4QqYcWaFbd7ZWp+D0WJNFub3licxxdrIMaZ2JRct13XqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cHGeqK/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A455606A32A;
	Thu, 19 Nov 2026 03:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cHGeqK/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E461F000C4;
	Thu, 19 Nov 2026 03:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057858;
	bh=qSGHU4xjyW911vO1Edf1rTBrzkAJ3Cmtbu5ChoST34k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHGeqK/SVD51H6dtaX8a9YlPq5JIC4zKWfwtspsiRGbTg16IZ6bBWdmLXB5lVGP58
	 8FjQd63vWCJ1ADEn8mz+IcWKva3oHxlu4qUTTlcFywFM2OnkP1rz0RFQh36vVOBZE2
	 GP3NyVpaeqmGIeS+vGSMMztn6KT25A5xCjO6RK5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 0280/1848] xfs: opportunistically skip btree block checks
Date: Wed, 18 Nov 2026 15:38:38 +0100
Message-ID: <20261118145923.912130653@linuxfoundation.org>
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
@@ -523,6 +523,14 @@ xchk_btree_get_block(
 				 level, *pbp);
 	if (failed_at) {
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


