Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A73C373BEC;
	Thu, 20 Aug 2026 17:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247087; cv=none; b=Ode35hcbC6rD4O1gi6xNbanw5yoAJl8RVhbtoFkonrN8XjRlfvBfwDmqQD64OsGuJ2Ohf86ff9pNKZfQKZzEyx+gSfLQCCWKRv0eFhmjKMRKPbFcr2g7o4QOevjOXch3xQ4gW0SBGfq90SyI9FguT76xRKjy9ZdD9ZEKs/vLsrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247087; c=relaxed/simple;
	bh=3vi6xf51sDuMBHl1WYEysHU19K9i1D3SnK3jnJuOSH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bn26o1WQ95tEs5NcwkvjlMkFeGKNaPPbnadnBE70zwut7qjGjDsKT0IJQec0UITdV4vKkLKpfvZRcwL1bUmWq0YGYapFMzNaxv2rr3+RvL7uD4bL7LW0K72otEoSDTqXcf3X7uWWBiU95Z/0jLuSOkHPrXeermcZG5gUGUNSBv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aop8vBVe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aop8vBVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888491F000E9;
	Thu, 20 Aug 2026 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247086;
	bh=en4fCEpjAvau1NQ9dq23u1Y3ZH2br8MQyQqSJf7fJVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aop8vBVexTmF+rYroj7x5bEvGbbYrphqQWMHh+R4g3Ryl31ehlOzJKaKhvbBByUHu
	 LEMPXRH6lPanxXBSoIUfkQD/cDGqI4t/tqv1TA4Ek1rzdQXeqvTBXf5M4891vRYDCD
	 JY+vJyTT9RBpQ6VbruvnhbZ+OGkFDuuFPO90P5Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 105/220] xfs: dont return EFSCORRUPTED when scrubbing corrupt parent pointers
Date: Thu, 20 Aug 2026 16:54:55 +0200
Message-ID: <20260820145226.636731122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 8af9cd79cdf6ee96ec610d707db22244fa21eb40 upstream.

LOLLM noticed that scrub sets the CORRUPT flag when xfs_parent_from_attr
thinks it's been given a corrupt parent pointer.  This eliminates the
potential to repair the filesystem because that error code is bubbled up
the call stack.  Fix this by collapsing them all to ECANCELED in
xchk_parent_pptr, which doesn't have that trait.

Cc: stable@vger.kernel.org # v6.10
Fixes: 0d29a20fbdba89 ("xfs: scrub parent pointers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/parent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -472,7 +472,7 @@ xchk_parent_scan_attr(
 			valuelen, &parent_ino, NULL);
 	if (error) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
-		return error;
+		return -ECANCELED;
 	}
 
 	/* No self-referential parent pointers. */


