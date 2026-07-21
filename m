Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E6B446839;
	Tue, 21 Jul 2026 19:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663707; cv=none; b=N8fonqRWUkabkNksrGfbjcy1s8CgseVNoxThwhdOSORCg6s4E6lXennMknQREFh2aBJg9J/ESUc8WPiuxiqxE+ctq7vIiOxaJiPlGQZxT/l9xud9ZMIlecrYJmbLwfXGSgVXEGseVWrouwjrD1lIRXkb/ZkUQVAlXi9nlrXHLP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663707; c=relaxed/simple;
	bh=6Qh1D/BK3waEj16bzn5N1qgdsUWm0p1umfh3Ht8XJ6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEJT14nH2OxIk6F087HcT/MjjIoZ+RYsPRIWS3ZhhDoy0sby9TJx+VMqNeTB12AxcGwBwVw/8mxmFIDHMluI63/oaW3h90NjRL+iS2xe9BSMV4mhCRFETLwtQsNoLHe9suzZ4I/ezdA4F8VjCC+ysO+P9RcM9bYmBix0ax1oxiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuHy3XIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuHy3XIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DCF1F000E9;
	Tue, 21 Jul 2026 19:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663705;
	bh=CsdmFEFkSEqce6q14QTe5Mdih3GA8tSTV3E+5S8MLOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuHy3XIr+bUq8grSrDmkcHwCJkPnNw89RzJ2SRlrXuLGRP0qoFLkSLGci54/VgN8r
	 56tz5FAaPQlSJy8bQ+wADhBJ/K21E5UkItwWDWdQphcc8fQeyTAk0Ps0qKaHwWhI6e
	 nvbQEwnwOeVkOr0OpxeGa1mhntNl5OzDO67mlexw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 6.12 0880/1276] cpufreq: intel_pstate: Set non-turbo capacity to HWP_GUARANTEED_PERF()
Date: Tue, 21 Jul 2026 17:22:03 +0200
Message-ID: <20260721152505.743732331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -964,12 +964,14 @@ static void hybrid_clear_cpu_capacity(un
 
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


