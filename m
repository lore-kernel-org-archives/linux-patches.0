Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828984;
	b=Vf2t3iXg5S/1aiveD2NvvwClFKHxh/VAveHgPoSbGMCxPD6UdApbj+KoAohf7QwNkUSn
	 acw/iqwayWWngQTFxF6w1VRKZf0OVaspo7pr55EWXNjhrE8DKSVDyN7soNK+2jNav+MXe
	 n9rMl7RTkUL4YTBytMt8HpsY3vbEKJDkz0S3TgJdLGp3060iJf8AJUrSVOBYg28Q4A2GZ
	 LfjUr5cgKzfgPE4C46OzUA9iXkQu8CCwei7OZLTJvzyD/uzjyyFQDmqCBvfD4ohp2sgUu
	 7ekqyeOGI9NYSZSDzxt8hgXysED1HgTN6610OecRJxZ9fdchFFWy/wu3gQHkuqSKn1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=604gFFFUeNmJbAia5kU997I/KitpKU3FzzIN+6V6Asg=;
	b=vcbUpu0lpUPCUZoThjoLkhjnOfefmMshnwyWdSvTvrU2vtOegh5FQzXDPoRW9uz5eVzK
	 vJVtemS+3u1Zg7MIKm0SteSMT8Mtr+/Tr7teIwrvla4Qz+jXihq1WHnptbR3iJJiCEZeV
	 tMGWS9UF5+6eSt0DCu2Vnpp8nnscgmKHh/4b8W+1hIlTEnPfojCCqHFLLY36bl/h54Jod
	 DNTiBn4qI5pph4mbVkqU5h5DEcfqeNQnsZu3vPLkfjBtvWAxjFH6ygguXKR4aeAGBUlTO
	 08Lma0fQ1Jl/YJbH11bBd2veZjxYj6/qG5cHpV6VRckgEAjdm6YcCo/X/qg0zpMx+IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8QDLesu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E20607E4B3;
	Wed,  4 Nov 2026 21:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8QDLesu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518DA1F000C1;
	Wed,  4 Nov 2026 21:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828983;
	bh=604gFFFUeNmJbAia5kU997I/KitpKU3FzzIN+6V6Asg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8QDLesux7IYFVtrpB2UCMcgzLmhIofQZU5SQfPDPmFA28rWzLOvMQxfV2Sb+TsDJ
	 0puI7N4Ro7NKpqcyOz7ua2K+FQcAjiCrmdOtyzWFejcWevGIB0xdij0mhqXSds8JuZ
	 qMPduvzQEqc51ctGOyBKzkzhhwJktSJzpM29z3+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 369/547] xfs: only written file data blocks can be shared
Date: Wed,  4 Nov 2026 16:09:13 -0500
Message-ID: <20261104211048.780104465@linuxfoundation.org>
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

commit 634b63baf05062988456a0bd5df2696c14ea2949 upstream.

LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
will count any rmap owner towards the shared count.  However, the only
blocks that can be shared between xfs files are written file data
blocks; and the only blocks that can have single-refcount entries are
COW staging extents.  Fix the checking code.

Cc: stable@vger.kernel.org # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -129,6 +129,18 @@ xchk_refcountbt_rmap_check(
 		return 0;
 	}
 
+	/*
+	 * The refcount btree should only have records for written file data
+	 * blocks or for COW staging blocks.
+	 */
+	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
 	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
 		/*
 		 * The rmap overlaps the refcount record, so we can confirm


