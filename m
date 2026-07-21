Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0F146D098;
	Tue, 21 Jul 2026 17:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656248; cv=none; b=Dyzuwb7S4P9+8eKETbZOMclCy55xAI96JSiubV30hzgjf4KsvzjV9zeLZ2rnkygrt2f93LA1xMepSMAbH/8I6aVxmuS8VrW7UGLYQTZjbdoyZD+Ez1F/Gv9FbeSuKhjIvJlA5sHtck95nsiyh2Ko9DcR8fkIdkPpl97672T5/mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656248; c=relaxed/simple;
	bh=GvTV/+05a8UGkK0DJBzT2szac+RomJUbT3FWhzsWXGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8re8Ibbn80Jm+WAcgeOjHB0X+JouygJxaNbVfcNfB/9/R+wXho6D/h9gC29qXZbYvCoCtnQhBI/STN49blBhHZcsTD4y4/45tPzNR2bVeQKNTjaoL6W2m1nkl3++emediEonfRNDkiOCHGQsaF34LjwPsKjEm0OEDdqfsKj84c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvXulmAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvXulmAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713461F000E9;
	Tue, 21 Jul 2026 17:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656247;
	bh=9Glqd5PiAjc6IGlXqbTluIEt3BfnNxiBQyOdIiptmCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvXulmACtNdxvs8OCQhejdBPQYq4GMJwiqs4ySzAkmyLvUv7/UfFjFVepcNsnz7QP
	 WIoPc7GkywN4N2mfzSv0t4/6Fd+M6htiwTL92Tz/Kx7G7fN+ADnH44dn++g9UpJTE3
	 eL0neiUTXB7oem1ftqFryOUKDmrE3TDZ7g6BsMuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0314/1611] bpf: Reject exclusive maps for bpf_map_elem iterators
Date: Tue, 21 Jul 2026 17:07:10 +0200
Message-ID: <20260721152522.141907876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3c56ee343f9412d81918635c3e25e22a5dd6d87e ]

Exclusive maps (aka excl_prog_hash) are meant to be reachable only
from the single program whose hash matches. This is enforced by
check_map_prog_compatibility() when the map is referenced from a
program such as signed BPF loaders.

A bpf_map_elem iterator, however, binds its target map at attach
time in bpf_iter_attach_map() instead of referencing it from the
program, so the exclusivity check is never reached. On top of that,
the iterator exposes the map value as a writable buffer.

Fixes: baefdbdf6812 ("bpf: Implement exclusive map creation")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260602133052.423725-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/map_iter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index 9575314f40a692..f84af5cddd431f 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -112,6 +112,10 @@ static int bpf_iter_attach_map(struct bpf_prog *prog,
 	map = bpf_map_get_with_uref(linfo->map.map_fd);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
+	if (map->excl_prog_sha) {
+		err = -EPERM;
+		goto put_map;
+	}
 
 	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
 	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
-- 
2.53.0



