Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B6F576EBB;
	Wed,  9 Sep 2026 14:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964366; cv=none; b=Y9lM0mQiH6kEUgkGbkfkkpNE/Xn34Tj0EETm/taH0hEDbe5qgVWm2iYnsJ2/hnwulE1EX6DYOST7yAFOH/L1lmlzF7K4WkWwBiZW60qnRn1kmo6poIuNddY96Rum24f6XNnMHWPS1M9omjqr3kB2/28gsGYSxGPORDqBKqOiyyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964366; c=relaxed/simple;
	bh=6PHw+A7miMjA/QgEabq++ThPJX/DpVCn5z8CHwY3MH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgolVu1OTr5LdpxbA8p0K+rZBZAsUwbaQf8b7nWyJIEmun4ezg4qBVD4Gb3FYpJ0lzFVqDoPGPTzRkEd+Ny1DM88IbxvFnG84MXGEoZ0vq2HGTtc80s6uaV86SFMKb18UWX0Pbct30jFCyvANaaPG2sUEnl2VrZskW2dxzlS2Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUEqaUC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUEqaUC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3381F00A3D;
	Wed,  9 Sep 2026 14:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964364;
	bh=BvhPm7R0++F1Eg1wDxaeh5TNZCCQviaBiWmFyu8p90I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUEqaUC5tqs5L7OuIcko8q+30m7Drcrx+SU9oCdA0+qqXWlSU+dnHv1xVzgKxEuDD
	 iyj0YzkceyGCBqhMfhCqcwzY+/zWBwxDHKB7mtmizi5/9yEyGqSUDK9VKFfM9Q/3n5
	 rFAkqdIfozVOibj6c+Oq1qe/oTVbxG4rEZxKHyRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 365/583] f2fs: fix to clear dirty flag on folio in error path
Date: Wed,  9 Sep 2026 15:40:50 +0200
Message-ID: <20260909134250.683423490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 5b86eab84ac8e9289b5afc52ef88ab18ba5bacab upstream.

If node block is corrupted due to chksum mismatch or inconsistent
footer info, it needs to drop clear flag of node folio, in order
to persist inconsistent node data to storage.

Cc: stable@kernel.org
Fixes: b42b179bda9f ("f2fs: fix to do checksum even if inode page is uptodate")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1596,7 +1596,7 @@ page_hit:
 	if (!err)
 		return folio;
 out_err:
-	folio_clear_uptodate(folio);
+	clear_node_folio_dirty(folio);
 out_put_err:
 	/* ENOENT comes from read_node_folio which is not an error. */
 	if (err != -ENOENT)


