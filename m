Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F195A338936;
	Thu, 28 May 2026 19:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998305; cv=none; b=j+KAQnvrdOap3waeVsUCe6BHWprazDSbTI6CiIZ035FwYzm83XdDo+vpU6LR2uIuzVpXhrf8MEec3OXp9XjfoA/ieNKFKFWwg1kWiLMsm/s8dvNDf0SRb+qsAEf7qgJbNKQTyfz6JtBH8iEQwMwy6M5UeUg8CqspK76eSnenjHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998305; c=relaxed/simple;
	bh=AdGkPFnwullxNYUh6sDEHosjGwGJsvUxIXpOV5ZwVeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZYJ3Lnom70+BCH5XG2yKrQD+9QOI4ryRw88h9FEPajxTw8YweraWr7iK0b9PQ1ATHh9JNiyuezxfNjNIkrRWaYmOdV7UNwEcHfMtRvmVY1zcS0iC87EC3ycNnwTntG7yUMkc1jVlwSMfe7L0u1QzSdr8dl3qVt3+LMk0Al8SMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VUSBy92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VUSBy92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB21F000E9;
	Thu, 28 May 2026 19:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998304;
	bh=3BRLXEL8gs5krS1+RsYLG19AHl0fUXKUIvLLCfW7i14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VUSBy92lgjXNoDIVL9PsnkN6h8Yw5R7sSPilpISZ5eQfddQotpILG3S2IXvurD0D
	 m90OZDgwE+tBEY8Au6GiKlci7J+zw6JY5LakfMclsUeT0pCv/J88YbS3zA/iave0iJ
	 t6j2zjn6PiTnfzvmTXSRsz1MWdmQOPsl8hmtsqGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Tseng <henrytseng@qnap.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.0 127/461] cpufreq: intel_pstate: Use correct scaling factor on Raptor Lake-E
Date: Thu, 28 May 2026 21:44:16 +0200
Message-ID: <20260528194650.662211890@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 0e7c710478b3089cdfe8669347f77b163e836c4f upstream.

Raptor Lake-E has the same processor ID as Raptor Lake-S, so there is
an entry in intel_hybrid_scaling_factor[] for it.  It does not contain
E-cores though and hybrid_get_cpu_type() returns 0 for its P-cores, so
they get the default "core" scaling factor.  However, the original
Raptor Lake scaling factor for P-cores still needs to be used for
mapping the HWP performance levels of the P-cores in Raptor Lake-E to
frequency, as though they were part of a real hybrid system.

To address this, update hwp_get_cpu_scaling() to return
hybrid_scaling_factor, which is the P-core scaling factor
retrieved from intel_hybrid_scaling_factor[], for all CPUs
that are not enumerated as E-cores.

Fixes: 9b18d536b124 ("cpufreq: intel_pstate: Use CPPC to get scaling factors")
Link: https://lore.kernel.org/all/20260511235328.2018458-1-srinivas.pandruvada@linux.intel.com/
Reported-by: Henry Tseng <henrytseng@qnap.com>
Closes: https://lore.kernel.org/linux-pm/20260508063032.3248602-1-henrytseng@qnap.com/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/4523296.ejJDZkT8p0@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2279,7 +2279,7 @@ static int hwp_get_cpu_scaling(int cpu)
 		 * Return the hybrid scaling factor for P-cores and use the
 		 * default core scaling for E-cores.
 		 */
-		if (hybrid_get_cpu_type(cpu) == INTEL_CPU_TYPE_CORE)
+		if (hybrid_get_cpu_type(cpu) != INTEL_CPU_TYPE_ATOM)
 			return hybrid_scaling_factor;
 
 		return core_get_scaling();


