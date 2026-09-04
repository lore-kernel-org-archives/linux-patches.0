Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B1B3A961E;
	Fri,  4 Sep 2026 05:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499107; cv=none; b=rk/YasqqJk6+c9PRoFMQ9/l6NGF4IBwsHHfWZpncRlr8k3IJSu4KIaUq42FAJula3KPxUpE7bTJ7SU26ZApU15TtzPGPSWAiLHsnzTZytt2lxwsQek80qS9QGa37Lhh9hJnmXyVxtiZ2NUw+aR/VlEmJ8M3FzeROxF9cIM4y3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499107; c=relaxed/simple;
	bh=UfrriiOg8D5Qc8i8bRrPpi6ReuAdvWZqB7rsJd3a9XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asGS70WayNAiUbi2tQTcHyUWu68uLF+38YQl+3FGcPiAJmF3N+nK880MK8+lPz2dFlJ+EtYKOZyGJ6difD+xqYh3MTI2O+HQgMltIwnoKCcHBYQj1/l/THZB7G3TwqUWUJJEaP0CE8uQ/ymuNXMadROV0azRRzh33zRZy2Yhkqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXsFZrxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXsFZrxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB12C1F00A3D;
	Fri,  4 Sep 2026 05:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499106;
	bh=OyRudWusW1J+uFkDh1+UeL1y7xPt3Smtq6NGr/iVPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXsFZrxhFNE8+x/wJomZuwlHZDGPRQYdjkTDafrjSKF3y42CwQvWrZthpPuHBrrvR
	 dm/ZC/IyrWIvB/ikSBh9IIM6oMYl0iqTHoZiWt1If+dqcJGEfx1G33P7NFHgoFgObA
	 Yt//WRyxKinEn6NWF/NjphQMjEM34f9Txi4XsxS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.2 299/713] ACPI: CPPC: Reject desired_perf reads on _CPC revision 4+
Date: Fri,  4 Sep 2026 06:54:27 +0200
Message-ID: <20260904045810.543844164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit df5a1d4a8cdfda20eb2581a85e81c7d436866534 upstream.

When CPPC feedback counters cannot provide a usable sample, cppc-cpufreq
calls cppc_get_desired_perf() because some platforms repurpose Desired
Performance to report actual delivered performance.

ACPI 6.5 defines _CPC revision 3 and lists Read/Write as the Optional
Attribute of Desired Performance. ACPI 6.6 advances _CPC to revision 4 and
lists only Write, so invoking that workaround for revision 4 or later would
require a register read that the interface no longer specifies.

Make cppc_get_desired_perf() return -EOPNOTSUPP for _CPC revision 4 or
later. Use the revision retained in the per-CPU CPC descriptor rather than
the platform-wide FADT revision.

The _CPC revision may still not accurately describe the implemented
register semantics. If a nominally revision 3 platform implements a
non-readable Desired Performance register, a read may return zero and make
cppc_cpufreq_get_rate() report 0 kHz. Treat a zero read as unusable and
fall back to the cached OSPM request, just as for a failed read.

Fixes: c47195631960 ("cppc_cpufreq: Use desired perf if feedback ctrs are 0 or unchanged")
Cc: stable@vger.kernel.org
Suggested-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260803203531.1268651-2-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c       |   17 ++++++++++++++++-
 drivers/cpufreq/cppc_cpufreq.c |    2 +-
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1316,15 +1316,30 @@ static int cppc_set_reg_val(int cpu, enu
 	return cpc_write(cpu, reg, val);
 }
 
+static bool cppc_desired_perf_readable(const struct cpc_desc *cpc_desc)
+{
+	return cpc_desc->version < CPPC_V4_REV;
+}
+
 /**
  * cppc_get_desired_perf - Get the desired performance register value.
  * @cpunum: CPU from which to get desired performance.
  * @desired_perf: Return address.
  *
- * Return: 0 for success, -EIO otherwise.
+ * Return: 0 for success, -EOPNOTSUPP for _CPC revision 4 or later, and a
+ * negative errno otherwise.
  */
 int cppc_get_desired_perf(int cpunum, u64 *desired_perf)
 {
+	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpunum);
+
+	if (!cpc_desc)
+		return -ENODEV;
+
+	/* _CPC revision 4 no longer specifies Desired Performance as readable. */
+	if (!cppc_desired_perf_readable(cpc_desc))
+		return -EOPNOTSUPP;
+
 	return cppc_get_reg_val(cpunum, DESIRED_PERF, desired_perf);
 }
 EXPORT_SYMBOL_GPL(cppc_get_desired_perf);
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -836,7 +836,7 @@ out_invalid_counters:
 	 * value first as some platforms may update the actual delivered perf
 	 * there; if failed, resort to the cached desired perf.
 	 */
-	if (cppc_get_desired_perf(cpu, &delivered_perf))
+	if (cppc_get_desired_perf(cpu, &delivered_perf) || !delivered_perf)
 		delivered_perf = cpu_data->perf_ctrls.desired_perf;
 
 	return cppc_perf_to_khz(&cpu_data->perf_caps, delivered_perf);


