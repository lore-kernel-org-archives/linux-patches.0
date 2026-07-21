Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF9E435A96;
	Tue, 21 Jul 2026 20:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665545; cv=none; b=uLNqUdLZBSveBl5pfrdzSeFuhbvAMzHonmRwy/6VFmMN+2V/FPhMEIH9YjLywTeEgGI93CQiYl+TZ5NQRy/gy6HIm4SCqOv+YWRqT1rZXwJ5QFKoc9spen/Cmipq8jAOEN+T9YKjWIeh8Dg4JUkP+nrPmA0H2I2IlxcVCC64N+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665545; c=relaxed/simple;
	bh=n5VmYAy5yfX4qy9s7hu0mUX7D4HadPoc2eiFXQ6QZEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOxslv11gJOuKtorkQjHCq/FD0QxxfzomxYzcC2m0bDM1UM4lml0o5/IcOMOPgKNW8DxjK8dr2dIZD0iqnU68pibPo4WUW6DNsvFB19U4HZ+j4fZROEpsWmIIL+UMmMOaEXWUpkAqsPbixsxYGzjauagKpYc1rJJ6c2hj4C/U0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfk6gvAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfk6gvAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694F81F000E9;
	Tue, 21 Jul 2026 20:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665543;
	bh=+N/1ZvugzQX2c0OQNVspOTXAF1kgLK072nc9bysmUFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfk6gvACPkFM7gFqRjDkQmQbpITlRpjWbyZOiswxxHpzMuCaAvQ8ABhEyaZH0y468
	 LVXzp51vzPmRIDaC5FocavyQHlr0PhyfWjqQlTyffXHwB+R0aya0/ooj53/WOtkBuR
	 WDRYN7lSMPZwzwvwR7MD3WyaPhOEA8sQ7qq/IbJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0344/1266] bpf: Prefer dirty packs for eBPF allocations
Date: Tue, 21 Jul 2026 17:13:01 +0200
Message-ID: <20260721152449.530689711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit b72e29e0f7ee329d89f86db8700c8ea99b4a370a upstream.

The pack allocator only flushes predictors when reusing a dirty pack for
cBPF, eBPF allocations never trigger a flush. Currently, eBPF picks the
first free pack, which could be a clean pack. As an optimization, leaving
a clean pack for cBPF can avoid flushes.

Prefer dirty packs for eBPF and keep clean packs free for cBPF. This
mirrors the existing cBPF preference for clean packs: each program kind
prefers the pack that avoids an extra flush, and falls back to the other
kind only when no preferred pack has room. eBPF reuse of a dirty pack is
harmless since eBPF being privileged does not flush.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7dc59570cd25a5..4669a57265ad75 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -950,10 +950,10 @@ void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool
 			goto found_free_area;
 		/*
 		 * cBPF reuse of a dirty pack triggers a flush, so prefer a
-		 * clean pack for cBPF. eBPF never flushes, so pick the first
-		 * free pack, dirty or clean.
+		 * clean pack for cBPF. eBPF never flushes, so steer it to a
+		 * dirty pack and keep clean packs free for cBPF.
 		 */
-		if (!was_classic || !pack->arch_flush_needed)
+		if (was_classic ^ pack->arch_flush_needed)
 			goto found_free_area;
 		if (!fallback_pack) {
 			fallback_pack = pack;
-- 
2.53.0



