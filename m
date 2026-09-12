Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68684757EA;
	Sat, 12 Sep 2026 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242289; cv=none; b=lQtlRIulUpHn33rn+KbJJQRQGPb4fk3TF7GMXdlXwj6SctsJfqCzO6KpCPpM/8S7jv3vGzSHndYEHfSKcpefUrLQKsrB7PUhD2Dq6SKDuMaxWDETz8KjCveasEVoDkiBqHkWVjlOL0TUR+eIKfsbtweEGjPkd4rMu8a1ziyS0Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242289; c=relaxed/simple;
	bh=iGYQ9l/d0eUzRM6+42tJaOVcDwZ0N8EH0tf6SNbVG7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJnO//WhSjsNh9aBsIbCgDV6S/2sq2RoqUn5r0WcJrPgYNgDP6LFW4uQwhjWWbMB506u6csVJHRX544htRvhffq5w9hJwCX8DSnSqSAJ16nT6zNGazXnpGgRqjfd0DkJnEpYriu0/4j4Tn/ZlXk3Bv6r4Zovq4SgAGlAe7xM5iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzyXImZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzyXImZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69611F000FF;
	Sat, 12 Sep 2026 19:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242288;
	bh=rDEgPIP30RlI0WuYNJO1Ld5Qv6cMS+RpJsVM6XXtDlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzyXImZwxSU4kwiGTqFcRSDgNmMZNfa7jK4cVOMSiQz/0DmUoqsTh6cgJvSsqqfF8
	 i0aEcTLITLpvQxhG/E04VFnaGwBKLYObocexDioOyfvdvQW7jdwFxyTmBaZzi5XJPi
	 UDCoomsxHAbpbn880/uCeOeccrZ7bkRpX+3CdkzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/798] perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails
Date: Sat, 12 Sep 2026 08:59:40 +0200
Message-ID: <20260912065525.230835012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 3012af7df3430788eddd30b3c6654d0a0a5f06c6 ]

uncore_event_cpu_online() returns -ENOMEM early when both the MSR and
MMIO box allocations fail.  This also aborts PCI uncore setup, even
though PCI PMUs are independent of the MSR/MMIO paths.

Remove the early return so PCI uncore setup always runs regardless
of whether MSR or MMIO box allocation succeeds.

Fixes: 3da04b8a00dd ("perf/x86/intel/uncore: Support MMIO type uncore blocks")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260611160033.66760-5-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 80d52cbe2fde5..d3cf65a859151 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1467,8 +1467,6 @@ static int uncore_event_cpu_online(unsigned int cpu)
 	die = topology_logical_die_id(cpu);
 	msr_ret = uncore_box_ref(uncore_msr_uncores, die, cpu);
 	mmio_ret = uncore_box_ref(uncore_mmio_uncores, die, cpu);
-	if (msr_ret && mmio_ret)
-		return -ENOMEM;
 
 	/*
 	 * Check if there is an online cpu in the package
-- 
2.53.0



