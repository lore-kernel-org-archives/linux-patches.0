Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805BE377016;
	Thu, 20 Aug 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238374; cv=none; b=DZyS/qWK922LmTFxPrAt2WtJO0iC4Sym68KIJr1mWUXxzDPpSg7pHbuh10lu3QUDE0ignzoERHhzVHYufvGZi4gb896pDnkgmNW3WbK2B4DGV9dMMwz6QWdZAypfK4EXOPwQH9qOVd7sIC6xl83/fLXY6IJNZqqkXoqs8BSDAZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238374; c=relaxed/simple;
	bh=wsTigrbexhNUlnknFEHW7HxYEP7EmwpmOWVsdsujerc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eA5z4Ezpd6i2WFjFAY7wWUIg+AQGFomYxAWDPvaG0ZuGTGxXBmTXqpvnHD4SXRq2/WH5JYZgMArZrmXqq3cpMb7KOVXlCH9YNh92/bwZlUW797i/sTPaUiinSpll8atIfWTAfIiatSTXLfHeoxj36qVf4q7IJdXRvve8aGdYYaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nUPgG+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nUPgG+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AD11F000E9;
	Thu, 20 Aug 2026 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238373;
	bh=7kxvaUnHhf3S23LKCvKgRyLhHCE7OMv5TtcE5xBtnx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nUPgG+Bw5cr5SG5sajs2In2fqVPxHi0Bh6v6KA1B0yvD03YL1vAsFKknD/ZvtyN+
	 sZLXvnMxl3178OmfJ2tzZQrnGWp/ZlaXDdxoZ0aAyiklJAdTTgBBjOSCVPM3gJZlpx
	 AkQ082YzWaNpWX9wqbJFeZbEn9ZiC0XWZNt2Ej6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Yang <3497809730@qq.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 125/228] xfs: propagate errors from xfs_rtginode_load
Date: Thu, 20 Aug 2026 16:54:27 +0200
Message-ID: <20260820145248.419203196@linuxfoundation.org>
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

From: Guanghui Yang <3497809730@qq.com>

commit b7e53968cb8882c2d276429ea8550848a4940874 upstream.

xfs_rtginode_ensure() treats every xfs_rtginode_load() error other than
-ENOENT as success.  This can leave the realtime group inode unset after an
I/O, allocation, or corruption error.  Growfs then continues as though the
inode had been loaded.

Only -ENOENT means that the inode needs to be created.  Return all other
errors to the growfs caller.

Fixes: ae897e0bed0f ("xfs: support creating per-RTG files in growfs")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -737,7 +737,7 @@ xfs_rtginode_ensure(
 	xfs_trans_cancel(tp);
 
 	if (error != -ENOENT)
-		return 0;
+		return error;
 	return xfs_rtginode_create(rtg, type, true);
 }
 


