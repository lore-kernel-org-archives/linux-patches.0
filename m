Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037297;
	b=lzTThH6MTrI9Bj631kOUhbxbzOjhugjr9uzgxcIjkJXiCum55b0acI9QCXefMR8VKSpx
	 eDEHkbqTeRL/9/OsdbiIakuPYbdWa8BGMxSL5rAnf6kCa37J4Zz0nEeb0P36IHDqR6Fmy
	 mTpL58yAubuHIjZrSXiRiRkt73CHSRofeBfyWU3jVO1hj1UCP+H7FmzRC4UG7WE5NeNp/
	 TpDVFelC9WqUxHJZevhotVoqUCOuuIRxzQpEzriFJOnQSM5HUjOHk1cqxSkwD7/za2r98
	 phqf6Zi8N2TkB4j93X1GoNO06fmNd0m9V+jAXdCI27163loTl6Z/dHfTRsWRUZzHoEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mzUQvKGzxlbr4CP86ANp/UTVGGj0+50D+8v7s/Mqj1Y=;
	b=eQVWP8meVhHVulpO0CQRubuLsvj24ZyIs3YxQpjL6+2ZnwAExwRn/BTYhtSYuGgevAnT
	 ohgio22AE5oV0sv7oFh525t55qSyuoXeDj0V/zRlMZlNs0JxFnVNF1mMtu5d1kEW0omL1
	 OamrIhtqZMLRULVDU82z9ZBOih1umE71+ESMtxRO4Rs0l6rGaQNYJvGOKr0taUsX3oQ46
	 TszXHDIQetOXvwwwUF/y3qJpujhUdJq5VhM6bMEJRgh4w9emnJLamrbF8sI8KS120I652
	 2eVjA5Aa63sLzbKbOYTyoSMRVafXERk5Nmwx21EITD8v/Q7zUjQANWlLzVB7AwJqWHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSXOvtC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7726C606A325;
	Wed, 18 Nov 2026 21:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSXOvtC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29DD1F000C4;
	Wed, 18 Nov 2026 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037297;
	bh=mzUQvKGzxlbr4CP86ANp/UTVGGj0+50D+8v7s/Mqj1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSXOvtC42mL/rO16pXWKdy695M7G0V4Ktd7/r62nKG/ILD6NifUxHD7Jv53bXpFJu
	 1F55LB82qNJHwkcWnkZoT2JoXzQkDeF/uUlvHcOZITTTy2J8rab+6+lXKRe/1w1jz4
	 FQxvHwnwUjBtMpSClpLWhd/1PtUNIMbWKf8SmoaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1357/3318] xfs: fix buffer overflow in corrupt inline attr structure
Date: Wed, 18 Nov 2026 15:32:59 +0100
Message-ID: <20261118150401.147792094@linuxfoundation.org>
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

[ Upstream commit 017dd7a84ff4cd2275eb62f4ee6d63c705bac107 ]

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
[ sashal: Retained sf->hdr.count instead of sf->count and omitted the hunk for absent attribute repair code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 5e5115bf6c05f..04fe6446e9705 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -564,12 +564,17 @@ xchk_xattr_check_sf(
 	}
 
 	for (i = 0; i < sf->hdr.count; i++) {
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
@@ -592,6 +597,7 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		name = sfe->nameval;
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)name - (char *)sf,
 				sfe->namelen)) {
@@ -599,6 +605,7 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		value = &sfe->nameval[sfe->namelen];
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)value - (char *)sf,
 				sfe->valuelen)) {
-- 
2.53.0



