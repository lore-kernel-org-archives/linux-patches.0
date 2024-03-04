Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A11D1C687;
	Mon,  4 Mar 2024 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587995; cv=none; b=irxjSXs23F4F8agcjCNgFY35bFrQDhnXRrBcmlIm83Zx4u+v+JJ+USUGhrYERDvnvQ2E7uoFtq7nRkLzRJIg+lfgL463SMiYHtJz/eAHdw26ROfrPnb/Qru6uXsZ5s6NEZrMXi3MEBHJ+OAFm2VAtjJUu/E8lnA0VZ5Aa2RllpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587995; c=relaxed/simple;
	bh=X9m5lbl6IVKEMFTR3rnFCsR4eRkwHMzPNZ3UlalFxiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVg38dhu7RZalxXnX8O6wQXodRo4A7xPA8W84h1avQ64b3nvEbsNj9GKZhnvFY4f3/myOcha+px3j3KZhZBvtog7Wu/fSSFySWaptaDDVXLx3fQ85TSaPcn3gXF6M2mMga0+Y2Gzu1zSUoEUx5p0m5XwrLn/ysWEsYeGNIUvme8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjuvDOlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjuvDOlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2694C433F1;
	Mon,  4 Mar 2024 21:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587995;
	bh=X9m5lbl6IVKEMFTR3rnFCsR4eRkwHMzPNZ3UlalFxiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjuvDOlQpLAlYMiQO7oaEs0LGIH+BJZdjED6pzO4Xi4QKqYJRT4zbfbC0NeiTZv2L
	 J9ct4xh81DJ86JgPDKbSfRYVbEGYdKdSnzfVMupD1PIz3DX7pIxlCpDBw6NVyaBPqt
	 rfzpp1tv667VBrY30pkbwoOrksLzPceBpRWxJnOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ming Lei <ming.lei@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 151/162] block: define bvec_iter as __packed __aligned(4)
Date: Mon,  4 Mar 2024 21:23:36 +0000
Message-ID: <20240304211556.514291827@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 7838b4656110d950afdd92a081cc0f33e23e0ea8 ]

In commit 19416123ab3e ("block: define 'struct bvec_iter' as packed"),
what we need is to save the 4byte padding, and avoid `bio` to spread on
one extra cache line.

It is enough to define it as '__packed __aligned(4)', as '__packed'
alone means byte aligned, and can cause compiler to generate horrible
code on architectures that don't support unaligned access in case that
bvec_iter is embedded in other structures.

Cc: Mikulas Patocka <mpatocka@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 19416123ab3e ("block: define 'struct bvec_iter' as packed")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bvec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 555aae5448ae4..bd1e361b351c5 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -83,7 +83,7 @@ struct bvec_iter {
 
 	unsigned int            bi_bvec_done;	/* number of bytes completed in
 						   current bvec */
-} __packed;
+} __packed __aligned(4);
 
 struct bvec_iter_all {
 	struct bio_vec	bv;
-- 
2.43.0



