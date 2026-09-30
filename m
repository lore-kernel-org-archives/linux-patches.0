Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE783CEB8A;
	Wed, 30 Sep 2026 19:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796767; cv=none; b=lWTkaxXK3hduQlkGAWWnIcfbgAsFB1+3mIv0JW3uNHFtHBGVIzfzQyCxa764JuQgon02kDzlJzZZKiTjdAyvrh4v5UixZGxSZAAM+s8DuB2HPji5npZeen79PI6sC4hLszK4DARAPoAUtlcRy3quGPo/9ke1h/jzMzf3JmKYXXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796767; c=relaxed/simple;
	bh=OhWe6nKODTKcz9HzYYTc1WiL0gxD960FFboMU1wdNws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEVXKbXNMfQ/03GmRQ6wH+YQrvjvUp3BTRIoW1C4qhFPpOQZaqRlfVvVPe+pGdNWRr1Ti5SJOtatd3MzUSsz7iVbGUPWQDQ/4RleeMVBHYi6TZ/hAwKRJ6vqi7pZWOFWdsk6W48gOtqhOfLRKvkXU3EfhDjtkbe6iRmWxaoEI8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2FebPKu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2FebPKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987571F000FF;
	Wed, 30 Sep 2026 19:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796766;
	bh=XGgb/LKm3oWayrAYaTkaTBnJgrveAOxav3EfNbSO8Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2FebPKuOIs5hW85RfWcKcnRoGfw3yvpoZutgQtBmcGfioTseSXUX2u0Rhgh9HrMV
	 ILFTe2sLOwK0DHtuA05P39Lq7eqMBJeSHxRdeH8LJdDwCktObp+1HhZG3y97YeLZkr
	 vlAzUMJpCDq4AuCKiqQZBiQ0LaAXd99VD4E+ZPmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@BYTEDANCE.COM>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1028/1193] bpf, sockmap: Reject max_entries > INT_MAX in sock_map_alloc
Date: Wed, 30 Sep 2026 17:28:32 +0200
Message-ID: <20260930152457.070634113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Gongyi <zhaogongyi@BYTEDANCE.COM>

[ Upstream commit 814a81c842bd88f6bd8a4ce550d560df071a5d03 ]

sock_map_alloc() only rejects max_entries == 0 and otherwise allows any
u32 value.  sock_map_free() then walks the sks[] array with a signed int
iterator:

	int i;
	for (i = 0; i < stab->map.max_entries; i++)
		struct sock **psk = &stab->sks[i];

When a SOCKMAP is created with max_entries = 0xffffffff (UINT_MAX), the
allocation of 32 GiB can succeed on large-memory hosts.  During free the
counter reaches 0x80000000, wraps to INT_MIN, is sign-extended by movslq
and turned into a ~16 GiB negative offset from stab->sks, pointing far
below the allocation.

The faulting access is an xchg() write in sock_map_free().  Without
KASAN, the same out-of-bounds write can fault on an unmapped vmalloc page
or corrupt an unrelated allocation if that vmalloc address is populated.
On a KASAN kernel with CONFIG_KASAN_VMALLOC=y, the shadow check for that
address hits an unmapped shadow page and oopses first:

  BUG: unable to handle page fault for address: fffff521b59c5a00
  RIP: 0010:kasan_check_range+0x107/0x190
  Call Trace:
   sock_map_free+0x93/0x190
   map_create+0x68d/0xb30
   __sys_bpf+0x21e/0x2e70

Vmcore confirmed stab->map.max_entries == 0xffffffff, stab->sks ==
0xffffc911ace2d000, and the faulting address sks + (s64)INT_MIN * 8
exactly at 0xffffc90dace2d000.  The same buggy path is reached on the
normal close()/bpf_map_free_deferred() path whenever such a map is
destroyed.

sock_map_alloc() used to bound its allocation size through
bpf_map_charge_init(), but the bound was dropped when rlimit-based memory
accounting was removed.  Reject max_entries > INT_MAX at creation time so
the signed iterator in sock_map_free() never sees a value that would
overflow.

Triggered by syzkaller and reproduced on both a 6.6-based KASAN kernel
and the upstream v7.3-rc2 kernel.

Fixes: 0d2c4f964050 ("bpf: Eliminate rlimit-based memory accounting for sockmap and sockhash maps")
Signed-off-by: Zhao Gongyi <zhaogongyi@BYTEDANCE.COM>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260917121016.48171-1-zhaogongyi@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 052057303cff1..7aaa2b8f4aff2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -33,6 +33,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	struct bpf_stab *stab;
 
 	if (attr->max_entries == 0 ||
+	    attr->max_entries > INT_MAX ||
 	    attr->key_size    != 4 ||
 	    (attr->value_size != sizeof(u32) &&
 	     attr->value_size != sizeof(u64)) ||
-- 
2.53.0



