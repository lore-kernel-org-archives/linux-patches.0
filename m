Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B2739A7FD;
	Tue, 21 Jul 2026 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658570; cv=none; b=ioWXetgbolVjhlI5wABC8DPRCXyARFas0rLiSw8lJJPj22hxwmauyL4RM7DVk4aJD2PflOTXBKA3vM6ruLX5IObNCkt1WvAZLuIRhbVJZZSBwg+w0FaIquHC+U8E2LeSLpqUCxLKlhRGVUerZK2Xd4sTRcWRtngOErsJnVUpWSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658570; c=relaxed/simple;
	bh=exohFkUU87YZNe/Dr4Lu7PRR2iOJd7jXHCN7Tuf7LAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wbnnq9JEYHi7pz59SOQkWmyKpq9yFF81ewDCgFOWnb4jUqkqqdBjzaH2vrYxkLRwEjT/i7F2CtFE1ltUFVMI1rzxbVMyKIBFuPJkSNLh6WuT7n60Pu7VpuZkdwA9gTj9Aiv7zgJbDfDa2w6NXT+YSVQbS1T+QdFsB71MWabCOj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hpei4T2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hpei4T2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7762A1F000E9;
	Tue, 21 Jul 2026 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658569;
	bh=mrcvus04elYNNyD7/elgB7p+832YI/idCqdJgqlf1f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hpei4T2sjW5MLl7HE+NharCY89eiZZOOG4oa/YN4UkqZc0fVsshH3xKk+UURi3lZ7
	 3Tkv6OI1MN/+0Yr6xRvixCbCVRcWKS/P1Px6DETw2N6SQ26rYX1jPdlTfDj0JHBu0P
	 PfdRxwr9Cu6fPS0b2cQXWUuESrNaitG4hrsLQ1bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: [PATCH 6.18 1192/1611] cpufreq: intel_pstate: Set non-turbo capacity to HWP_GUARANTEED_PERF()
Date: Tue, 21 Jul 2026 17:21:48 +0200
Message-ID: <20260721152542.244442756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1054,12 +1054,14 @@ static void hybrid_clear_cpu_capacity(un
 
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


