Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA9D25A355;
	Tue, 21 Oct 2025 20:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077034; cv=none; b=HJSKQQRdPHNeCGNpgLDLP4EwJPNx+OtYbIYUsUck4EDgE6cLmwXBsFPfcUZBLPXV/TRDTsJMKBm2dozNN4txQgRDxRODOh91cgtwfiphfoj3Auq2oXyOusFYvG23Vdk8QgY9HIdmO1Oo8zHCViZis293xijTCZMor35+F771sqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077034; c=relaxed/simple;
	bh=065M9XyQPuFsfWB0Y+B4lm7uEGG/Y4VIyVrj4IEyoPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYCb+TRD3UGbdsSoGQpsAMxxvDXKIQy6UoHI6iRqAFoRNXaJIjVYGyRJ/RCR2lCObyXiP5ZVVsTRDTwtc4kXWtrY/DJjVz2FUDycYnn9wGWr4PoSs9VmZ1LChK1qotTxR2841e8/ttb86b8OjEVzVxEupOt+ZK2dylWqPVSUD2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akHNIQfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akHNIQfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8FCC116C6;
	Tue, 21 Oct 2025 20:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077033;
	bh=065M9XyQPuFsfWB0Y+B4lm7uEGG/Y4VIyVrj4IEyoPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akHNIQfMeUHhNb3BDpI7fM5llvXWo4XF+mYv1q6+9qjYomQsHsJfqu6BGB7tMCcGK
	 HtLXuCCu9B12yBEb4N5YBHMFpkXXXWtKXzXFgSx//kIElj8Uk1P9ML0Gu3nACFjM4F
	 EN9zEpQMJpyBMZhL16Tnhxhp1R/tRDcE4v5IfVaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babu Moger <babu.moger@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/136] x86/resctrl: Refactor resctrl_arch_rmid_read()
Date: Tue, 21 Oct 2025 21:51:43 +0200
Message-ID: <20251021195038.734871061@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babu Moger <babu.moger@amd.com>

[ Upstream commit 7c9ac605e202c4668e441fc8146a993577131ca1 ]

resctrl_arch_rmid_read() adjusts the value obtained from MSR_IA32_QM_CTR to
account for the overflow for MBM events and apply counter scaling for all the
events. This logic is common to both reading an RMID and reading a hardware
counter directly.

Refactor the hardware value adjustment logic into get_corrected_val() to
prepare for support of reading a hardware counter.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/cover.1757108044.git.babu.moger@amd.com
Stable-dep-of: 15292f1b4c55 ("x86/resctrl: Fix miscount of bandwidth event when reactivating previously unavailable RMID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/resctrl/monitor.c |   38 ++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -312,24 +312,13 @@ static u64 mbm_overflow_count(u64 prev_m
 	return chunks >> shift;
 }
 
-int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
-			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
-			   u64 *val, void *ignored)
+static u64 get_corrected_val(struct rdt_resource *r, struct rdt_mon_domain *d,
+			     u32 rmid, enum resctrl_event_id eventid, u64 msr_val)
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
-	int cpu = cpumask_any(&d->hdr.cpu_mask);
 	struct arch_mbm_state *am;
-	u64 msr_val, chunks;
-	u32 prmid;
-	int ret;
-
-	resctrl_arch_rmid_read_context_check();
-
-	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
-	ret = __rmid_read_phys(prmid, eventid, &msr_val);
-	if (ret)
-		return ret;
+	u64 chunks;
 
 	am = get_arch_mbm_state(hw_dom, rmid, eventid);
 	if (am) {
@@ -341,7 +330,26 @@ int resctrl_arch_rmid_read(struct rdt_re
 		chunks = msr_val;
 	}
 
-	*val = chunks * hw_res->mon_scale;
+	return chunks * hw_res->mon_scale;
+}
+
+int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+			   u32 unused, u32 rmid, enum resctrl_event_id eventid,
+			   u64 *val, void *ignored)
+{
+	int cpu = cpumask_any(&d->hdr.cpu_mask);
+	u64 msr_val;
+	u32 prmid;
+	int ret;
+
+	resctrl_arch_rmid_read_context_check();
+
+	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
+	ret = __rmid_read_phys(prmid, eventid, &msr_val);
+	if (ret)
+		return ret;
+
+	*val = get_corrected_val(r, d, rmid, eventid, msr_val);
 
 	return 0;
 }


