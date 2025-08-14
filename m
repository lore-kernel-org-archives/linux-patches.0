Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF3C242D65;
	Thu, 14 Aug 2025 20:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755202120; cv=none; b=LAQBtgK08kd/9JHQUvjuej/tulBbtz0TYSzEfSkrYCUaQjihFtm3YMtEPZE8hg5HzreH09z46DGWR2que7ylCrT5psn2qz5TUEMPu5+YGH6zdj1Noy2hD9+pRIs60IjVqe/Ywo8i+vf9O22q/z1Iu91o6iNR5m7j5BNCZ22o7e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755202120; c=relaxed/simple;
	bh=xcfeo2/DQtmCLjuZc4lx76Xl5JQ/w8kZY0rp9JIkZh8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=EKaV56zSwu5myYpsQCKQGfkGxTrh0/MBGMTGs8I89nZdauk0i76dUnUA8AvCEmSqnSB6UazIZ/ILbBOL9QVKv+3GDN0XXWgfwam+kJ3YuQIAWQqWV4KRJOCrHoQqHHoaaWPa9Ifvd3mlRIhGZx27x449qaA1xXNA6fGqVT4EORI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLQWHfAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLQWHfAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B7FC4CEED;
	Thu, 14 Aug 2025 20:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755202119;
	bh=xcfeo2/DQtmCLjuZc4lx76Xl5JQ/w8kZY0rp9JIkZh8=;
	h=From:Date:Subject:To:Cc:From;
	b=kLQWHfAyHImX7AQXABORqZ+fce4DMi4GN3e/nOuAXZqUpBXuAcdoxb1yj21YyFJNk
	 SsSbbo+jHBvRe0K2KYVLALgQvRFM25sMbVc3RoJQ/SZVMVJH7CCxH9PCGsxYwCPge3
	 tGXwz5z5u4jZ+Q5Z8I3hktUXIXh0oPjA4WvjvQeyyxmok2BKMJBkP2gZSIOwAVaVnn
	 Zk4p6budaB8J4G/Re3WeWMoCGHsK6p3xjMNYCNNlZmymL9EK5UWxSLVJ8fkOhJPc7e
	 bzvhn4eIR0XbRsriNgnwmCauSOZaQ/yGuMuQg6Qy4LCBguxOjSGe5+1raWu2JnAsmh
	 JGoSYw6WdQ25A==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Aug 2025 13:05:22 -0700
Subject: [PATCH] mm/rmap: Always inline __folio_rmap_sanity_checks()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-rmap-fix-build_bug-conversion-v1-1-fb7b10a0b362@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIFBnmgC/x2MQQqEMAwAvyI5G2hrFdeviEitUQNrlRRlQfz7V
 o8DM3NBJGGK0GQXCJ0ceQsJdJ6BX1yYCXlMDEaZUtXaoqxux4l/OBz8HfvhmNFv4SR5Svwoa7V
 XRTVZA+mxCyX3/bfdff8BMsVfxW8AAAA=
X-Change-ID: 20250814-rmap-fix-build_bug-conversion-90441c036f42
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
 linux-mm@kvack.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2110; i=nathan@kernel.org;
 h=from:subject:message-id; bh=xcfeo2/DQtmCLjuZc4lx76Xl5JQ/w8kZY0rp9JIkZh8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnznFyjnirtNJzLvLT5L9ed7A8f+fadub56858jRmacz
 qxZM+UfdJSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJpIowMiwOmXTlu8aRpo54
 X4eMDxbNXXsuWG2fNS/Myzx6dkamawgjw8Ef33ukomcenPzkfJ3xiasON7idLQ6t1jqe4unwpi3
 pKiMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 5e901e249ad1 ("mm/rmap: convert "enum rmap_level" to "enum
pgtable_level"") changed VM_WARN_ON_ONCE, a run time warning, into
BUILD_BUG, a compile time error. After this adjustment, certain builds
with older versions of clang (such as arm64 allmodconfig) started
failing to build with:

  In file included from mm/rmap.c:63:
  In file included from include/linux/ksm.h:14:
  include/linux/rmap.h:440:3: error: call to __compiletime_assert_890 declared with 'error' attribute: BUILD_BUG failed
                  BUILD_BUG();
                  ^
  ...
  <scratch space>:21:1: note: expanded from here
  __compiletime_assert_890
  ^

While __folio_rmap_sanity_checks() is marked 'inline', the compiler may
not always honor it, such as when sanitizers or other instrumentation is
enabled.  If __folio_rmap_sanity_checks() is not inlined, there is no
way the compiler can eliminate the default cause.

Mark __folio_rmap_sanity_checks() as __always_inline to allow the
BUILD_BUG() to work consistently, which clears up the error.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
I assume this will be squashed into
mm-rmap-convert-enum-rmap_level-to-enum-pgtable_level.patch so no fixes
tag.
---
 include/linux/rmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 9d40d127bdb7..e8aff6d2deda 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -394,7 +394,7 @@ typedef int __bitwise rmap_t;
 /* The anonymous (sub)page is exclusive to a single process. */
 #define RMAP_EXCLUSIVE		((__force rmap_t)BIT(0))
 
-static inline void __folio_rmap_sanity_checks(const struct folio *folio,
+static __always_inline void __folio_rmap_sanity_checks(const struct folio *folio,
 		const struct page *page, int nr_pages, enum pgtable_level level)
 {
 	/* hugetlb folios are handled separately. */

---
base-commit: 6bee0462de1f9f4fa9400f153d3b0792c20d7111
change-id: 20250814-rmap-fix-build_bug-conversion-90441c036f42

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

