Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144214E9C3A;
	Thu, 17 Sep 2026 17:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666685; cv=none; b=HP4DgmeS0Y5Urlf/GaQE+VqKNgYj6yzUZ/R26O9C4dwCa4pbXwme+FDJctRs/us9bSqbAbp6F4hxQpkaIMfpUxoVMnyzjD8huejnzHzltznXY4WlBnpCHUXIAOl/GCFt5taGP//BG4OiSg0UTMN3BuBkEewfrCe52sbvHjAKWx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666685; c=relaxed/simple;
	bh=wfYD1BME1LM+CndSG3L0uSHAZFf3InL1QbAoO+JoWEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtTv1qmTuda0tLbuexvlUNB+gIpNWuEHRyfMNtyUnClUA30mKKhmDECorOwUB7r6jH5FajmK1dzLfhYogZjeqw+pxsD3pk0+jKpj8G8sf7+nLIC4ZDpHSxbYmd/lPuFloZb9Pj8nuCn8KZvOBu8A6IOoLL0kGofYxa80k7tt//Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4L0S65L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4L0S65L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D831F000FF;
	Thu, 17 Sep 2026 17:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666684;
	bh=Lg5RDQSfEXak0mLoA8oUKJkdbHqV9SxUwWkRVoNaVgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4L0S65LHBlgsLJGTwgsT/cJ6p0ZHWb0RhzoLtUFhVFO/EHBgtcwwtHwHgyg68kHB
	 n/gP61j/e7O1eLWrTlYYeCkZwn44cfdlMTLuHJJalGUU4kGcYSxqq0h9aevQOSPlzx
	 HCshiq/oxKhbche/kw2FY+23VUC6mp3OaG/PT60E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1120/1250] xfs: destroy seen inode bitmap when we fail to add a dirpath
Date: Thu, 17 Sep 2026 16:15:15 +0100
Message-ID: <20260917151622.587457705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

commit 1a441c6842da75c5b862cc1c9f7969d6a93b54b9 upstream.

LOLLM observes a memory leak in xchk_dirtree_create_path if we create
the directory path object but appending the name to the path fails.
When this happens, we don't tear down the (empty) seen inode bitmap.
This is a pretty trivial error, but let's not leave logic bombs.

Do the same for a similar bug in xrep_dirtree_create_adoption_path.

Cc: stable@vger.kernel.org # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree.c        |    1 +
 fs/xfs/scrub/dirtree_repair.c |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -259,6 +259,7 @@ xchk_dirtree_create_path(
 	dl->nr_paths++;
 	return 0;
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -619,6 +619,7 @@ xrep_dirtree_create_adoption_path(
 	return 0;
 
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }


