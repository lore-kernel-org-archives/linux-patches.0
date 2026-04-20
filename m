Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCAD33F5A9;
	Mon, 20 Apr 2026 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701271; cv=none; b=G+RUr+sasP4X03R1zKW7xDU/1sbv08TT6dXvI5kU64g53wIZakpXy1deudEGBhQJHQlOyetL8MB9zrTx9fttlmrgaFt/tmjZh5E4r2sryg6Rr2TrsimaTSap2LvMMSAB5sZ1pei1Jw69t5oWSlf4/bQpDmOr13/4ThmiAevDOZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701271; c=relaxed/simple;
	bh=FcOSW5bLnvQjsIcysczgVTosi3CuOLLvbMxY5OPQiCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMgfvgy9Q28OrvRYVd3QVBvwkdMJxCfMpzyH1Qz+uZi0wXcviRiR4U6vywgA3Cr+Fe2P4d41vtDFbfNXoL4mwoR+iuaCXpcbz8Nw4OcdmdSPVBfU8Vg+VKQ0UoKg2IVqD9gQ5MRXwbPf6J1Zo3rgqpMS6sr1UXS4qJ9tIqmswjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rh1v05t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rh1v05t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA294C19425;
	Mon, 20 Apr 2026 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701271;
	bh=FcOSW5bLnvQjsIcysczgVTosi3CuOLLvbMxY5OPQiCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rh1v05t7mFPXIvfwFamvnbnseOc+s2yV6Et0WzbVnMRBmbcqw8h5Dqrye6AobpSQ/
	 Ey7IjxK85FKCk6JIpH4nvE6wSFkgZombo5Sy2ArnoyOPyl3uP1pt6fNJY/98vB1yvu
	 n6Gz8d/6ceZqxqQQj5cQKm3sPiza2tteh/BYJmVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/162] netfilter: nft_set_pipapo_avx2: dont return non-matching entry on expiry
Date: Mon, 20 Apr 2026 17:40:48 +0200
Message-ID: <20260420153927.608261137@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d3c0037ffe1273fa1961e779ff6906234d6cf53c ]

New test case fails unexpectedly when avx2 matching functions are used.

The test first loads a ranomly generated pipapo set
with 'ipv4 . port' key, i.e.  nft -f foo.

This works.  Then, it reloads the set after a flush:
(echo flush set t s; cat foo) | nft -f -

This is expected to work, because its the same set after all and it was
already loaded once.

But with avx2, this fails: nft reports a clashing element.

The reported clash is of following form:

    We successfully re-inserted
      a . b
      c . d

Then we try to insert a . d

avx2 finds the already existing a . d, which (due to 'flush set') is marked
as invalid in the new generation.  It skips the element and moves to next.

Due to incorrect masking, the skip-step finds the next matching
element *only considering the first field*,

i.e. we return the already reinserted "a . b", even though the
last field is different and the entry should not have been matched.

No such error is reported for the generic c implementation (no avx2) or when
the last field has to use the 'nft_pipapo_avx2_lookup_slow' fallback.

Bisection points to
7711f4bb4b36 ("netfilter: nft_set_pipapo: fix range overlap detection")
but that fix merely uncovers this bug.

Before this commit, the wrong element is returned, but erronously
reported as a full, identical duplicate.

The root-cause is too early return in the avx2 match functions.
When we process the last field, we should continue to process data
until the entire input size has been consumed to make sure no stale
bits remain in the map.

Link: https://lore.kernel.org/netfilter-devel/20260321152506.037f68c0@elisabeth/
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 39e356c9687a9..9d5ada57aa6fe 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -242,7 +242,7 @@ static int nft_pipapo_avx2_lookup_4b_2(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -319,7 +319,7 @@ static int nft_pipapo_avx2_lookup_4b_4(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -414,7 +414,7 @@ static int nft_pipapo_avx2_lookup_4b_8(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -505,7 +505,7 @@ static int nft_pipapo_avx2_lookup_4b_12(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -641,7 +641,7 @@ static int nft_pipapo_avx2_lookup_4b_32(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -699,7 +699,7 @@ static int nft_pipapo_avx2_lookup_8b_1(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -764,7 +764,7 @@ static int nft_pipapo_avx2_lookup_8b_2(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -839,7 +839,7 @@ static int nft_pipapo_avx2_lookup_8b_4(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -925,7 +925,7 @@ static int nft_pipapo_avx2_lookup_8b_6(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
@@ -1019,7 +1019,7 @@ static int nft_pipapo_avx2_lookup_8b_16(unsigned long *map, unsigned long *fill,
 
 		b = nft_pipapo_avx2_refill(i_ul, &map[i_ul], fill, f->mt, last);
 		if (last)
-			return b;
+			ret = b;
 
 		if (unlikely(ret == -1))
 			ret = b / XSAVE_YMM_SIZE;
-- 
2.53.0



