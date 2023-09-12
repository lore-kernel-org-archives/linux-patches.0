Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BE2A951;
	Tue, 12 Sep 2023 19:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0822C433C9;
	Tue, 12 Sep 2023 19:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694546162;
	bh=qJOiausqrNbKIkN5Zet+po6884A5rNQYVlvbj7JYJgA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UKun96VnkbE34mUaZFl7Tv/hA6s6SDm91InaWv5QH5AeXK79TvnSCqPUZKjzJgeNg
	 o0KDzH3OFoTS6bwrrJuL/juEtbmA7pNDmgusiQBZA1KzLgXn4hgwP3gTnQSkMWy5YS
	 wyRYyHjhgc/o6YBJjYrTmkD5R/0DjhqiqKbVTsQQsPnj9CbOYidxLNob3Ef2TqiHRX
	 Jfqtsg/PJfjp/iotDlyEcvteAZ3MUj+lZSCqvRKPRY0CYyuKge2rBirsjWVCADq3Ul
	 cJy7VeuIKos0H8XOgdxChkcHBUkrfCyKvgOO4sjHE63fBvWX6qIOgSWrSK/iiVPEFZ
	 Uu57Zlz3OgwCQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 12 Sep 2023 12:15:39 -0700
Subject: [PATCH 2/7] bcachefs: Fix -Wformat in
 bch2_btree_key_cache_to_text()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230912-bcachefs-warning-fixes-v1-2-a1cc83a38836@kernel.org>
References: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
In-Reply-To: <20230912-bcachefs-warning-fixes-v1-0-a1cc83a38836@kernel.org>
To: kent.overstreet@linux.dev
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1921; i=nathan@kernel.org;
 h=from:subject:message-id; bh=qJOiausqrNbKIkN5Zet+po6884A5rNQYVlvbj7JYJgA=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKkMO94zmTCaf3fUStC4KNdQfHLO2y2L7JVYZPtSZA2uv
 pnQuYm7o5SFQYyDQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEzkdSjD/3JdK71jmp5pPl/0
 /zcfLeJu9RRiCf2xdatnaLv3XrHzWxj+ChuklltsnBW6tUzqxzkXRfMf55imTzjiu8v7wabIpox
 TXAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building bcachefs for 32-bit ARM, there is a compiler warning in
bch2_btree_key_cache_to_text() due to use of an incorrect format
specifier:

  fs/bcachefs/btree_key_cache.c:1060:36: error: format specifies type 'size_t' (aka 'unsigned int') but the argument has type 'long' [-Werror,-Wformat]
   1060 |         prt_printf(out, "nr_freed:\t%zu",       atomic_long_read(&c->nr_freed));
        |                                     ~~~         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        |                                     %ld
  fs/bcachefs/util.h:223:54: note: expanded from macro 'prt_printf'
    223 | #define prt_printf(_out, ...)           bch2_prt_printf(_out, __VA_ARGS__)
        |                                                               ^~~~~~~~~~~
  1 error generated.

On 64-bit architectures, size_t is 'unsigned long', so there is no
warning when using %zu but on 32-bit architectures, size_t is
'unsigned int'. Use '%lu' to match the other format specifiers used in
this function for printing values returned from atomic_long_read().

Fixes: 6d799930ce0f ("bcachefs: btree key cache pcpu freedlist")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/bcachefs/btree_key_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 505e7c365ab7..a74ee6d8a7cf 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -1053,7 +1053,7 @@ int bch2_fs_btree_key_cache_init(struct btree_key_cache *bc)
 
 void bch2_btree_key_cache_to_text(struct printbuf *out, struct btree_key_cache *c)
 {
-	prt_printf(out, "nr_freed:\t%zu",	atomic_long_read(&c->nr_freed));
+	prt_printf(out, "nr_freed:\t%lu",	atomic_long_read(&c->nr_freed));
 	prt_newline(out);
 	prt_printf(out, "nr_keys:\t%lu",	atomic_long_read(&c->nr_keys));
 	prt_newline(out);

-- 
2.42.0

