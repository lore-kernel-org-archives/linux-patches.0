Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C76231C91;
	Fri,  9 Oct 2026 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556377; cv=none; b=t4RzYWwOYrnzEpc8/7aAKdop5JevKiO+Ck+FRR1muMFJy1VNMO69w4qR9gtfpPe8ODNxA7iWCbg4nDZ1Vp3iqJIO1KorlcmXXtQOMZK7Zr6FxIu4uOvInnKzwG5bsDTh5Meq5N/YsEfTUgxa4B3A6uouOJ83nmyymZQzQuqk/p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556377; c=relaxed/simple;
	bh=5vUh7BYWuXPa2+R1NZfiLV4QR2aN0fNSiB8nPpBmH0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbMBy2Puw9TCfjmgbn0wlgAlH07SqrE49tGr98a9DPmhGtQmJosHHn2zrMyOpuMUJ2QPGnwG/UJGf297+6Mp9XqlFUQL5J4IWelImywZUbm4wAgRkdwPKFTKSN3GS5k43tWpK7GIFXBh0mdzLl/llOpLwVov4uIGBy3k1Vsqtkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+HscC+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+HscC+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A561F1F000FF;
	Fri,  9 Oct 2026 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556376;
	bh=0r9KpOxhtlSIxaPk2KO0DcXG08KbQCCOowvg2OgwHbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+HscC+ZDxeXexQfq0P6y6yBXsWXyH3N9A5UNiXO2KC1NN4nS0QkxEAeqnqJHmIk5
	 q8mXe6nYye3Ik8qH0bmfAd0L/MCniuWzaRAFmfehHVY5m30Ly9Jr7fqnunMaYPKYWw
	 x3LzpIXqtTDuzllvotNp6r4rjaUR/Cat9VbLIKj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fd7e415d891073b83e1f@syzkaller.appspotmail.com,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 166/428] bpf: Fix missing migration protection in __rhtab_map_lookup_and_delete_batch()
Date: Fri,  9 Oct 2026 16:08:23 +0200
Message-ID: <20261009140949.804523752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ömer Mete Kaya <omermetekaya0@gmail.com>

[ Upstream commit de020dc8049bfb2b22e3b6d99c031feb2e22d112 ]

bpf_mem_cache_free_rcu() uses this_cpu_ptr() which requires migration
to be disabled. All callers of rhtab_delete_elem() disable migration
except __rhtab_map_lookup_and_delete_batch(), which calls it under
rcu_read_lock() only.

On CONFIG_PREEMPT_RCU, rcu_read_lock() does not disable preemption or
migration, so the task can migrate between CPUs during the delete loop,
causing this_cpu_ptr() to trigger:

  BUG: using smp_processor_id() in preemptible [00000000] code

Fix by wrapping the delete loop in migrate_disable()/migrate_enable()
in __rhtab_map_lookup_and_delete_batch(), matching the migration
protection that the other callers already provide.

Fixes: 818e00848227 ("bpf: Implement iteration ops for resizable hashtab")
Reported-by: syzbot+fd7e415d891073b83e1f@syzkaller.appspotmail.com
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://patch.msgid.link/20260929081609.557899-1-omermetekaya0@gmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fd7e415d891073b83e1f
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 68b7e87268f21..84cfeb9270d16 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -3376,8 +3376,10 @@ static int __rhtab_map_lookup_and_delete_batch(struct bpf_map *map,
 	}
 
 	if (do_delete) {
+		migrate_disable();
 		for (i = 0; i < total; i++)
 			rhtab_delete_elem(rhtab, del_elems[i], NULL, 0);
+		migrate_enable();
 	}
 
 	rcu_read_unlock();
-- 
2.53.0



