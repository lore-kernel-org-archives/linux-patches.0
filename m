Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E754EB857;
	Thu, 17 Sep 2026 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659468; cv=none; b=EaYjuYbdCfpNLPRlJX5OSxBPfofnYsDeMD+7R4Mnr2DWx1mJAeq8UWPYjE/Metfuv0Ql/dgUD4b/0GDpYk2mPYhEKLmjLS3Iw0eE9vWw/CSMa0tNQfEE56tSIZ3ObmEI14MZLwX0QGFobEQKxm1CJDdCJFCc0Kd+gjFBKrV/xdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659468; c=relaxed/simple;
	bh=ZSrki1t+CEg3BT/i6XaSwcaQZ8aMRqeu9fnezne7WF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9zOou9RkiWVVP3x3IyE6+JkKHSFpzlFR9ArjF9MwJm30Ex+61ZEW0IPwc2ixZffiDC0xU9fs8fO3AZ1WADk/3k+N4e82EIo1Z0mnAeSkrHo4it2j+wCC9vM5YxBHocoCM0vweaxwzOZl1olIRkBRmr76Ac8DlLf7y+tuB9v+5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yetioX+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yetioX+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABC01F00893;
	Thu, 17 Sep 2026 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659460;
	bh=0j7huc/FvaAoPvvsL4ajXlA87qPY0ete+S2uGgcAiek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yetioX+cDQHi/OG5+pH7hB+Rkx6AHj/czCB3y+d9LZB0pqwdlar8knZNhWsXL7grh
	 hQP8xtwdpzhUNFkQxbzX3Hyf0cGcoRlSyi8DMs91DBcrS0pjauV+R/MLWVqcuTySpl
	 ktfehnouX5tO3g/dTGEazto2owAERD2mk2TWaSyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Yuan Chen <chenyuan@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 264/733] bpf: Preserve special fields in recycled rhtab elements
Date: Thu, 17 Sep 2026 16:09:32 +0100
Message-ID: <20260917151357.907583663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 5df46ddcb7b36878c1b691e9057a0509042a2567 ]

rhtab_map_update_elem() initializes special fields after obtaining an
element from bpf_mem_cache_alloc(). The allocator can return a fresh,
zeroed unit, or recycle one from its RCU-pending lists before the
registered destructor has run.

A BPF program can retain a map-value pointer after deleting its element
and initialize and arm a timer through that pointer. If the deleted unit
is recycled, check_and_init_map_value() clears the only pointer to the
timer. Neither a later deletion nor rhtab_mem_dtor() can then cancel it,
and the callback can run with its key and value pointing into freed memory.

Do not reinitialize special fields on insertion. Fresh allocator units are
already zeroed. For recycled units, the special fields are ownership state
that must remain visible to the eventual destructor. copy_map_value()
already skips those fields, matching the non-preallocated hash-map path and
the lifecycle established by commit 275c30bcee66 ("bpf: Don't reinit map
value in prealloc_lru_pop").

Fixes: 6905f8601298 ("bpf: Allow special fields in resizable hashtab")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
[ kkd: Split out the fix and rewrote the commit log ]
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904104203.345917-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 7f70db4d5dcf0..df22236d1ccf9 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -3072,7 +3072,6 @@ static long rhtab_map_update_elem(struct bpf_map *map, void *key, void *value, u
 
 	memcpy(elem->data, key, map->key_size);
 	copy_map_value(map, rhtab_elem_value(elem, map->key_size), value);
-	check_and_init_map_value(map, rhtab_elem_value(elem, map->key_size));
 
 	/* Prevent deadlock for NMI programs attempting to take bucket lock */
 	bpf_disable_instrumentation();
-- 
2.53.0



