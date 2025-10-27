Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB5531D740;
	Mon, 27 Oct 2025 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590680; cv=none; b=kCw/msG0lc8hi5fzvN4QfkAvoWryVurqvt4haYg1W2pkigOBeNJ/pv4UoL5AjS5xcKuBWUI/y9evgMnk8z+M39y+jS8bZDgbUkHwnC6jnxh90zfEDPDZMit5xW+5q2T5dnXQ+3i7RMYk4cs94si2bw0YMh4+on77HPMYdkmpwwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590680; c=relaxed/simple;
	bh=/7GrzHvADDJVroCfk5iovlLC6osLgbAQRV7NZpQKnpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux/fo3FMaA/wIY9iEIHvW5zhKfEOPqAnyWbAZwUWxcDx8LP7EvewU31B9OA4xrcqdSXeuDbYpuIny1Aboid99Nbks1y6+NAGXpzTyk2QVu646SfCIBl8u+8/UczD+HK7nxWooFqMeaBfrnkspfAD1gVOwMEU45Mi7WMsFySIAsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfTGC69W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfTGC69W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7773FC4CEFD;
	Mon, 27 Oct 2025 18:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590679;
	bh=/7GrzHvADDJVroCfk5iovlLC6osLgbAQRV7NZpQKnpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfTGC69W7Cc6pzXmsxQVoZR3slGo4jDIj+9BSY/o/RI40vYN7Xh325ss+sikJA5+t
	 pMhEAWKVAr6iy1aF6c3ivzx4R9yWdcdSLEb9wQwFDV/K4t0ouYJcV7HP9EUYbxwRcV
	 Ybq2sGb/78aelYGDKyh1QtNjnKgNq+aYRCwQcSyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [PATCH 5.4 107/224] cpufreq: intel_pstate: Fix object lifecycle issue in update_qos_request()
Date: Mon, 27 Oct 2025 19:34:13 +0100
Message-ID: <20251027183511.859499741@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 69e5d50fcf4093fb3f9f41c4f931f12c2ca8c467 upstream.

The cpufreq_cpu_put() call in update_qos_request() takes place too early
because the latter subsequently calls freq_qos_update_request() that
indirectly accesses the policy object in question through the QoS request
object passed to it.

Fortunately, update_qos_request() is called under intel_pstate_driver_lock,
so this issue does not matter for changing the intel_pstate operation
mode, but it theoretically can cause a crash to occur on CPU device hot
removal (which currently can only happen in virt, but it is formally
supported nevertheless).

Address this issue by modifying update_qos_request() to drop the
reference to the policy later.

Fixes: da5c504c7aae ("cpufreq: intel_pstate: Implement QoS supported freq constraints")
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
Link: https://patch.msgid.link/2255671.irdbgypaU6@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -1092,10 +1092,10 @@ static void update_qos_request(enum freq
 			continue;
 
 		req = policy->driver_data;
-		cpufreq_cpu_put(policy);
-
-		if (!req)
+		if (!req) {
+			cpufreq_cpu_put(policy);
 			continue;
+		}
 
 		if (hwp_active)
 			intel_pstate_get_hwp_max(i, &turbo_max, &max_state);
@@ -1114,6 +1114,8 @@ static void update_qos_request(enum freq
 
 		if (freq_qos_update_request(req, freq) < 0)
 			pr_warn("Failed to update freq constraint: CPU%d\n", i);
+
+		cpufreq_cpu_put(policy);
 	}
 }
 


