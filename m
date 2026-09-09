Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0295867EA;
	Wed,  9 Sep 2026 14:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964354; cv=none; b=Jc5rSlk7AazWP3P61IPJNVCJbC7ZTq0pWOH8gfHam6e0VfGY/m5DGtcBhGtjqM08AM4Lc6M1FwxiPcwqUhI+Ha1rTByJ6s+ZnxuMP0EkPKgWwag7hNhoAvBXpmPJgYKGZXIVXr65mz5o0zWBlFUaf+TLoqmV9CFYD0rC5c6Q6kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964354; c=relaxed/simple;
	bh=ofpNZmpDXQft2ZC712X1Yu7x7vJXttnirE7Sea6DKYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzpyRbUGPsGCGp/7LuhLXfBVgYnGDtbA1BIQp8jUVwrBWdJ7RGR5Da77L34AGnIvMukgPxCRFhuVWcGjEWeI5aobj6jd+zXhG1yiRc9Fnw0E4HmOY23ymQJccEzKiKIZfEenCtuFhsOAP44fzMIxy24pmMkMuv1bbs+PzLTcgWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1SITedZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1SITedZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF171F00A3E;
	Wed,  9 Sep 2026 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964353;
	bh=YfqTlZGdDuOvVJDT8vDGEA7ZuTyOdl5++S8DuiNAiJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1SITedZIGhtyhLm7B+9KUTIuUzz0ybrXZ8s7/YO2rRfhN2Yyf2WPx4iKK+pSFYN+
	 JBFwqJGvAbJrD876sQUURZ7Iw2BuohmVQ1iBRwUDhCtHwRjtoUY7FD+MSLYdnVrTQh
	 CYTvFwEbFMJfMRASVHK6/tdZE9wqDufrrcQqsU0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 361/583] f2fs: fix to migrate all curseg types during free_segment_range
Date: Wed,  9 Sep 2026 15:40:46 +0200
Message-ID: <20260909134250.504980332@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

commit 8ec06f50ddd8d201bd7e55b896ae28ed9d4cb7d1 upstream.

In free_segment_range(), the curseg evacuation loop only iterates up to
NR_CURSEG_PERSIST_TYPE (0..5), missing non-persistent in-memory curseg
types such as CURSEG_COLD_DATA_PINNED and CURSEG_ALL_DATA_ATGC.

Even though these in-memory curseg types are not saved in the on-disk
checkpoint header, they still occupy active physical segments at runtime.
If an active in-memory curseg happens to be allocated within the segment
range being truncated during filesystem shrink, failing to evacuate it
will cause subsequent writes to the curseg attempting out-of-bounds I/O
on the truncated storage range.

Fix this by expanding the curseg evacuation loop upper bound to
NR_CURSEG_TYPE to ensure all active curseg types are safely migrated
out of the target range.

Fixes: d0b9e42ab615 ("f2fs: introduce inmem curseg")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2192,7 +2192,7 @@ static int free_segment_range(struct f2f
 	mutex_unlock(&DIRTY_I(sbi)->seglist_lock);
 
 	/* Move out cursegs from the target range */
-	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_PERSIST_TYPE; type++) {
+	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_TYPE; type++) {
 		err = f2fs_allocate_segment_for_resize(sbi, type, start, end);
 		if (err)
 			goto out;


