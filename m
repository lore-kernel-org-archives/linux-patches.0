Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00BA1F7582;
	Tue, 17 Dec 2024 17:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456474; cv=none; b=A87Dv+q8CaF8Uomg38F6FVEESdDJd1+0XETdEyIluhJGgO7GVvIfE60RuWKvOy5uH4JqVX4ycH6/pG4agCKyOzFBsTZ3wVAs6Oehm7U+1CQZgEpj/ifiPln8UlF+5olmjoBbq4+Z/U/No+SZkCeOqDt2xLa21dp+F165oT/0NYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456474; c=relaxed/simple;
	bh=3+r9Dy6zkyqgK+3xZTUQwCOCZZtD3DRIt8k/WZ8IWDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRWi8B5IGv8cAgs8zR4a9UScVrfN/7RAJZdFmxKqS3Zg4p9pywrX2mjen5WG9oXN2iVYKZrdeRNigo4OuQFjPUKI4RBFqb98PxRo97ayrZP8o3HqSp4uKkp59IcMFoTbQPDcTxehoGVniI7e5+tHC9EX6yaX543axCUczmkzn9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stM7bbsm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stM7bbsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1317C4CED3;
	Tue, 17 Dec 2024 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456474;
	bh=3+r9Dy6zkyqgK+3xZTUQwCOCZZtD3DRIt8k/WZ8IWDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stM7bbsm08Upi9TowW5k/JsQ7jH6YOcxqBwpsw31BUB98q1RrsVIHFNx1Qw2tPcE5
	 O1JxrdnA2s0JxXuKO0cOAd+tUsi4s00nBpcTjUI82RC0xppJnYAYBKCicbMRoI/LPy
	 +1w3rk9WkqDeGWkgRI6ipSAoCu+hOXlqGxUyx7E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 071/172] xfs: fix null bno_hint handling in xfs_rtallocate_rtg
Date: Tue, 17 Dec 2024 18:07:07 +0100
Message-ID: <20241217170549.229695447@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit af9f02457f461b23307fe826a37be61ba6e32c92 upstream.

xfs_bmap_rtalloc initializes the bno_hint variable to NULLRTBLOCK (aka
NULLFSBLOCK).  If the allocation request is for a file range that's
adjacent to an existing mapping, it will then change bno_hint to the
blkno hint in the bmalloca structure.

In other words, bno_hint is either a rt block number, or it's all 1s.
Unfortunately, commit ec12f97f1b8a8f didn't take the NULLRTBLOCK state
into account, which means that it tries to translate that into a
realtime extent number.  We then end up with an obnoxiously high rtx
number and pointlessly feed that to the near allocator.  This often
fails and falls back to the by-size allocator.  Seeing as we had no
locality hint anyway, this is a waste of time.

Fix the code to detect a lack of bno_hint correctly.  This was detected
by running xfs/009 with metadir enabled and a 28k rt extent size.

Cc: <stable@vger.kernel.org> # v6.12
Fixes: ec12f97f1b8a8f ("xfs: make the rtalloc start hint a xfs_rtblock_t")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1295,7 +1295,7 @@ xfs_rtallocate(
 	 * For an allocation to an empty file at offset 0, pick an extent that
 	 * will space things out in the rt area.
 	 */
-	if (bno_hint)
+	if (bno_hint != NULLFSBLOCK)
 		start = xfs_rtb_to_rtx(args.mp, bno_hint);
 	else if (initial_user_data)
 		start = xfs_rtpick_extent(args.mp, tp, maxlen);


