Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF54446D556;
	Tue, 21 Jul 2026 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649079; cv=none; b=WuMWMDOzZAw4YEwlofw09O88N0MmDvrOdU4BnC3h9YiFhFSVNyDuqX2T5Hs1f0OAGSUvjn2M33JRI+JJq6BszXP5QAGrcRSKAuSsS5MwjETaQPWXDw+JjX65d9i+RhbFiCHhm84oxvaQhGoodDulNtSPHHR5kIAabY+XlIsi7J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649079; c=relaxed/simple;
	bh=uGYWFMZT3EEdaV6OkIyqXccuahflRcLtrxa8Gavm3fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtW5QM03/0QkeNWjgwcHioHyH83XDCFfTXwQVJU0oYqRbkryuDkgRje8H0GXWmUwEplB0Uk/sloYyLU/cFcL5z8gRgM3W31t55W9giTeXFssOwTvW0V0hNWsbBWd8U51jeyaiMZx++/w+je1qGuFIuy/QJOyYGhzu0p3irKaRv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnCtWj+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnCtWj+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BA91F000E9;
	Tue, 21 Jul 2026 15:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649078;
	bh=+2qeb6z5oXEzsi8/7H0T5Mpmy0Vn3fOBVg8mEOAfJlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnCtWj+RA2bPm6LqawgBVWxqTqxES+14gEQohbYONrA7xxAFr9ak9ETTbPs3B8aDY
	 ayAkmHoAWAP9SdhHk1fzqMA6mOVLGIARXOW2lllZXW/iDMwuZ5Xu7clYgUPKbMU2FP
	 wpBzzgo8vuHIKLs+ijHuH/t8q1mmdo36vDuvxo4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0441/2077] bpf: Reject exclusive maps for bpf_map_elem iterators
Date: Tue, 21 Jul 2026 17:01:54 +0200
Message-ID: <20260721152603.164445416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 261a03ea73d349..ae0741a09c6dee 100644
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



