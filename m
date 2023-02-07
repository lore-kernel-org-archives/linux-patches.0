Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3AA3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903D1C433EF;
	Tue,  7 Feb 2023 13:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775022;
	bh=2eJvU72bguGWNcOSPX5RnYvIcsZFnsi3YJtrC2eEK7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PanLKIfUPSBlmndoRxGriylB++ipG3EaaRdDpLKjJqupD0MsHS6zv5l9ITDGDvtCk
	 2Ft83WuIYVAui7AO8IZqv8nn2zMdpQY7eGydGs0waCA9q2bSrVypnZr4xtjW/bt8RH
	 Ut2JLQLJCutuBnlXegnYk32Afd5vlTR7EgXhjLtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Pereira <alexpereira@disroot.org>,
	Coly Li <colyli@suse.de>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	linux-bcache@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/208] bcache: Silence memcpy() run-time false positive warnings
Date: Tue,  7 Feb 2023 13:56:04 +0100
Message-Id: <20230207125639.351394298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit be0d8f48ad97f5b775b0af3310343f676dbf318a ]

struct bkey has internal padding in a union, but it isn't always named
the same (e.g. key ## _pad, key_p, etc). This makes it extremely hard
for the compiler to reason about the available size of copies done
against such keys. Use unsafe_memcpy() for now, to silence the many
run-time false positive warnings:

  memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)
  memcpy: detected field-spanning write (size 24) of single field "&b->key" at drivers/md/bcache/btree.c:939 (size 16)
  memcpy: detected field-spanning write (size 24) of single field "&temp.key" at drivers/md/bcache/extents.c:428 (size 16)

Reported-by: Alexandre Pereira <alexpereira@disroot.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216785
Acked-by: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230106060229.never.047-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/bcache_ondisk.h | 3 ++-
 drivers/md/bcache/journal.c       | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index 97413586195b..f96034e0ba4f 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -106,7 +106,8 @@ static inline unsigned long bkey_bytes(const struct bkey *k)
 	return bkey_u64s(k) * sizeof(__u64);
 }
 
-#define bkey_copy(_dest, _src)	memcpy(_dest, _src, bkey_bytes(_src))
+#define bkey_copy(_dest, _src)	unsafe_memcpy(_dest, _src, bkey_bytes(_src), \
+					/* bkey is always padded */)
 
 static inline void bkey_copy_key(struct bkey *dest, const struct bkey *src)
 {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index e5da469a4235..c182c21de2e8 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -149,7 +149,8 @@ reread:		left = ca->sb.bucket_size - offset;
 				    bytes, GFP_KERNEL);
 			if (!i)
 				return -ENOMEM;
-			memcpy(&i->j, j, bytes);
+			unsafe_memcpy(&i->j, j, bytes,
+				/* "bytes" was calculated by set_bytes() above */);
 			/* Add to the location after 'where' points to */
 			list_add(&i->list, where);
 			ret = 1;
-- 
2.39.0



