Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12723F23AA;
	Tue, 17 Mar 2026 16:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766308; cv=none; b=lhgE6/43pFdv/xsx0tBHFbEpPtSmMbqwg4vYQ5jii6p3qSpK+SCL8ryPy1/FVFyIO0il3QEinuPTsqE4xWiYaXp01GR+H6QEoH4LzOLrikD5dJ6UcpGWDfWABFKpGz4ZnRlgs3vNTD9u5AHac2VX3Dzbpucxc7wDOkA5irM65qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766308; c=relaxed/simple;
	bh=U/3okOuG1AAMNSvUwCRpbIXf6G7h6jRyCBatoCiV1Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0xdg8591RDYcyE3+0/kp77irY6bIJmor099CxbilJ7E7Rvh+FCuxhNXDHyueceAgyVneLOikha4su/oUI3bnU1MIVhXGIT+Qpy6q9ovYuPrxiSZWTB691VEo7uMYUA4d0onJSCJRr6Yomv+YCKgocKqOSzBMNj9DJvBtZoba6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlGj8jr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlGj8jr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8AEC4CEF7;
	Tue, 17 Mar 2026 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766307;
	bh=U/3okOuG1AAMNSvUwCRpbIXf6G7h6jRyCBatoCiV1Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlGj8jr3pb65MZqB8fT1/EfWJk7uBU8LcgGT3hgI/chOkTlLo1a1yx42piLRh4/bR
	 UPf/ydkfZ2+pv1Bq+oyxneDiST7ZZlHrscVLQM/KFj8BqJl83frsqtVynK7PBQcoeN
	 pldhNlhyplCYcOLhqNpIuzsw+z04ZBJ6OKqpZWLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jirka Hladky <jhladky@redhat.com>,
	David Arcari <darcari@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.19 216/378] cpufreq: intel_pstate: Fix NULL pointer dereference in update_cpu_qos_request()
Date: Tue, 17 Mar 2026 17:32:53 +0100
Message-ID: <20260317163014.957376626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arcari <darcari@redhat.com>

commit ab39cc4cb8ceecdc2b61747433e7237f1ac2b789 upstream.

The update_cpu_qos_request() function attempts to initialize the 'freq'
variable by dereferencing 'cpudata' before verifying if the 'policy'
is valid.

This issue occurs on systems booted with the "nosmt" parameter, where
all_cpu_data[cpu] is NULL for the SMT sibling threads. As a result,
any call to update_qos_requests() will result in a NULL pointer
dereference as the code will attempt to access pstate.turbo_freq using
the NULL cpudata pointer.

Also, pstate.turbo_freq may be updated by intel_pstate_get_hwp_cap()
after initializing the 'freq' variable, so it is better to defer the
'freq' until intel_pstate_get_hwp_cap() has been called.

Fix this by deferring the 'freq' assignment until after the policy and
driver_data have been validated.

Fixes: ae1bdd23b99f ("cpufreq: intel_pstate: Adjust frequency percentage computations")
Reported-by: Jirka Hladky <jhladky@redhat.com>
Closes: https://lore.kernel.org/all/CAE4VaGDfiPvz3AzrwrwM4kWB3SCkMci25nPO8W1JmTBd=xHzZg@mail.gmail.com/
Signed-off-by: David Arcari <darcari@redhat.com>
Cc: 6.18+ <stable@vger.kernel.org> # 6.18+
[ rjw: Added one paragraph to the changelog ]
Link: https://patch.msgid.link/20260224122106.228116-1-darcari@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1647,8 +1647,8 @@ static ssize_t store_no_turbo(struct kob
 static void update_cpu_qos_request(int cpu, enum freq_qos_req_type type)
 {
 	struct cpudata *cpudata = all_cpu_data[cpu];
-	unsigned int freq = cpudata->pstate.turbo_freq;
 	struct freq_qos_request *req;
+	unsigned int freq;
 
 	struct cpufreq_policy *policy __free(put_cpufreq_policy) = cpufreq_cpu_get(cpu);
 	if (!policy)
@@ -1661,6 +1661,8 @@ static void update_cpu_qos_request(int c
 	if (hwp_active)
 		intel_pstate_get_hwp_cap(cpudata);
 
+	freq = cpudata->pstate.turbo_freq;
+
 	if (type == FREQ_QOS_MIN) {
 		freq = DIV_ROUND_UP(freq * global.min_perf_pct, 100);
 	} else {


