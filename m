Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7ED319601;
	Thu, 16 Jul 2026 14:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210955; cv=none; b=BkI2nvhX0fIz0P+SW8BrrdokiP7CfkeYtdDA/P9SJbdQ5vRQL67ups4Ht7ZQG/ix60f+mfNEfICGQLEpI7MlmfMmD8Ot+f4Ymr6gvTW32sYN4JUWB570hbRymL5RF7jig7i7Q7mZ4cC0C4BNjr+dV60e7QtyJYaV4w+cKUhQWxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210955; c=relaxed/simple;
	bh=yzn0JkJXGsnZ1Iymkc5Ujr8LWMCh+hKvOlYB0jKI37s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yra32t10skvszscq5a53+WI8WSCyzSXU18AERAu6kTGHcUZohcyoB+9QUr9wlxKrlfu8bscTTiqUMIcZW6nPpwm3nn1zl3bjl5b2cP3LEJMb9mzUQ02+C7DQr0vj9QFASr+bkmy6skp1EiAbdvSTnCbj3vY/89bExRpXza5cHmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qhGFCz9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qhGFCz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6EC1F000E9;
	Thu, 16 Jul 2026 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210954;
	bh=lpsTsAMitGnQTDZS9Gk2NRd2kaaSSDVl+n9OfUMgY5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qhGFCz9iH6NJJLTsT0nDBCC354ayyX1T6J8VFfsddzS3qmtTHRUOXxY6HOYE2hpj
	 OvkWgcpYRvKCA7IWw+juvQhs96Z4r4k2EXIMw6+oWIsGIy8y1r+FwuDtrGluaNllX5
	 +3TiYMkY0sYkCwx3mVLSeqQ/xBym35RFAlklYVfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 6.18 245/480] perf/x86/intel/uncore: Defer ADL global PMON enable to enable_box()
Date: Thu, 16 Jul 2026 15:29:52 +0200
Message-ID: <20260716133050.119742181@linuxfoundation.org>
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

From: Zide Chen <zide.chen@intel.com>

commit 9a0bb848a37150aeccc10088e141339917d995dc upstream.

On some Raptor Cove CPUs, enabling uncore PMON globally at driver init
may increase power consumption even when no perf events are in use.

Drop adl_uncore_msr_init_box() and defer programming the global control
register to enable_box(), so it is only set when a box is actually used.

IMC and IMC freerunning counters use a separate control path and are
unaffected.

Fixes: 772ed05f3c5c ("perf/x86/intel/uncore: Add Alder Lake support")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260602144908.263680-5-zide.chen@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snb.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -539,12 +539,6 @@ void tgl_uncore_cpu_init(void)
 	skl_uncore_msr_ops.init_box = rkl_uncore_msr_init_box;
 }
 
-static void adl_uncore_msr_init_box(struct intel_uncore_box *box)
-{
-	if (box->pmu->pmu_idx == 0)
-		wrmsrq(ADL_UNC_PERF_GLOBAL_CTL, SNB_UNC_GLOBAL_CTL_EN);
-}
-
 static void adl_uncore_msr_enable_box(struct intel_uncore_box *box)
 {
 	wrmsrq(ADL_UNC_PERF_GLOBAL_CTL, SNB_UNC_GLOBAL_CTL_EN);
@@ -563,7 +557,6 @@ static void adl_uncore_msr_exit_box(stru
 }
 
 static struct intel_uncore_ops adl_uncore_msr_ops = {
-	.init_box	= adl_uncore_msr_init_box,
 	.enable_box	= adl_uncore_msr_enable_box,
 	.disable_box	= adl_uncore_msr_disable_box,
 	.exit_box	= adl_uncore_msr_exit_box,


