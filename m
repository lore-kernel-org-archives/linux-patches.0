Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038740;
	b=Q7yKIeajGQNdaZusfbIcMIvott1+WKFMVj6309yihWGKswdFgkYE8Osx16U35MLvMAN8
	 Z+u+xkZGurvtjkN49JTRgsXSss+8iT2kRKoWl9i0rhpzCJwwZLKk0UJrkBHbp5FkzYA5I
	 jtalaf76mqwKphTYfnLq9+ctONuMqmO5ePd0t5y++pg23kr+TZ5K38dbbYGty9S1gEhTr
	 O/u1/DWIcOzWHxUsq1fhviQcBVA0GAq6kwH/Fn+zwOizoloLUiQjfv/peMcvd4u4zz4Zx
	 X+O7WiQXHQ/voIfmbeZ41Irr7NaPAtZGcRDOOQcA4xVWl+DYDjW3WUc/JCQdR5Pm0ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AxBkRhBHcZLCeGK0ymLFODPfym2BnOYedrZey0SwUZk=;
	b=uE4wyygO2OUYOylHRMhkK9WbzFT3y6qY3YyaVlsk8mb9cwX9US/ezZG1Cg7eBDhpKew7
	 x2I+m5nTL8viFn76mZK0cmDeNLBmLenjd5WoSMmKQjMsPeolDwXcAA44P+udJUeN1FXKW
	 UhHlN12r8IyRHUcsVLcoUbNAcbYaZKBkgYpxQfeTGzT6PueB6Q/XN9uNmS7wxost0IPpn
	 34fdxSdXvKqL7i7bJYnbumkT3gesz0bXWhglPLuDMaiGczW8iL9WQAI4WI7RUfLhx9XZN
	 txO6ogjV/h2hfMh+G3izCl0e0F5Qyea8PKul/OGQaXNJymd4wTIez6qDALeudtQGvOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1pkMIqF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42495606A31C;
	Wed, 18 Nov 2026 21:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1pkMIqF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9741E1F000C4;
	Wed, 18 Nov 2026 21:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038740;
	bh=AxBkRhBHcZLCeGK0ymLFODPfym2BnOYedrZey0SwUZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1pkMIqFtefoLHK7x/LTMxzt3CeQiH72u1Dr2CEsPy6X7rdD1naHI2g5/PT1Ro+QN
	 oftCiZbut77ofEy66lhpAu9ot/9FgZjLrc5QsLFvQhOMzB3Gs15SWpdFDJyuyDxvhh
	 VJSjG2tw3h4x1u3j4WoAqZg/VoMRJp4PriabOKw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1850/3318] assoc_array: dont lose objects when a shortcut is split on a word boundary
Date: Wed, 18 Nov 2026 15:41:12 +0100
Message-ID: <20261118150417.365910207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 2a62c32760a8fbf464a7388853d19bc62c5cc423 ]

When assoc_array_insert_mid_shortcut() splits a shortcut at level diff,
the new shortcut in front of the split, new_s0, gets the first
round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE) bits of the old shortcut's
index key, and the bits from diff onwards are then cleared from its
last word:

	blank = ULONG_MAX << (diff & ASSOC_ARRAY_KEY_CHUNK_MASK);
	new_s0->index_key[keylen - 1] &= ~blank;

When diff is a multiple of ASSOC_ARRAY_KEY_CHUNK_SIZE, the shift is 0,
blank is all ones, and the whole last word is cleared, although all of
it lies below diff.  A walk then compares the key it is looking for
against that zeroed word, takes the shortcut to point elsewhere, and
every object below it can no longer be found.

assoc_array_insert_into_terminal_node() trims a new shortcut's key the
same way, and only when the level is not a multiple of the chunk size.
Do the same here.

Found by a userspace build of the array with a test that inserts, in
order, string keys whose first word is their length and the rest their
bytes.  The 102nd key split a shortcut at bit 256, and 76 of the keys
already in the array could no longer be found; AddressSanitizer also
reported assoc_array_walk() reading a word past the end of a shortcut's
index key.  With this change the test passes, and AddressSanitizer and
UndefinedBehaviorSanitizer report nothing.

Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 65409f0d2e0e5..62e35116db19c 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -866,9 +866,11 @@ static bool assoc_array_insert_mid_shortcut(struct assoc_array_edit *edit,
 		memcpy(new_s0->index_key, shortcut->index_key,
 		       flex_array_size(new_s0, index_key, keylen));
 
-		blank = ULONG_MAX << (diff & ASSOC_ARRAY_KEY_CHUNK_MASK);
-		pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, diff, blank);
-		new_s0->index_key[keylen - 1] &= ~blank;
+		if (diff & ASSOC_ARRAY_KEY_CHUNK_MASK) {
+			blank = ULONG_MAX << (diff & ASSOC_ARRAY_KEY_CHUNK_MASK);
+			pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, diff, blank);
+			new_s0->index_key[keylen - 1] &= ~blank;
+		}
 	} else {
 		pr_devel("no pre-shortcut\n");
 		edit->set[0].to = assoc_array_node_to_ptr(new_n0);
-- 
2.53.0



