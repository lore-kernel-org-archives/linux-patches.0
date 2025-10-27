Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8C431B83D;
	Mon, 27 Oct 2025 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591284; cv=none; b=BU07G9pqlZSumYBoe28HPBUf3vEukLnLytoithr3gwxwAkfazHo0n6z6vYDMyuZiZkWZsLEGryfCeUZDOfWp95ZZG06jcadCmZp0KFcYkyUdbZ4HDgg5k9KATsLmeX1CiyKa+yNuf1VdvfrJ0EO9pAZ1Hjgof5dDbnHeUebd2vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591284; c=relaxed/simple;
	bh=N1LMQB45h4pO+pfGnV/jOGpDDzwwRkrzVmp4i16dseY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+myvebPFzjbwXg6dHczUngSIUUUBXb3ewrurM/PKk2K9mYpWgCuniM91DJq9rxpVUjVGcwxd9hDg9Dkk7U43L53P3KIAVdCFaW9mIA+jyStWoXg9kh0AKJQJqN/K9F/Ucp7yLgrTRxEUuyDipKmYG37kaa4M/ZZ0cs8BvjG2hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYA5rQ0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYA5rQ0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71490C4CEF1;
	Mon, 27 Oct 2025 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591283;
	bh=N1LMQB45h4pO+pfGnV/jOGpDDzwwRkrzVmp4i16dseY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYA5rQ0LLWMlQaStgoHMCzIcqmbgxTxRSYoKMp/CVI/SILyjGweqxztsdkOFBnlyx
	 +fkR+8TPY9OGZJeapaOAtKh2C/0n+iHM6cM8ywiusKwLB30CrhjstNxBcQ7aksEW6c
	 CSSjzNd96zCtTgzFs4B9nhgDvCKXPtssPDsD4nJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [PATCH 5.10 137/332] cpufreq: intel_pstate: Fix object lifecycle issue in update_qos_request()
Date: Mon, 27 Oct 2025 19:33:10 +0100
Message-ID: <20251027183528.251906562@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
@@ -1205,10 +1205,10 @@ static void update_qos_request(enum freq
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
 			intel_pstate_get_hwp_max(cpu, &turbo_max, &max_state);
@@ -1227,6 +1227,8 @@ static void update_qos_request(enum freq
 
 		if (freq_qos_update_request(req, freq) < 0)
 			pr_warn("Failed to update freq constraint: CPU%d\n", i);
+
+		cpufreq_cpu_put(policy);
 	}
 }
 


