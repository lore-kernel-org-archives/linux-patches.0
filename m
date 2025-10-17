Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01069330B1E;
	Fri, 17 Oct 2025 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716423; cv=none; b=sqNwW02nSrWjApvuA0apsJeY6XLlHBn1SAtlvu7E6UlA+aLBnd/1XuQVjU5Hx9j9C77qVL5jZ02U+ehMp7aJykrYCq5WFjEGFdZAAt5NSFj95HNbb+6fFZ6Wds5jTfQ+zN6GTwHpbZP6aHi6NHawa/NJaiNCVY3HnF4PAQm8c0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716423; c=relaxed/simple;
	bh=k563CMuYSM/A0GodW9u8VvWAFpHI6rZmmZuwinTZXKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syz7cNCDXgUxc5r2LGzGgIpoB0y7lnI+QH7oNjpAZQ2lLhZrQAu1Z9zXS66NevpbpIGFbLQ+25SjTdH0xwF2OzA/I7ovgFJNvUrbTQaZHp6lLVqCsd+j4hZpU5WOWMqthOoTjN99nmhKBoGf0SIsfD5wmZFjMLbOypnB4OvHfIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9h+zVMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9h+zVMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACD7C4CEE7;
	Fri, 17 Oct 2025 15:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716422;
	bh=k563CMuYSM/A0GodW9u8VvWAFpHI6rZmmZuwinTZXKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9h+zVMAUjAlM2eQbzXBN8yzk3G4bBwrTd31Hof/7hO9jziMVc5Ys+rCaAOQhggyN
	 RLQJYsANaoO2GwEEUkdBgCaeX3+vJJYB+lDGVmgFCplNB7mCZ11D9OPElo/fcNXG9E
	 uU0IjX5D/cAICpKD4gFnSuJYQ5FM0PoLN/W71YU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [PATCH 5.15 178/276] cpufreq: intel_pstate: Fix object lifecycle issue in update_qos_request()
Date: Fri, 17 Oct 2025 16:54:31 +0200
Message-ID: <20251017145148.974165070@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1307,10 +1307,10 @@ static void update_qos_request(enum freq
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
@@ -1326,6 +1326,8 @@ static void update_qos_request(enum freq
 
 		if (freq_qos_update_request(req, freq) < 0)
 			pr_warn("Failed to update freq constraint: CPU%d\n", i);
+
+		cpufreq_cpu_put(policy);
 	}
 }
 


