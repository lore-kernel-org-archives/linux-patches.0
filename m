Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B694627587D;
	Tue, 21 Oct 2025 20:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077578; cv=none; b=BThXgzwpgEvQRqOoK60AgD5y2XBKtcKLDATm8IATongVh7UaX23QUU3pNZ5SyNikTDHnrHJJTXU2ZvoITr0GPPU1+ssvslLUjOIvPQMOyw5W4XVcQBWThkpx0iSzujmt9qr/oq5ZhLJlituEqtjfLBWSsJMXu6UMQkfjgPCToiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077578; c=relaxed/simple;
	bh=iE+Cu4NqKQSdK+Ie1DPmuCjLKK9wfxN5ZogUzzykChs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVGzae7ASoWv4qxv/Xui0jz6z2kjyRYZnFYC8J3hx10RdS2HdkjK9PT+cOYViqzAGJ1as2OYchirkKZlrIG0xrcMsLfm2hLwhDyKHpZcS0s5ZhaN6Hi1gzBhP0G2UMonymNZcW0fhQt5HoDl7EnPqA/+5Q2KEdeNhkv1qXLlfxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDG47XZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDG47XZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A07C4CEF1;
	Tue, 21 Oct 2025 20:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077578;
	bh=iE+Cu4NqKQSdK+Ie1DPmuCjLKK9wfxN5ZogUzzykChs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDG47XZK3gIlsXqCgFLVtptwKDYL6E3HD6KtwBK17WXm1todcscrfZvW5EjDpAU9F
	 O9zfWvrJfw1yInyPthftLtUP8Cl6wlX/POfog0ne6WZOmsnZt4jdl4/QU9xPzAyWxt
	 6XVCRIW7Izca9QvqJZ+6espz37wdbvIsE9lMIeUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babu Moger <babu.moger@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 150/159] x86/resctrl: Refactor resctrl_arch_rmid_read()
Date: Tue, 21 Oct 2025 21:52:07 +0200
Message-ID: <20251021195046.781315630@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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
@@ -224,24 +224,13 @@ static u64 mbm_overflow_count(u64 prev_m
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
@@ -253,7 +242,26 @@ int resctrl_arch_rmid_read(struct rdt_re
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


