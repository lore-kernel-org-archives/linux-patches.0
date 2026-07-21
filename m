Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630EA3B52E2;
	Tue, 21 Jul 2026 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668487; cv=none; b=V+DQ6rOD76Zbk5Zb+SgsmorG604S5WVX4bNGplywzUTPKTrqtPRouwGm47VuHHbgBIsJfXTzIxQc9peS0TMG2SDiy6bedaGnVUbvqI+nFL3HpLh079yb3KfSLKRMx83fh/ftDgghq6C4GQ9Gy8cX/Y1FEdMNngDHHjA1ydG3YOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668487; c=relaxed/simple;
	bh=cCPuBEWW2uk7G69ErFPjFxf9GZ1MKU4Okiq1QGqSWOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6Nrdbz7PJZqCfjzvZW17EmkYYvpApj8VeiyD/jO5wDT+mCInL7nNaPOdpF7S0enMCzo+vVgdR6uP8IQSkEE1DLNvOnAq4AgIEfNGeasM1Suidd40StN+jAS/3rRyJu2vY14CcF1D/C1NBzDUPSidI9u99vacdrtiXVK1fiGcuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewacMy7e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewacMy7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B011F000E9;
	Tue, 21 Jul 2026 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668486;
	bh=QWfl/z0VZQARZoCNpQRwmNScAaxducWlPh1tcN5J058=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewacMy7eZKRG4wBQ6FdALDjDeS00re4mWNE46agNexQuJQ354YkcU5dMYMYcyA16m
	 IJQW7+VLxtUDkUestqdshz8ZVe2OisSjFGQkE3fRoBxuOOxE4IsFBrp8m4sykT+JFt
	 Kps9d8Oqrels6lH7x6K2sGm7E5t7NGC3hy4DaOCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 0151/1067] cpufreq: pcc: fix use-after-free and double free in _OSC evaluation
Date: Tue, 21 Jul 2026 17:12:32 +0200
Message-ID: <20260721152427.972718535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

commit 266d3dd8b757b48a576e90f018b51f7b7563cc32 upstream.

pcc_cpufreq_do_osc() calls acpi_evaluate_object() twice for the
two-phase _OSC negotiation. Between the two calls it freed
output.pointer but left output.length unchanged. Since
acpi_evaluate_object() treats a non-zero length with a non-NULL
pointer as an existing buffer to write into, the second call wrote
into freed memory (use-after-free). The subsequent kfree(output.pointer)
at out_free then freed the same pointer a second time (double free).

Reset output.pointer to NULL and output.length to ACPI_ALLOCATE_BUFFER
after freeing the first result, so ACPICA allocates a fresh buffer for
each phase independently.

Fixes: 0f1d683fb35d ("[CPUFREQ] Processor Clocking Control interface driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260416144621.93964-1-dbgh9129@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/pcc-cpufreq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -351,6 +351,8 @@ static int __init pcc_cpufreq_do_osc(acp
 	}
 
 	kfree(output.pointer);
+	output.pointer = NULL;
+	output.length = ACPI_ALLOCATE_BUFFER;
 	capabilities[0] = 0x0;
 	capabilities[1] = 0x1;
 


