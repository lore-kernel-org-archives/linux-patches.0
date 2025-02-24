Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE5438DD8;
	Mon, 24 Feb 2025 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409092; cv=none; b=Xu8YxFzsk/6ZtLTO8Dbruh4u5D/7/TdP1QXwdh+/NUnxRVohESzcbnynkuCtvZWfu7Y+rQe2FsnU3yuUUh0mukkodoMJFDc8xQCer3rpewf7Bqjnr46Z/rrbcayMrBk8+5pGiH1i8HXYTm3GgL+ae4RkgVGSKpzdCB0iV1VXHdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409092; c=relaxed/simple;
	bh=5N9QlK3hSf1/2GpdAOiqKHEVUXZ9eNX56QWlOS/i0uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMU7rkx01Kb85Ih3ru2MCypf+e660RVhAbn2CMpFF1I5gGWgbe4yoR7Usi9MvfnkIQCPWH3ACeCFF1pWSL+2vwRfddR7xIpRyJidLYok9MzcPQk7+9fxl0AJX7L5hmY5iU76iKQ2j1QgkFUtkI7klIBlcPQZUDAQUJsMDJrDgho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxWqTQgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxWqTQgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5656C4CED6;
	Mon, 24 Feb 2025 14:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409092;
	bh=5N9QlK3hSf1/2GpdAOiqKHEVUXZ9eNX56QWlOS/i0uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxWqTQgpDFblO5KmRYgg5moJ00035bXkzOad2fkWL0TZm9mQAFw5DuZLCHBAs2X3a
	 NXwc09SrS6lKYI0mX9ukymUL+jEcJD3FR8e7nAP7KxJeEKLBWEy5hpLwq3I5PLKpBd
	 8QiNegV/c1sV2aU/+Xks2WnbyfHRmNNE6mue9FuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colm Harrington <colm.harrington@oracle.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 062/138] bpf: Fix softlockup in arena_map_free on 64k page kernel
Date: Mon, 24 Feb 2025 15:34:52 +0100
Message-ID: <20250224142606.917905923@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8caf56a308d96..eac5d1edefe97 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -39,7 +39,7 @@
  */
 
 /* number of bytes addressable by LDX/STX insn with 16-bit 'off' field */
-#define GUARD_SZ (1ull << sizeof_field(struct bpf_insn, off) * 8)
+#define GUARD_SZ round_up(1ull << sizeof_field(struct bpf_insn, off) * 8, PAGE_SIZE << 1)
 #define KERN_VM_SZ (SZ_4G + GUARD_SZ)
 
 struct bpf_arena {
-- 
2.39.5



