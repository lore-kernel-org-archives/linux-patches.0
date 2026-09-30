Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B202151E45B;
	Wed, 30 Sep 2026 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793664; cv=none; b=cGSAesbCl6i6o096MrQf6SzfYYuSAXK99zQIYZo/wkgaKyc6tp+hxKXgC9Ei0vNWRzfODWUJU9xiz7zjhpv87nt8dUfJsmiFGn+XrvpavPAvzq6WsUePjniDBuoE5OSHKMK/Iou5WevS4ewoMzb3wKyoVPv2GkdrELcb8nCo1I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793664; c=relaxed/simple;
	bh=pQ1XS1ckPrUCtRsNfpSJawLtgqz13/jbSRlAizeYmq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaLMK0jjSgfz0gu2auiKlDCIgzFcmLwuaanq5LZ5DTSCwGDnWjAr0wp4cAc4oA9WpXLKewM5aUEFp4tqbiqxSzN6u08RiFzuUwlDSOCXad2cq4n2hbqxNKpJxfWN49c0UVdFA81kxX1IjrkDm7fcfSBohZhR9WlrMiXtL34mOaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyOybccR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyOybccR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978741F000FF;
	Wed, 30 Sep 2026 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793662;
	bh=ZQO9DeZH3Ijqh3a+DwTY6ST5u2o+9d41xNWrMg4eMfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gyOybccRDZF5HHXgSoho/wzherkQlFPKKh8OcAzdMY03KEOiQte/Al3YzixCdyqks
	 tsOoxMqhU8shIXeEqGtX7x0jPaMYn8DkNHr2mHS/wXrMzX5tsCFP8sTN7sxRJC6IEb
	 RXaD3W5RuYz6OAaspJ637o94AJfctk/7u8W3u63U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 334/395] xfs: fix attr fork block count checks in xrep_inode_blockcounts
Date: Wed, 30 Sep 2026 17:29:56 +0200
Message-ID: <20260930152347.906457125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit bb991b7f79dd34cc5f24db0f736bf75630c970e7 upstream.

LOLLM points out that a file has an attr fork, it will call
xchk_inode_count_blocks to set @ablocks to the number of fsblocks mapped
by the attr fork; but then it'll compare @blocks (aka the count of
fsblocks mapped by the data fork).  We already checked that and we never
do anything with @acount, so I think this is clearly a bug.  Fix the
comparison.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1698,7 +1698,7 @@ xrep_inode_blockcounts(
 				&acount);
 		if (error)
 			return error;
-		if (count >= sc->mp->m_sb.sb_dblocks)
+		if (acount >= sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 		error = xrep_ino_ensure_extent_count(sc, XFS_ATTR_FORK,
 				nextents);


