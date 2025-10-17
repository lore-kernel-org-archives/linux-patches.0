Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30245339717;
	Fri, 17 Oct 2025 15:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715407; cv=none; b=YX2sb//YGwKOzCLEoT383kwGGIAeuEBjrAIHX5vxbUqW1G0XXUofZuE9k5TmOIiEgruozjggCpb8YlrVM5qVEapGwT9yH8WJK71FfBSI1o9KOWVcHWy2GHw8jDPgM+gLc+fsJ2nvdGoSb3eusDCk5iF6FvZ9mDTdfMFJvZfuMH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715407; c=relaxed/simple;
	bh=8w6DjhsfDrc9tgYKKDym2U6zAu/ee7/anxzR7lHwhRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t89asaUwrnVxkJqbFKHS7jizBfuBseA+N3MEUR1bK1lSvPRsUKEg7WWj9r0i0OZbUdO3Xooi45FdGcPhJ8SRWR6wLUp4fkfBLLpI5ujf6Rbukmt7MGhd2FInFM8og1RYCgwkJLHLtQJ2FzaCvL7ghl8mfveFfUq1i10nVzIXqtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBM4EtAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBM4EtAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E9BC4CEE7;
	Fri, 17 Oct 2025 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715407;
	bh=8w6DjhsfDrc9tgYKKDym2U6zAu/ee7/anxzR7lHwhRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBM4EtAqw1RW0BYQZEO3USrFJ/o+tsHVkIko4BiKnK6sM+V7rLDYRZb201w6m2mpE
	 ojxaVOb75SsMpX2fjPquxG33XnBJ8fkJmWHf7ffIg9o9gXo8LdyJ3A4OaSzXZ/0ng0
	 fxcbJdaBoNx2HtGRi5aqnrICJWDzTIHhlRNsM33M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [PATCH 6.17 206/371] cpufreq: intel_pstate: Fix object lifecycle issue in update_qos_request()
Date: Fri, 17 Oct 2025 16:53:01 +0200
Message-ID: <20251017145209.543335182@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1710,10 +1710,10 @@ static void update_qos_request(enum freq
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
@@ -1729,6 +1729,8 @@ static void update_qos_request(enum freq
 
 		if (freq_qos_update_request(req, freq) < 0)
 			pr_warn("Failed to update freq constraint: CPU%d\n", i);
+
+		cpufreq_cpu_put(policy);
 	}
 }
 


