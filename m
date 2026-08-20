Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C5937E2E6;
	Thu, 20 Aug 2026 15:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238383; cv=none; b=XLJewyAFqUTXRscrmPFAHyxHAaUxiWixrNP8xXfoZKSZlHWaGU0vurjMgps6GYv3ojmndnzhAln32tsYa3CqcMkLV6F4uA3oNVhRlrK3FHWHdm12y0nDfknpqXIGsBDaQhGkl8Fm3IC9ZLYmJGh5myz8m4VYEw0XVUeUK72nUfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238383; c=relaxed/simple;
	bh=H5maF/r2vRnzhYFS8iKnmfjgQuzDt6+0LdmWLqamUxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfwZzdKDK/NlAycMc6fVMN6LaR8wHcmpA452aq4Jw1A4ay9Kckmj6KrCFLcW5CaKgvw5MmuZI49d6V7cy1t83prMi37dgPLFfGNHr2qH2u0m3jHvewX7hNFCRS4GOtggw7BDm1x6d1ZZW808kGQqdaGpWksCto/d9+acqgf47tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cmfj9KLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cmfj9KLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6B71F00A3A;
	Thu, 20 Aug 2026 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238381;
	bh=0OLWKRsyNJaFMkr9EynOJye+pVevixGu64S11A7/wnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cmfj9KLGhxDNuUNwJ8U2Gc5Uj/8v5v/79P75lJN4ZaIud6rxkEFG0/0cLh3/mLOuo
	 ivbjoTrt17eItw0F+8cfthp9EwGe6lzaWou5VVpIurbE223V5KGg8kW90m+bGuZNdz
	 c+P6+Ez5q0nRkFNeoGR0r8EdHQ04SOqH8NR5OyZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 128/228] xfs: mark nonzero sb_gquotino as corrupt on metadir filesystems
Date: Thu, 20 Aug 2026 16:54:30 +0200
Message-ID: <20260820145248.505631000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit b28d23c51635b646784a2a62c71ba99458c07d5e upstream.

On a metadir filesystem, the superblock gquotino field is always zero
because we find the quota inodes through the metadata directory tree.
A nonzero value is therefore a corruption (as pointed out by LOLLM) so
mark the failure as such.

Cc: stable@vger.kernel.org # v6.13
Fixes: 06b20ef09ba163 ("xfs: check pre-metadir fields correctly")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -266,7 +266,7 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 
 		if (sb->sb_gquotino != cpu_to_be64(0))
-			xchk_block_set_preen(sc, bp);
+			xchk_block_set_corrupt(sc, bp);
 	} else {
 		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
 			xchk_block_set_preen(sc, bp);


