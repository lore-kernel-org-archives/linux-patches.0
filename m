Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4A21B3927;
	Mon, 10 Mar 2025 17:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628323; cv=none; b=cP5Iikxe1w1CKBGfwYusVbmA/NhUNvNLxY5HCUG6c/rvMPFg54ppBkVVUIXdaW7Ugw03PQl0IvydBbFd97+Rd/n2GFqQ05BIs0B8cJRztPUjJ/uc3PfgGG/gzyg48o1KVaE4aSEs4NNm5RqtLZ95CxQZOc4JObGYWHTNZSkzQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628323; c=relaxed/simple;
	bh=AZiF63Di2n/qcVWkyg0rxYricfWXoescIA39/PzL1M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2KfKxmLlRaOVJIhba2HaS8lsPUE28hXO1camR/dQlF2X7YSwnXftlBLjkZBYt8F4u0oD5A4kmdTmGprw/vNqf8vSPW5+8J1bHuHHI+0fkhatg2Dea6+/AsseC2Aem/5qG7qDt0tyc2vo4xohaPOl/DHCJ/6izcmu32slFpaMYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CADm8Fc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CADm8Fc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60E3C4CEEC;
	Mon, 10 Mar 2025 17:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628323;
	bh=AZiF63Di2n/qcVWkyg0rxYricfWXoescIA39/PzL1M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CADm8Fc15m7AQysAX21c+9nOreq6MoR6NINTKlOm277AZsukb7kWilEFcFzCmf0LN
	 s0Qk9Ff4G1VtPxFnmBuY3I/hLm4frUbZlU5xyqEg8EnkypLd2cP19TWbttY2vGQIQo
	 IkOfcSiWr4bU1d82ap8PbWUSXFYPD9NsUTgqqcXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/109] cpuidle, intel_idle: Fix CPUIDLE_FLAG_IBRS
Date: Mon, 10 Mar 2025 18:05:49 +0100
Message-ID: <20250310170427.760538798@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 9b461a6faae7b220c32466261965778b10189e54 ]

objtool to the rescue:

  vmlinux.o: warning: objtool: intel_idle_ibrs+0x17: call to spec_ctrl_current() leaves .noinstr.text section
  vmlinux.o: warning: objtool: intel_idle_ibrs+0x27: call to wrmsrl.constprop.0() leaves .noinstr.text section

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>
Tested-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20230112195540.556912863@infradead.org
Stable-dep-of: c157d351460b ("intel_idle: Handle older CPUs, which stop the TSC in deeper C states, correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 2 +-
 drivers/idle/intel_idle.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 03221a060ae77..7d73b53115514 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -92,7 +92,7 @@ void update_spec_ctrl_cond(u64 val)
 		wrmsrl(MSR_IA32_SPEC_CTRL, val);
 }
 
-u64 spec_ctrl_current(void)
+noinstr u64 spec_ctrl_current(void)
 {
 	return this_cpu_read(x86_spec_ctrl_current);
 }
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 5d7bbccb52b5e..ae07dc018e666 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -188,12 +188,12 @@ static __cpuidle int intel_idle_ibrs(struct cpuidle_device *dev,
 	int ret;
 
 	if (smt_active)
-		wrmsrl(MSR_IA32_SPEC_CTRL, 0);
+		native_wrmsrl(MSR_IA32_SPEC_CTRL, 0);
 
 	ret = __intel_idle(dev, drv, index);
 
 	if (smt_active)
-		wrmsrl(MSR_IA32_SPEC_CTRL, spec_ctrl);
+		native_wrmsrl(MSR_IA32_SPEC_CTRL, spec_ctrl);
 
 	return ret;
 }
-- 
2.39.5



