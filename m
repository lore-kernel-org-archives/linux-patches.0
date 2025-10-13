Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC043090CE;
	Mon, 13 Oct 2025 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370248; cv=none; b=CdEt6O30NGCPm5VRpeJihlZ8p9PcFJdGc0Xn6ZBUgQwxM8pSrHS6pZ1K2UeE008e/yvpYU/fQkNsPXvzzYQDMxHb7MZQ7tCVpdxQGLLONsTH8J4rY0UcjacNRI3ERihH/qG6vDABwLfbn7SS2CZpGAWzsWkgGjFdIR5xZ/X793w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370248; c=relaxed/simple;
	bh=7p1ZL2AeWDkfGEDiKXME8HdzUKTkNTBrht6OxyYQHTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWNRI3V9iVZ47B22IxXd5fZUNool5DP5RfxNpfTxyZi+CbtP7rcpdXdB3FlRZuovI5EyyF9AGrZmZ/HmVMQiCZ6SJnRGlOXiXej16rDeGkFo8GbNz6rYScmEYC6J3Ba6DIB0kuwoGwB6GaPXYS5PvfN5ctzeRMq/Ej8NRKaLS9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHynKQnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHynKQnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF165C4CEE7;
	Mon, 13 Oct 2025 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370248;
	bh=7p1ZL2AeWDkfGEDiKXME8HdzUKTkNTBrht6OxyYQHTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHynKQnBy4o0bbQ7oUYJRUsG/zRO9JKvu1j4AhQFjHA7zXP4A9m570AB/JBy3t7Wa
	 lz2CToGjUXsrOkQcN/jRYPn6iMkPk6qLYAXaHQm+ko5mI3hJNqeXhuGow6rBavNNSn
	 K3J24BMAnQ7FQfnvZHUYREeg/CliqilWa+GToH2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 531/563] LoongArch: BPF: Fix uninitialized symbol retval_off
Date: Mon, 13 Oct 2025 16:46:32 +0200
Message-ID: <20251013144430.546943707@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 7b6c2d172d023d344527d3cb4516d0d6b29f4919 upstream.

In __arch_prepare_bpf_trampoline(), retval_off is meaningful only when
save_ret is not 0, so the current logic is correct. But it may cause a
build warning:

arch/loongarch/net/bpf_jit.c:1547 __arch_prepare_bpf_trampoline() error: uninitialized symbol 'retval_off'.

So initialize retval_off unconditionally to fix it.

Cc: stable@vger.kernel.org
Fixes: f9b6b41f0cf3 ("LoongArch: BPF: Add basic bpf trampoline support")
Closes: https://lore.kernel.org/r/202508191020.PBBh07cK-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1538,11 +1538,10 @@ static int __arch_prepare_bpf_trampoline
 	stack_size = 16;
 
 	save_ret = flags & (BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_RET_FENTRY_RET);
-	if (save_ret) {
-		/* Save BPF R0 and A0 */
-		stack_size += 16;
-		retval_off = stack_size;
-	}
+	if (save_ret)
+		stack_size += 16; /* Save BPF R0 and A0 */
+
+	retval_off = stack_size;
 
 	/* Room of trampoline frame to store args */
 	nargs = m->nr_args;


