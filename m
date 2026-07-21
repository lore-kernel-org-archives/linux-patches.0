Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856CA46D2C7;
	Tue, 21 Jul 2026 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654257; cv=none; b=CHDDuFEix2pOsalt60KW1wzYVXTSXQvp0P8qcSroTPSdhBamXYy/o9l+uTn7q81fMQEYTHkSRw58YLVUCVzVWUXjVU0l6BAr9MTcPcJoe/MoGkNAEQuanDVIjgNlDBIFIAe4lcd0Rb2FooXLLuprjuL9PIhbuktWIbn3g0qw/Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654257; c=relaxed/simple;
	bh=uloBPu2u0hXbGxPPcReCU56yfASDCz+WbBsBtyUv50I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THyMfrrNaCuiDJrJHKSbZ8PyScA9LMzE669S/ywTnJ/yB2cAGC3gkL3TMMAjjhinYst5A6TxvdXEH0DKFalzoS+24ZKwLQNVLHVNgKR04NSJ1sv1XpKBed0jybMoLtWRbFN6I6o6MNQ/KZs3ouXmxGoT7O5qwFdlHDIiGLHr7no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVvLRVYh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVvLRVYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23BE1F000E9;
	Tue, 21 Jul 2026 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654256;
	bh=dZmhelLUnp6cS0aGzhNvAnqERY0jlhz2+WUYEkvYKmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVvLRVYhf/MjUDikPpDw/RcqJoyLCPBC2UFnJPl9wv9Lngv8oY/elZ5e7oAW+Zufx
	 Nvb8siZO5HGB3Z9/mR0oTGrL1asuT+NdtOg9pBzhWP1uJEWqMyUNDuW61+xlHtEH3X
	 nYgSfOJ4270ovMqAs5DQ0qE962L2XDtZ3Xd+mXWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 7.1 1636/2077] cpufreq: intel_pstate: Set non-turbo capacity to HWP_GUARANTEED_PERF()
Date: Tue, 21 Jul 2026 17:21:49 +0200
Message-ID: <20260721152631.338303544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 27d80e0f8b8dff97503fc0061754b1d3800cb961 upstream.

Setting cpu->capacity_perf to cpu->pstate.max_pstate_physical in the
"no turbo" case is inconsistent with what happens elsewhere in the
driver and causes arch_scale_cpu_capacity() to be incorrect.  It also
skews arch_scale_freq_capacity() which ends up differing from 1024 for
the guaranteed P-state.

Address that by setting capacity_perf to HWP_GUARANTEED_PERF() in the
"no turbo" case.

Fixes: 929ebc93ccaa ("cpufreq: intel_pstate: Set asymmetric CPU capacity on hybrid systems")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/12928972.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1058,12 +1058,14 @@ static void hybrid_clear_cpu_capacity(un
 
 static void hybrid_get_capacity_perf(struct cpudata *cpu)
 {
+	u64 hwp_cap = READ_ONCE(cpu->hwp_cap_cached);
+
 	if (READ_ONCE(global.no_turbo)) {
-		cpu->capacity_perf = cpu->pstate.max_pstate_physical;
+		cpu->capacity_perf = HWP_GUARANTEED_PERF(hwp_cap);
 		return;
 	}
 
-	cpu->capacity_perf = HWP_HIGHEST_PERF(READ_ONCE(cpu->hwp_cap_cached));
+	cpu->capacity_perf = HWP_HIGHEST_PERF(hwp_cap);
 }
 
 static void hybrid_set_capacity_of_cpus(void)


