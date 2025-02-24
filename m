Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72DF15442C;
	Mon, 24 Feb 2025 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408539; cv=none; b=VZL75q1yerkGbnF2rjVhDFekEBMGBk7s3BKSNdt1BCzSj+6qk3LgujdHhFANJKZY0it5aBQo8trxUpFmNPWhQOKYmee4VT3PEmkCtFzIanHB2jgH2QbkCaisWhh+/QwHjvw6B4az3U5xRw2hNmgmME57Wanzy7NTotsUxhgKkxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408539; c=relaxed/simple;
	bh=/9uEFDGvSmE2REwoYTHI2X2vBWr7fd8yoBqqykK3u8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E95OwtlZgp+0Mq3k/9Wn3wldGqFeDOkMKzl4sCRuNfoXFiPfbOybxbdmbsLq5Qmj4Bxn6i7V3xXfcAJYKMOEtU9wLOxssmJkMf3mkRGIT3mVcO0xtoqlWSnh03/GXumAkOv78RtyLmBdj93DxeGBAsZjQEFDtoNVJy/XCJKApXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0l6AzFdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0l6AzFdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47191C4CED6;
	Mon, 24 Feb 2025 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408539;
	bh=/9uEFDGvSmE2REwoYTHI2X2vBWr7fd8yoBqqykK3u8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0l6AzFdNMK9t+TovwjJ4St2O1D7Z/8Iezwfd1408oMK3oLvxN4ZcJ16WDYe38j+wX
	 GP72ORJsjMR+JSnNj2nuEk9rS5wi9cHx5ttl/Yd/u5Mb6jAaO2dUuFM65xtv+DzUV+
	 hJuFYn5da/sQP/0bI7Gl/uRdHoTypeVsz2nHG3Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colm Harrington <colm.harrington@oracle.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/154] bpf: Fix softlockup in arena_map_free on 64k page kernel
Date: Mon, 24 Feb 2025 15:34:45 +0100
Message-ID: <20250224142610.441876868@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 517e8a7835e8cfb398a0aeb0133de50e31cae32b ]

On an aarch64 kernel with CONFIG_PAGE_SIZE_64KB=y,
arena_htab tests cause a segmentation fault and soft lockup.
The same failure is not observed with 4k pages on aarch64.

It turns out arena_map_free() is calling
apply_to_existing_page_range() with the address returned by
bpf_arena_get_kern_vm_start().  If this address is not page-aligned
the code ends up calling apply_to_pte_range() with that unaligned
address causing soft lockup.

Fix it by round up GUARD_SZ to PAGE_SIZE << 1 so that the
division by 2 in bpf_arena_get_kern_vm_start() returns
a page-aligned value.

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Reported-by: Colm Harrington <colm.harrington@oracle.com>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/r/20250205170059.427458-1-alan.maguire@oracle.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 93e48c7cad4ef..8c775a1401d3e 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -37,7 +37,7 @@
  */
 
 /* number of bytes addressable by LDX/STX insn with 16-bit 'off' field */
-#define GUARD_SZ (1ull << sizeof_field(struct bpf_insn, off) * 8)
+#define GUARD_SZ round_up(1ull << sizeof_field(struct bpf_insn, off) * 8, PAGE_SIZE << 1)
 #define KERN_VM_SZ (SZ_4G + GUARD_SZ)
 
 struct bpf_arena {
-- 
2.39.5



