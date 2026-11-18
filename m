Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035354;
	b=zyKIVboTJTIZhuwCLg9VpzXUyDy8ECB78n0qfpD82d8VL2ZHWdta8iknKfKoWKGMYrUe
	 y3GhfK4H5aMm+RZsKfoyceX2TvG8WZea9FP88wYWJCNa/cfIipinIv9731BnKf1iDNg/O
	 2X3d6gguHDY+zVzF1wVhRceCzOs589WoQ/77KvVkeDpK6b3tOrkfbSWFqz3rPY1O74umL
	 gck7JdZoJ0DEHnRNrYMKBYTOY0LuviaCX+8oVNBlpxruu7hTZ+e39dRjXhUuPTwtGNAUi
	 5Zlmz1obeWfRDBxOjfSPCnTHbn1Z36M7M/vQwiOpWdzJsSg+p3kIG8nR4cZU8/kpc6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jgitpV+1T4tDjO+BkYTdZ2Z6lld7BmDkcieCAC9s93g=;
	b=sye0gNnRZ5W/1Xn0Fqv1Rhd42PFXSn2WkZaNFKhstT+8/mtFf9YMbaMegsSPoxiYwr+8
	 de1bvwdIPJAhQqhOTTMdOZAEri+LeK+g0dYq/MTL7NgESV3Vh1SXX2GeDbrDWfH/Rh7L0
	 BDw/7h5Cy/dbiEuOnywf77g5P4yBTxlx15dg1fcvCT/asGUH2dba/b4gLLyQ29geNqm1I
	 9xjZbvZsPYcH6HdUyg4j+Ucmd2iG84KLO7HrQC5zQZ7Sb7TWQ0CKNaE4AWMUh0QUpD4Bz
	 PmDwDLhaHoEk7TZDD6Qx0gwom7VCfqUgCidSRGOsmDUM+w5s9iDMSo1sVRbt4CLhv+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0P9Zct0a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57245606A31C;
	Wed, 18 Nov 2026 20:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0P9Zct0a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB95F1F000C6;
	Wed, 18 Nov 2026 20:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035354;
	bh=jgitpV+1T4tDjO+BkYTdZ2Z6lld7BmDkcieCAC9s93g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0P9Zct0aYCVIY+pEOmEwD/WfLrhsoJVh0TyjYYGsd8c9IAvFB0sC+IcfAQ7WLyImY
	 LvpILs8eGx7geamdpChKiyruY0HW550GyQRVjfJr5mryTNWOvAP310p4z/eNb6AjqS
	 cf++/PLbi7WYGgAhaDj0v1Yh6KwsZwrK+q4VVFZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0673/3318] xfs: opportunistically skip btree block checks
Date: Wed, 18 Nov 2026 15:21:35 +0100
Message-ID: <20261118150338.329482651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -612,6 +612,14 @@ xchk_btree_get_block(
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


