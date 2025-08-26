Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D88284678;
	Tue, 26 Aug 2025 13:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214139; cv=none; b=rHh9jCNwDg7NLlqp6XyqRwyTKBqkiJXjqrx2k/JyXF0gH+QPxzi+LO8rrBswd66PvfkOtJTFRnbRsCIz36Me9k7U9rchlHSHClBKle0ORDM9dGABeNgsTdIyQ/eL1G/CIdVOM55Flago7TAXvlT4uZOQD4TDHuV/qlGstjio7YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214139; c=relaxed/simple;
	bh=GVlf6s5esLRcE4P+ATAmht9anVgF7DgSO9KkUYCSaK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pl2StObofAjBmPJRsy/8e3pfNvFwaYd64Guv6hoIVJf9IllOk/gJsyzSrESY/oL+9grRvM0Z4z2wZGz/cvezuZhEmlbvROBY7nG/0Km71ICGz+Pet5rKbp65IT1bIZVSL/0pyBLKPLGrIZnGWpBQ3fwNznRFFOWbvvrLGiEap0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W7nPkwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W7nPkwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B8EC4CEF1;
	Tue, 26 Aug 2025 13:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214139;
	bh=GVlf6s5esLRcE4P+ATAmht9anVgF7DgSO9KkUYCSaK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W7nPkwY9EXpOdroRfoNsME3MMEFlAJaE8/P7+UfRStFQIS3xxcg3Y1At3tJ91yXI
	 zC/FGCmlglpU3raBEQ4NryO1o8WAn5+lROnBzKVKC9L+o/xav//VdatpGnImWIxcgw
	 GSUUDgZV2kpodgC2FRF78jzc4HJW24j7axsfgN8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 026/482] ACPI: processor: perflib: Move problematic pr->performance check
Date: Tue, 26 Aug 2025 13:04:39 +0200
Message-ID: <20250826110931.444593025@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit d405ec23df13e6df599f5bd965a55d13420366b8 upstream.

Commit d33bd88ac0eb ("ACPI: processor: perflib: Fix initial _PPC limit
application") added a pr->performance check that prevents the frequency
QoS request from being added when the given processor has no performance
object.  Unfortunately, this causes a WARN() in freq_qos_remove_request()
to trigger on an attempt to take the given CPU offline later because the
frequency QoS object has not been added for it due to the missing
performance object.

Address this by moving the pr->performance check before calling
acpi_processor_get_platform_limit() so it only prevents a limit from
being set for the CPU if the performance object is not present.  This
way, the frequency QoS request is added as it was before the above
commit and it is present all the time along with the CPU's cpufreq
policy regardless of whether or not the CPU is online.

Fixes: d33bd88ac0eb ("ACPI: processor: perflib: Fix initial _PPC limit application")
Tested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2801421.mvXUDI8C0e@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_perflib.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -180,7 +180,7 @@ void acpi_processor_ppc_init(struct cpuf
 		struct acpi_processor *pr = per_cpu(processors, cpu);
 		int ret;
 
-		if (!pr || !pr->performance)
+		if (!pr)
 			continue;
 
 		/*
@@ -197,6 +197,9 @@ void acpi_processor_ppc_init(struct cpuf
 			pr_err("Failed to add freq constraint for CPU%d (%d)\n",
 			       cpu, ret);
 
+		if (!pr->performance)
+			continue;
+
 		ret = acpi_processor_get_platform_limit(pr);
 		if (ret)
 			pr_err("Failed to update freq constraint for CPU%d (%d)\n",


