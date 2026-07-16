Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484DC42A783;
	Thu, 16 Jul 2026 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211366; cv=none; b=BDNAeuw5+Txlyyyq606a+WWFXCtzX5tf9PDVwW0W/k6QHd+7LZxi4cxfPyWkEOo5b5oFlP3eK+wM9SXqus2plWhPdpY+wTSRhpXcTRt9XBVl0k9aR5bs9T5ZDSeW/i7krPsTJgCCuebt4yZWiJpmBY3sfrH7cDsqZJEIbZkXeVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211366; c=relaxed/simple;
	bh=GEKcb0duBNqwu9b5hDWjX2t3b6kU99Dm65nEEe9bTWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgrSZjJGMjgqLY8gugNKdXBfHFTUr1sDLwv9dApwmxyoQ7wCGQf1KDbRVr9OzEYjj+IlaiHz94nE32tet1X8IRymc8k6AJRyqJ/kT6rahpw7S9HvD7QO0VBn69np6UjRieTXlouxnT1gX2upjWgu1YdmlZd6f32be0ZLRXbuBao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiXtM3V9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiXtM3V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0B61F00A3A;
	Thu, 16 Jul 2026 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211364;
	bh=dVDgPv7ntn1q/79F8zki+yQNyCY3PzDdXKjqP+aSyjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiXtM3V9+80MG0McKeL88ZFlnEJXmifitlW55ce2qXBGeJn22vG8bcqcBl2iaqAGM
	 rB0PI7UQ+xY3Yrn9kCVVXlTSzuDrlLCvEqEZ6S5JAy3vLWaaur6Pyza5hyD3OxRwFX
	 w+rJqmviXQyYIBNKwbNvkAek+It4BgEfxeX6qthE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 399/480] riscv: mm: Unconditionally sfence.vma for spurious fault
Date: Thu, 16 Jul 2026 15:32:26 +0200
Message-ID: <20260716133053.436911290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit 1b2c6b56a9fa0dcbef461039937de22b1cbecc7d upstream.

Svvptc does not guarantee that it's safe to just return here. Since we
have already cleared our bit, if, theoretically, the bounded timeframe
for the accessed page to become valid still hasn't happened after sret,
we could fault again and actually crash.

Hopefully, these spurious faults should be rare enough that this is an
acceptable slowdown.

Cc: stable@vger.kernel.org
Fixes: 503638e0babf ("riscv: Stop emitting preventive sfence.vma for new vmalloc mappings")
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Link: https://patch.msgid.link/20260303-handle-kfence-protect-spurious-fault-v2-5-f80d8354d79d@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/entry.S |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -75,8 +75,11 @@
 	/* Atomically reset the current cpu bit in new_vmalloc */
 	amoxor.d	a0, a1, (a0)
 
-	/* Only emit a sfence.vma if the uarch caches invalid entries */
-	ALTERNATIVE("sfence.vma", "nop", 0, RISCV_ISA_EXT_SVVPTC, 1)
+	/*
+	 * A sfence.vma is required here. Even if we had Svvptc, there's no
+	 * guarantee that after returning we wouldn't just fault again.
+	 */
+	sfence.vma
 
 	REG_L	a0, TASK_TI_A0(tp)
 	REG_L	a1, TASK_TI_A1(tp)


