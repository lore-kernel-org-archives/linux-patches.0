Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C052A1F867D;
	Tue, 17 Dec 2024 17:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455841; cv=none; b=biK8Ql3gSUqL1rM0FPR9O2v+Q3N4W8bSiIOj6doeSyX9ww+8TYkFMtVh+tW/xA4H7adBNP/EPst3P9F6tbYNUrZjONNJtbszJx6GpEjqX9IFt9mB+Ciesq7FtlwHEhR++HuvT2IkRJJV/xsExd3Dupa20QaETs1smrWCJw8OQeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455841; c=relaxed/simple;
	bh=7YBl7DI/lG7ey5DHPgHahlib0mE7B/Vd9ZsOgOSbDLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mA9RYBIaEDvgfjeA1p9atZs2AWGKwFlfm66JLpFo1qhR0ifDw60VQt+/HoSYTabTwUz5v7WgzG+5TzSUeHgJAZQsoM6+AyVb6TtXsI73JeNZF3uy8rLIH+JYwE7astEYKARkqW0fy95gj2CoT6/tNV9CZTA4ynFFN1YPaQJ3gKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXi5B3Ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXi5B3Ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492C0C4CEE2;
	Tue, 17 Dec 2024 17:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455841;
	bh=7YBl7DI/lG7ey5DHPgHahlib0mE7B/Vd9ZsOgOSbDLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXi5B3EidFAGxCnoK2Cg6z2Pyz6u6UqQm+G1u75DmNenVGmx1brfjfAsCC47TLcfr
	 VG6c33pwyWBNw1Y9WpttNr52e5gO5A7UEYNvpwTwk20Z9UyMvJcKTYbaUierQK6m2B
	 86asl9QNoyZ+LbIZJTTMrtVPY+6EOqtqZUFySPTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.1 20/76] xfs: fix scrub tracepoints when inode-rooted btrees are involved
Date: Tue, 17 Dec 2024 18:07:00 +0100
Message-ID: <20241217170527.093831649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit ffc3ea4f3c1cc83a86b7497b0c4b0aee7de5480d upstream.

Fix a minor mistakes in the scrub tracepoints that can manifest when
inode-rooted btrees are enabled.  The existing code worked fine for bmap
btrees, but we should tighten the code up to be less sloppy.

Cc: <stable@vger.kernel.org> # v5.7
Fixes: 92219c292af8dd ("xfs: convert btree cursor inode-private member names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -464,7 +464,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = cur->bc_ino.ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;


