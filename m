Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAB021ABC1;
	Tue, 29 Apr 2025 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949043; cv=none; b=pPpKQjQe3cGIaYD2FDAR24/nqWq/NO6Lfd43iyziALUW8A2yclEWjWvEUSvUkCvhBb5bJ4h2L5/UYmNCNcQ6qDjzr2wuy1ZMbIiidiJkTnAxuzWjQSFntwIxpl1e6CXP+ayQgbS90GwnxSc9nQDVoczqBxK12nYiIPQQ+mLzT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949043; c=relaxed/simple;
	bh=yMgQKaSrYb8FzpMnzuwbrxFQeq178GbJfmQHydQ+Iak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDdsgWdIIUJ70tiqZ4rtDIzFEUgz8NMNwJjkM4cxiHM/uS/3Z3EPL0wSGEefwEKQXopfiLwTz/2cqTzJ3ML/ZniCu2eUsAyIedKscyCe4C3PqIhbmd44OuyQq9kYjyKJm72IDqQp/IdLbhxwEeNHcNtaZylkJXcidgqVQ/XFT9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tr/znvxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tr/znvxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F54FC4CEE3;
	Tue, 29 Apr 2025 17:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949042;
	bh=yMgQKaSrYb8FzpMnzuwbrxFQeq178GbJfmQHydQ+Iak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tr/znvxVl230keYMSFpdZCDLXHikjLBSopgBtqh/Ale6yv70gZu/j9uGvQhKLWEbA
	 OadP4YfkMq5vSR7VnIX6mEA3AlDaD+Xh12sJOUaJs4mJrRrW4M2inpWRIyYhk6SGys
	 DEd2fXIPjEGHtmHArJg+gXHrknnK1iv3UeG40qmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.15 197/373] cpufreq: Reference count policy in cpufreq_update_limits()
Date: Tue, 29 Apr 2025 18:41:14 +0200
Message-ID: <20250429161131.273760607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 9e4e249018d208678888bdf22f6b652728106528 upstream.

Since acpi_processor_notify() can be called before registering a cpufreq
driver or even in cases when a cpufreq driver is not registered at all,
cpufreq_update_limits() needs to check if a cpufreq driver is present
and prevent it from being unregistered.

For this purpose, make it call cpufreq_cpu_get() to obtain a cpufreq
policy pointer for the given CPU and reference count the corresponding
policy object, if present.

Fixes: 5a25e3f7cc53 ("cpufreq: intel_pstate: Driver-specific handling of _PPC updates")
Closes: https://lore.kernel.org/linux-acpi/Z-ShAR59cTow0KcR@mail-itl
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/1928789.tdWV9SEqCh@rjwysocki.net
[do not use __free(cpufreq_cpu_put) in a backport]
Signed-off-by: Marek Marczykowski-GÃ³recki <marmarek@invisiblethingslab.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2654,10 +2654,18 @@ EXPORT_SYMBOL(cpufreq_update_policy);
  */
 void cpufreq_update_limits(unsigned int cpu)
 {
+	struct cpufreq_policy *policy;
+
+	policy = cpufreq_cpu_get(cpu);
+	if (!policy)
+		return;
+
 	if (cpufreq_driver->update_limits)
 		cpufreq_driver->update_limits(cpu);
 	else
 		cpufreq_update_policy(cpu);
+
+	cpufreq_cpu_put(policy);
 }
 EXPORT_SYMBOL_GPL(cpufreq_update_limits);
 


