Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828985;
	b=qTm1TkPYdP2u+hnUrh36r/wEBWHY1elptbhQUgdJBTBrI4xEM1cZCbFGAcR0futrRu84
	 bY0hFR2JVxZKgSsLQaSyoWBnxK3u+AHGOnhxODdHepc7Xr/npb+OnHS1LoHcC9RR5N5sh
	 F0oefmrL9uAMzEWI/kljYuqej1UvUkDi6RuFNUcZ4iJCXqlxtzJ7oYD2sSNwFuvduHnTJ
	 ohqPExuC/KdnsLbHtdVR9qhBNQ0VKbIObCGTimgwS2ZMwckvSEykihuoJj0KLublDSU8F
	 pgBqGNzCRNlZ2+Yw8eZkprSOvDKXiumxysa1OaJAt3xX8vV5THoUvPpB0mpcZuQgyrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4PZVNf5yar09qcBl2mIKNqCjbL4PwQk6cYF6pk1mTwg=;
	b=kYQonahDkukSkSR6zrCVoCU/LC2Vlo15QNGHZL/dSUsxOhL7oxaCe3Co7aYTOyhUfa8t
	 H45DVsskNBlFoQobF2eyiMA/N8sqnz2kdM01kDQLnA8jXKO5QHPUXYBjAhLgZGmLWhooM
	 hT3U8qIK3/CrG0GVcLg08Nli4WFNCRuQwixclEenBk4cCEzVm0m3Bu2TjzM30T9tsNove
	 IBnnP2bn15sQXc4hjqwL/eJj7Iq1qoG5GB+NZhZQlKFKGuXuLBy6E+8wE47XLBEna0o13
	 d/iLSRk93Z7VoISX0AopK47VWrz6F6rb9z5Y2PCnkjfnziOYqY4Xe6O6vl20ow6pkUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAtO6G9x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4574B607F281;
	Wed,  4 Nov 2026 21:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAtO6G9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D009C1F000C1;
	Wed,  4 Nov 2026 21:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828985;
	bh=4PZVNf5yar09qcBl2mIKNqCjbL4PwQk6cYF6pk1mTwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAtO6G9xVtPEF4bjY1gDpfHcf8DVChmyPm2b3sHrFUH/sNp/kZEIs+zO/aU6A6x5G
	 SJNLYT42F+TLikgePu/zV+x22jXT54CtIax+P2rkNYUmQWTGP8f9WfVLLivLi4mTv6
	 Y2yXQLLA1zF2yiQSWA3PeRMhHAe0zHkRoNR7wTns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 370/547] xfs: opportunistically skip btree block checks
Date: Wed,  4 Nov 2026 16:09:14 -0500
Message-ID: <20261104211048.809696656@linuxfoundation.org>
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


