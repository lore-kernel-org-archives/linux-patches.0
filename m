Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6DC1E04B3;
	Wed,  6 Nov 2024 12:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897271; cv=none; b=PcHTwiEDzvKs/qK9HnCTossb04pl02/dUHKkmcpsS2Ff0l5qo+gS0wAIMdy7uaoQ95KJUvF0Q7SYku+/Kq+7voqTpOQdOtRDckiB91TH6en8idX8GF2ZpJcurw/0P4902ztbMZbry5gLIzLMFP1XvxCF40nodXHYPKY9xo129bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897271; c=relaxed/simple;
	bh=Ndh/kAr+ECu9nr3tPYyIdj6Gh/qk5WiWJMGjikRSOZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j7+Xza6KkgkFRCJvdS0zLe5qrY/58XXlss49SYj50zeFee82zTpiMrsOblY64i17ojod1P5erR634XbGU0A+lDrtc0ZfnDCeTQoAu8Z2wyr7zM4fqa7Hmf4nssmf7m10nFpDs0Ix6LI1V2aKLQPiEnkDa5ziBbRWBeSpcIkM6y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBCpDG9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBCpDG9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECFAC4CECD;
	Wed,  6 Nov 2024 12:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897271;
	bh=Ndh/kAr+ECu9nr3tPYyIdj6Gh/qk5WiWJMGjikRSOZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBCpDG9KeZ8Tpl4D5rgXcGoAEzn56rS9Pk3GWvqHcJ0qmUr5RrU8hLmykMNA3jeqr
	 oAD9hrD0UB5zjSg9HSsyvc+1nsKUzx0m0vNrdGD69Ku3XB91R+fc/NAKaRhc2C73Vk
	 C7YHaMLjnO+GfwFtQcArAK2+GizzjY59UhgNdCAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 125/126] mm: avoid gcc complaint about pointer casting
Date: Wed,  6 Nov 2024 13:05:26 +0100
Message-ID: <20241106120309.434275095@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e77d587a2c04e82c6a0dffa4a32c874a4029385d upstream.

The migration code ends up temporarily stashing information of the wrong
type in unused fields of the newly allocated destination folio.  That
all works fine, but gcc does complain about the pointer type mis-use:

    mm/migrate.c: In function ‘__migrate_folio_extract’:
    mm/migrate.c:1050:20: note: randstruct: casting between randomized structure pointer types (ssa): ‘struct anon_vma’ and ‘struct address_space’

     1050 |         *anon_vmap = (void *)dst->mapping;
          |         ~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~

and gcc is actually right to complain since it really doesn't understand
that this is a very temporary special case where this is ok.

This could be fixed in different ways by just obfuscating the assignment
sufficiently that gcc doesn't see what is going on, but the truly
"proper C" way to do this is by explicitly using a union.

Using unions for type conversions like this is normally hugely ugly and
syntactically nasty, but this really is one of the few cases where we
want to make it clear that we're not doing type conversion, we're really
re-using the value bit-for-bit just using another type.

IOW, this should not become a common pattern, but in this one case using
that odd union is probably the best way to document to the compiler what
is conceptually going on here.

[ Side note: there are valid cases where we convert pointers to other
  pointer types, notably the whole "folio vs page" situation, where the
  types actually have fundamental commonalities.

  The fact that the gcc note is limited to just randomized structures
  means that we don't see equivalent warnings for those cases, but it
  migth also mean that we miss other cases where we do play these kinds
  of dodgy games, and this kind of explicit conversion might be a good
  idea. ]

I verified that at least for an allmodconfig build on x86-64, this
generates the exact same code, apart from line numbers and assembler
comment changes.

Fixes: 64c8902ed441 ("migrate_pages: split unmap_and_move() to _unmap() and _move()")
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1017,11 +1017,16 @@ out:
  * destination folio.  This is safe because nobody is using them
  * except us.
  */
+union migration_ptr {
+	struct anon_vma *anon_vma;
+	struct address_space *mapping;
+};
 static void __migrate_folio_record(struct folio *dst,
 				   unsigned long page_was_mapped,
 				   struct anon_vma *anon_vma)
 {
-	dst->mapping = (void *)anon_vma;
+	union migration_ptr ptr = { .anon_vma = anon_vma };
+	dst->mapping = ptr.mapping;
 	dst->private = (void *)page_was_mapped;
 }
 
@@ -1029,7 +1034,8 @@ static void __migrate_folio_extract(stru
 				   int *page_was_mappedp,
 				   struct anon_vma **anon_vmap)
 {
-	*anon_vmap = (void *)dst->mapping;
+	union migration_ptr ptr = { .mapping = dst->mapping };
+	*anon_vmap = ptr.anon_vma;
 	*page_was_mappedp = (unsigned long)dst->private;
 	dst->mapping = NULL;
 	dst->private = NULL;


