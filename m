Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061BB47A0C3;
	Sat, 12 Sep 2026 11:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214213; cv=none; b=YDl3NQhcgLr8cDUkPAjpFs71zMbGYbVrpJkSGaF3tDdlykqcVI22yFEb5vU3HyP9igMuGoO/SHWPduixHQWDvadA/AJ4xrSoQfoNnTLtQ/EIIvrbAjBE6LmHL+Po7pPdy9CH/b8Lwv8HOz69JrloOVyfV7ZEDJ/mpoFfydkONXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214213; c=relaxed/simple;
	bh=E7MaoLy54svGXBXyUrTlUk40rFwo70gtydvl+I/2scc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqwENGaX1darEfV+EmJDwCb8CvVS4u4LK1qz/Q0BRqPxC05acbI5tnHPot0wE/QKHyAekJTxYCbfVl9S3CeX9YurhEd2tL87t0DQmUA33EXF4uBQCqheMiamJJQaRxkQaJoxhkbcwvL52RkJwEckNZ8TzbwJh1RjTuLXKcA7nrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdDngwcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdDngwcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E206E1F000FF;
	Sat, 12 Sep 2026 11:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214211;
	bh=vB4vGL9f5oHfo07TqEpxoV86Unbh/l5V1OF9+6m2KY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdDngwcf45w8tnDwR51qqxS9EfyUABnhkYdXFnFFu1sdG4ZV1YvgO2PCxe2Ke33mG
	 EXIe5siZTS0q2qii67LvDU+k6cfOWSz7YqHIMrcf6Xm6cIhsvRkrq4wvVLkLCG8MtP
	 MH6wkpsdr6nO2h9ML4nh7FmTURoY/WzDmABa2tXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 0253/1376] f2fs: fix to migrate all curseg types during free_segment_range
Date: Sat, 12 Sep 2026 08:44:39 +0200
Message-ID: <20260912065613.178670335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -2171,7 +2171,7 @@ static int free_segment_range(struct f2f
 	mutex_unlock(&DIRTY_I(sbi)->seglist_lock);
 
 	/* Move out cursegs from the target range */
-	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_PERSIST_TYPE; type++) {
+	for (type = CURSEG_HOT_DATA; type < NR_CURSEG_TYPE; type++) {
 		err = f2fs_allocate_segment_for_resize(sbi, type, start, end);
 		if (err)
 			goto out;


