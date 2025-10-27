Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BF7328B5B;
	Mon, 27 Oct 2025 19:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593440; cv=none; b=bhvT2gKEGM/OvKi4KR2fa5vLLF7IecqJ4OAZIooH1G5HgN1LmJlAC69DxUITbIVVLEXdiYqiJgO0skckEWJthT2U087y39wZd645Yu+vEAPhQS9pHM7w2JWNco7s4fH4k9MVM4e4tUZhatRDypqeK5fCv9Bm4TIjULLnZJ1a/Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593440; c=relaxed/simple;
	bh=F1xB4zLolSJpz0vInRl67igN0TJ18GtUCfVFn4AKdj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7HtXorhOxBEsULzrVp2RbJL3+8z/qm2DDtnYXoqxd4IeRHtrBCM+PPf719oImdcaSrKb3uFioAftlPSW4Qs/Tg3JYs7/ced59eNi+WJSMFeS9y1Vk2poOHwJRkiT3hjJQ/Go7Eewz0lYTKhYiPUdQwg6gxci0aFGf1YCL1iiQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLT1gdhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLT1gdhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E63C4CEF1;
	Mon, 27 Oct 2025 19:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593440;
	bh=F1xB4zLolSJpz0vInRl67igN0TJ18GtUCfVFn4AKdj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLT1gdhT+E7GuYgn74o/NkWC6xkp++iEQ/CYrnyaAF2/X8jcHH+M96mP19sh0ZMq8
	 jVklghoWa5rHeITO21flk/WqnBzkhYdovfgAutgRyCvafwxwIOj5EFElckdLWzmnQ5
	 tRzD48KKsKIWdibMfDOs1dEMhn+2cjfTpGJPDvC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Green <evan@rivosinc.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 134/184] riscv: hwprobe: avoid uninitialized variable use in hwprobe_arch_id()
Date: Mon, 27 Oct 2025 19:36:56 +0100
Message-ID: <20251027183518.555230615@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Paul Walmsley <pjw@kernel.org>

[ Upstream commit b7776a802f2f80139f96530a489dd00fd7089eda ]

Resolve this smatch warning:

  arch/riscv/kernel/sys_hwprobe.c:50 hwprobe_arch_id() error: uninitialized symbol 'cpu_id'.

This could happen if hwprobe_arch_id() was called with a key ID of
something other than MVENDORID, MIMPID, and MARCHID.  This does not
happen in the current codebase.  The only caller of hwprobe_arch_id()
is a function that only passes one of those three key IDs.

For the sake of reducing static analyzer warning noise, and in the
unlikely event that hwprobe_arch_id() is someday called with some
other key ID, validate hwprobe_arch_id()'s input to ensure that
'cpu_id' is always initialized before use.

Fixes: ea3de9ce8aa280 ("RISC-V: Add a syscall for HW probing")
Cc: Evan Green <evan@rivosinc.com>
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Link: https://lore.kernel.org/r/cf5a13ec-19d0-9862-059b-943f36107bf3@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/sys_hwprobe.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -30,6 +30,11 @@ static void hwprobe_arch_id(struct riscv
 	bool first = true;
 	int cpu;
 
+	if (pair->key != RISCV_HWPROBE_KEY_MVENDORID &&
+	    pair->key != RISCV_HWPROBE_KEY_MIMPID &&
+	    pair->key != RISCV_HWPROBE_KEY_MARCHID)
+		goto out;
+
 	for_each_cpu(cpu, cpus) {
 		u64 cpu_id;
 
@@ -60,6 +65,7 @@ static void hwprobe_arch_id(struct riscv
 		}
 	}
 
+out:
 	pair->value = id;
 }
 


