Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E1F4B44C4;
	Thu, 17 Sep 2026 18:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671223; cv=none; b=iSZlAgmATJZ2dgjEJmWlj+mukGknFt3QUJcz6NRazVUv1/deV8wXr0FnCP+p227SJBG1odvaHhGbXFtW6dYSbf98N7CxWPW/P1jOAyEn5AvvUM1HzzWjmTXBjfkBd2lw6w2fjqwVIMpm37eFquMroDyQQrWg7B8GEz8QHmfav9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671223; c=relaxed/simple;
	bh=5Xs53kMaWr8aYNPgjokSpWVlCAEh1I20OQXdNZUAJm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbLxF5topDFkvnH3QlI5VrLVJUGR70DOKZSNX0k6irra1B2spf6Fe5QPQgxmFodDpE3y6JAPzUqpiEDedKwSySUi5aDcjvOLHU8eSJ+OCB+v+ENcbcmLKx+72RV9hQKOUCfR/8L8Ybu0Q4kEunv/a0xR/Azg723Wtf9ZDkN2nyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCPWJ4cc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCPWJ4cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184161F000FF;
	Thu, 17 Sep 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671222;
	bh=qRZijIaArdwo5FN5aAaVaRePjIV+r0UXidzUO2LrLBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCPWJ4ccOYYL1FHhjpD2MKFt2BpHCDj54atnZsqXkztF9oQ1lgWKv/e2AxFYYdb9P
	 9jPZoiD0GDQghgQccdH4GTYByYBXNsT11zZtn+BV0l+hjIsEywRxoUfkW1Ij3CCMaX
	 E5Xk/S/WGy4GZ9hrmUli4RewmFRNSxHKNUqSqnOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0906/1102] xfs: fix replaying dirent removals into the temporary directory
Date: Thu, 17 Sep 2026 16:14:09 +0100
Message-ID: <20260917151603.351929272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

commit e854f9a28b1fa08dfa5bf18ee4184fae90106180 upstream.

xrep_dir_replay_removename is the function that replays a directory
entry removal from sc->ip into the temporary directory so that when we
swap the contents of sc->tempip and sc->ip, the directory is correct.
LOLLM noticed that we were passing the wrong inode pointer into
xrep_dir_init_args.  It doesn't make sense to set rd->args.dp to
rd->args.dp so let's fix this.

Cc: stable@vger.kernel.org # v6.10
Fixes: 8559b21a64d983 ("xfs: implement live updates for directory repairs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -715,7 +715,7 @@ xrep_dir_replay_removename(
 	const struct xfs_name	*name,
 	xfs_extlen_t		total)
 {
-	struct xfs_inode	*dp = rd->args.dp;
+	struct xfs_inode	*dp = rd->sc->tempip;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 


