Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD9533710B;
	Fri, 17 Oct 2025 15:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713784; cv=none; b=RkJ2n8vtR3QGMa9IKG2xubp5jHRC10RRrq28zn4OBS8EF83aXrM7U4hqM+cxoFJbo1mZYkGPUfm/bQQoL855OA7Ut0Mp563iZc2ldGhDu1Q3nalEDl2vvYitRCnrSheTG8gaZij6Sank/CtfpVwOirtHa4wDu8ByERJ3jAYZJ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713784; c=relaxed/simple;
	bh=5kFpIzrHfJwSGVCn8pMoqqufQn1zu1A/9cf4NPs8i7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDJceRuuXQbZkG8iuJm59srpZMhEgOPJtX/jSoTD3Svv4/9uHvNeNPIE6gPTtVeMN0JlhjWDUDZoUi6mfDIwxek/JoWkSn428J1Ys4q1/XyQ4Hi9CzQhDYRJHjmppfny+AaRW1Y3AUbBNHTTcIVdh0/TytNp9CSwRlMza6492Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0R2RNuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0R2RNuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62125C4CEE7;
	Fri, 17 Oct 2025 15:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713783;
	bh=5kFpIzrHfJwSGVCn8pMoqqufQn1zu1A/9cf4NPs8i7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0R2RNuvkQ3FFHmY8lTjw35ngIz3X1nDNg4O+EyoQUP25Te8y+9ZAx841Qy39Q1ww
	 +4OqQzsju0GkCmDozlh2Ngsls6mE3umlEqr1FZyMkhO3kGoOUpUe6jL6f7JV7y5gIy
	 iAGbpN1P0L0XNd4Rwsjk/z/rqYvl7QRGw4JLjtBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [PATCH 6.6 085/201] cpufreq: intel_pstate: Fix object lifecycle issue in update_qos_request()
Date: Fri, 17 Oct 2025 16:52:26 +0200
Message-ID: <20251017145137.877950081@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1341,10 +1341,10 @@ static void update_qos_request(enum freq
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
 			intel_pstate_get_hwp_cap(cpu);
@@ -1360,6 +1360,8 @@ static void update_qos_request(enum freq
 
 		if (freq_qos_update_request(req, freq) < 0)
 			pr_warn("Failed to update freq constraint: CPU%d\n", i);
+
+		cpufreq_cpu_put(policy);
 	}
 }
 


