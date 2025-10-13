Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E80B30C621;
	Mon, 13 Oct 2025 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369073; cv=none; b=fKVqppCvoFiJWVs2Hnnw9yP95GXPGkySRkEWXHW44W9cjyLOTkDbC3SIEY5m9oWk3bQPtlG7tVj01WD45HliRvI+LpzPZP4yEglVeRT9XvwoFCqcJXe9xMJ82LDdVgSZZjHprzBcZCjJAS2SEeSYU5tASR3IAeogHZXVKEURJa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369073; c=relaxed/simple;
	bh=7FvIlWRDZF3mY2F6ht8cvKl9Wrm7m3/a+9d++9YilrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ENhJUVdWZ4XsdroeIeLtP4G+oGztVzIoHENcHqj/6WoLHMhxhAbtq8vIxrTqaqsEdn4h4mKe9eAFQRdfl6HNceVzOnBHnbL4n7z3TJ08U15+TyXyiyMjgpHMiKuJ2XeoxFfGU3CJ1dFJFHi0xOcdqrgLpTF+i2J9Ogg+8VjsnGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACX75b44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACX75b44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB37C4CEE7;
	Mon, 13 Oct 2025 15:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369073;
	bh=7FvIlWRDZF3mY2F6ht8cvKl9Wrm7m3/a+9d++9YilrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACX75b44G8wa54F2u3bhKAQoa/1yUPQTEOgCJITmLnq3ZOD2MM1Uz91TCWp9afZAH
	 fLrNt9V0CYjU+afJfmrofd//tL/VjRmtBWxGAA7AXvl0kmO9BDEBqB53M3t5V5tuL7
	 9iu8YGUyh1zG5GeZS/e2iIkVFhd6jG0PW5SAt83Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 091/563] selftests/bpf: Fix count write in testapp_xdp_metadata_copy()
Date: Mon, 13 Oct 2025 16:39:12 +0200
Message-ID: <20251013144414.594362901@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit c9110e6f7237f4a314e2b87b75a8a158b9877a7b ]

Commit 4b302092553c ("selftests/xsk: Add tail adjustment tests and support
check") added a new global to xsk_xdp_progs.c, but left out the access in
the testapp_xdp_metadata_copy() function. Since bpf_map_update_elem() will
write to the whole bss section, it gets truncated. Fix by writing to
skel_rx->bss->count directly.

Fixes: 4b302092553c ("selftests/xsk: Add tail adjustment tests and support check")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250829-selftests-bpf-xsk_regression_fix-v1-1-5f5acdb9fe6b@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xskxceiver.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index a29de0713f19f..352adc8df2d1c 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -2276,25 +2276,13 @@ static int testapp_xdp_metadata_copy(struct test_spec *test)
 {
 	struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
 	struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
-	struct bpf_map *data_map;
-	int count = 0;
-	int key = 0;
 
 	test_spec_set_xdp_prog(test, skel_rx->progs.xsk_xdp_populate_metadata,
 			       skel_tx->progs.xsk_xdp_populate_metadata,
 			       skel_rx->maps.xsk, skel_tx->maps.xsk);
 	test->ifobj_rx->use_metadata = true;
 
-	data_map = bpf_object__find_map_by_name(skel_rx->obj, "xsk_xdp_.bss");
-	if (!data_map || !bpf_map__is_internal(data_map)) {
-		ksft_print_msg("Error: could not find bss section of XDP program\n");
-		return TEST_FAILURE;
-	}
-
-	if (bpf_map_update_elem(bpf_map__fd(data_map), &key, &count, BPF_ANY)) {
-		ksft_print_msg("Error: could not update count element\n");
-		return TEST_FAILURE;
-	}
+	skel_rx->bss->count = 0;
 
 	return testapp_validate_traffic(test);
 }
-- 
2.51.0



