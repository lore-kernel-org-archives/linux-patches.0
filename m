Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3C728E5F3;
	Wed, 23 Apr 2025 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421121; cv=none; b=oCUXY66dmw8ISoISgTqa5jcX/p0eoVeg0IveyGTYKCRZtcJEI+d8WJSfKMqQnaEPx6EL6XXNEc4+Rs8WxQKjetM6/wjUn8qmD39Dhy+J59FZPDSmoPywNuQtllbL2fqlO8qq8ubMIg9IjKIsTNgwsdAxMkqs1hF0p6PJvuv/D4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421121; c=relaxed/simple;
	bh=aBw8AqXvBCCNPFSw6frKNEJzw4gFK2Kny02ZnTqY+tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=faserYqpz1dEi6P75joNdsS4uAHMBRPu+ANOpr7fXPukvyvmUyRBoMDpJRxFPvrc6dVde2yQJ1CGzGW+ueoBWFEdO0zYycMSE6fSNZKm5XMqPErOWA4xF1wjL0lCWBs1AZdzuIzJcTSeGaVX1ceJxhWLdDCuUgo0uBbR123mxMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnWQJ8MF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnWQJ8MF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B9EC4CEE2;
	Wed, 23 Apr 2025 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421120;
	bh=aBw8AqXvBCCNPFSw6frKNEJzw4gFK2Kny02ZnTqY+tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnWQJ8MFm0+sFQadrijJS1S6rPNX5OjI+rucvTpnVxyiZZ4C0vzfLrz6LP1y0A+0Q
	 lRpATentQRvjgGvB88oq8tzkp900HlUkxg60mul/YyxqO2FTZnaU7vt/C/BavuW/yj
	 b0XpzzDSZIHZAkackACxFDkIp5YK9Q9yHsA5R8Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.12 193/223] cpufreq: Reference count policy in cpufreq_update_limits()
Date: Wed, 23 Apr 2025 16:44:25 +0200
Message-ID: <20250423142625.038024343@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2766,10 +2766,18 @@ EXPORT_SYMBOL(cpufreq_update_policy);
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
 


