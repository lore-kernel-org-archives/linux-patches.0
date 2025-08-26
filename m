Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365EA34DCD2;
	Tue, 26 Aug 2025 14:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218874; cv=none; b=AG+j7YaT0RmjGom9wfMrn28RmQq9W9ThvlF0QDhu8nPnrik/dEHJX3Pw7czrj9J8B0DZbH8iT7uKnHH6Fo6vQ9TXUzs192T45F5aAaa5grau/00aM+wSaL4+RwHBau8pYgjVX7QCVxvsyMInrfFDtyZU06HlbjiGooaEYs5vjno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218874; c=relaxed/simple;
	bh=kBiADs6ypt3UL+HKpzOh8oEdD76p4qT2RdMzZwsktvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDWjZ0FGIEghKBZGGUvCDaNYAoCfh3kac3YUafE0s3BEh0kIlPrvSGEl2Un3WI2in5Ye8IFPwaOSGp4CZjcxcVlTahvKvABw5K5Y2z5n1oHhOPvhh8fA1p2ovTZl1ntElQ/4cjIz494nFI/mlOwQEv69Il1mydUBz6SOSwWjdX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHqsjkZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHqsjkZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE93AC4CEF1;
	Tue, 26 Aug 2025 14:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218874;
	bh=kBiADs6ypt3UL+HKpzOh8oEdD76p4qT2RdMzZwsktvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHqsjkZHVmw3+5e5Q+BWSubZqyekYzi1ZW9hwsd1S76s+Q0dxvWdWGFM9wNdCu7Oa
	 vJL3O0Pwv4BAZEn55ArqMMZ0lE8sSYkg2tZYAaXBvcRdxwsX1J/fZrHHPRWIlWG6rd
	 /DSyD9kEaDclqhEU7GC7X5v5Wa4W3BxiR53ErDe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 167/403] ACPI: processor: perflib: Move problematic pr->performance check
Date: Tue, 26 Aug 2025 13:08:13 +0200
Message-ID: <20250826110911.502037228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -183,7 +183,7 @@ void acpi_processor_ppc_init(struct cpuf
 		struct acpi_processor *pr = per_cpu(processors, cpu);
 		int ret;
 
-		if (!pr || !pr->performance)
+		if (!pr)
 			continue;
 
 		/*
@@ -200,6 +200,9 @@ void acpi_processor_ppc_init(struct cpuf
 			pr_err("Failed to add freq constraint for CPU%d (%d)\n",
 			       cpu, ret);
 
+		if (!pr->performance)
+			continue;
+
 		ret = acpi_processor_get_platform_limit(pr);
 		if (ret)
 			pr_err("Failed to update freq constraint for CPU%d (%d)\n",


