Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1663F46C4BC;
	Tue, 21 Jul 2026 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660295; cv=none; b=g43l3QiU4jskeIGTiCMF9x9gL+XjFzljT1JqXEh5nDJMHwr6PgQhxwdRTmlDVFH4Rqmz/Tbo0cJq8rMNw24PZPdhq4Ksz01cKdJYX53yxcFcqlYwHP3De+/wP7/WZDTvFAib7KBkl8+3RtNaD1dC8uOLVXT87C4FRlDKHaSAqMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660295; c=relaxed/simple;
	bh=SGKhKl+SXVWINeWCXseFZzim1DP5d0MzKX5jKIHrS+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUtVszyiGsaGytC81yolFOeJtVuZOvH8wBceABo/VcZ1qITs0h7L2Ur/taRgNetaaw9k0Gpa9d6ryFgUgO4Hyiof0iyOuTzHvkB03CmWjv3n2TpaRre94Wr4M4tsU3nKUztDA4YlIn/YQ6vsyEIMD5iIa/31dRVVHG3fxgCKGNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkhF9eYr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkhF9eYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC091F00A3D;
	Tue, 21 Jul 2026 18:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660292;
	bh=VhpoMeOIZ1Y0LFJipfIdZwgmlQNUg9dGnWobv6K6vEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkhF9eYrxgrhuBMwuOdeBrCljg8Mi1rVsfj9HmBTC0LdfcjcW9V171KId8UsXqtRE
	 UIQt6g7O0YO3jb/2JWFkKFls0wAlCk0llnj2xlX9esSAdu6knPI+iqbkrltrEOfwOf
	 cjuC2/ekFZTGwWu9MZiK4LkSscSEW1zIRGt/KLdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0918/2077] fs/ntfs3: fix wrong LCN in run_remove_range() when splitting a run
Date: Tue, 21 Jul 2026 17:09:51 +0200
Message-ID: <20260721152614.466532428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit 36c7276816ed4266c155b71b1fa747b2785f23f7 ]

When run_remove_range() removes a middle portion of a non-sparse run,
it splits the run into head and tail parts.  The tail is inserted via
run_add_entry() but uses the original r->lcn as its starting LCN
instead of advancing it by the split offset.

For example, removing VCN range [10, 20) from a run
{vcn=0, lcn=100, len=30} should produce:
  {vcn=0,  lcn=100, len=10}   (head)
  {vcn=20, lcn=120, len=10}   (tail, lcn advanced by 20)

But the current code produces:
  {vcn=0,  lcn=100, len=10}
  {vcn=20, lcn=100, len=10}   (wrong: points to same physical clusters)

This creates overlapping physical mappings in the in-memory run tree,
which can corrupt cluster allocation decisions and lead to data
corruption.

The correct pattern is already used in run_insert_range():
  CLST lcn2 = r->lcn == SPARSE_LCN ? SPARSE_LCN : (r->lcn + len1);

Apply the same logic in run_remove_range().

Fixes: 10d7c95af043 ("fs/ntfs3: add delayed-allocation (delalloc) support")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/run.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/run.c b/fs/ntfs3/run.c
index 19aa044fd1fcc9..ad7db67514ef7c 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1297,9 +1297,12 @@ bool run_remove_range(struct runs_tree *run, CLST vcn, CLST len, CLST *done)
 
 		if (r_end > end) {
 			/* Remove a middle part, split. */
+			CLST tail_lcn = r->lcn == SPARSE_LCN ?
+					SPARSE_LCN : (r->lcn + (end - r->vcn));
+
 			*done += len;
 			r->len = d;
-			return run_add_entry(run, end, r->lcn, r_end - end,
+			return run_add_entry(run, end, tail_lcn, r_end - end,
 					     false);
 		}
 		/* Remove tail of run .*/
-- 
2.53.0



