Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9D2439010;
	Tue, 21 Jul 2026 21:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671113; cv=none; b=IHT45Al/OtBDdofY3GVKdrusDCfziwLlaynL8BWP0xMNt4tXvf4ANPre5+17pHjagD5xg2BbYwO80zMaYXaRsaiFnGXXRH+GvQPTYW7EqHzWqstUS9F9SSigbJauJ6Y6apJ3pAFZQk5V3WAxna/wNIVftN2GCCPN+e7dVqpL0Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671113; c=relaxed/simple;
	bh=qzZW3GtXUZEankUrwnipDl0bx8KkXsdAM0zJJak2ij8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAJqC34vY3cjBJeH8GdBHxpt319VHbyWLp3BLZ8AQuMZAf3bsMOPinuq1BMsfjNTSf2UnZa0VQ9vyk71k6odZjLClgTFLUhyQh4AeI/+iQULUDl0KBqNRDwzhKhnNiI2mkLnUy0MU+Zcjw820fJDzY/n40+CROrmvMtRxleH29U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1Aq8Kcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1Aq8Kcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17591F00A3A;
	Tue, 21 Jul 2026 21:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671106;
	bh=5jXEXNml92mKJosYvbWW6/7ZjBLMOOxFS7QqCIG/SZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1Aq8KcjR61bSNZYlVrOkzeOSGTN2po1rseSNsgMIvUMtz0a4y53mes94dAbDZtfx
	 NIFZOvSWsG77WFJHmsQV45WWl/hO5iwjmnXGM2h2utvKYVEoFp1jz4zchggzIVB7bI
	 G5FaxmwF5mwm3h0k//uDWtFA9yYSYVXdbO+xfguw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 119/843] cpufreq: pcc: fix use-after-free and double free in _OSC evaluation
Date: Tue, 21 Jul 2026 17:15:54 +0200
Message-ID: <20260721152408.681123815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
 


