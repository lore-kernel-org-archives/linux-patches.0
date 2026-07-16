Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8B37E5CB;
	Thu, 16 Jul 2026 13:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209626; cv=none; b=lSINnJIBrqsNI738FmmnOrqXFEkOfBsEEb+pbI8JZX/Bw/SvpT+POw9IJuk31PFLboUldk33K6g8R6CBPm2MzJJR+BoYirpAoFEpDm4Pnl8u7B+bOxb4cge8vx51p/Nnh8alpLZToBVvJ26faVPZSjLU2YBIf4UAS3VX0908GPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209626; c=relaxed/simple;
	bh=aXjOE3x6DLrrtG5VjBdynjgtiSWq+ON6MwAPfSX7WKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ET7OwUnst0Rt6NMWvhxNptBljeqmn7/9Tz/3iadNooRc9jNS5/IgD57b4pInXSfZn3EhK7h7hglVuAEcQ8WOv74ZaxivWAU0ak53eAityssFNSP76/rmuuE1lKZknjE7+vjne99ACUNNoq2n5QjHi3cQ4adkzAAaBoQWEBrY5xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3Yfx8Qc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3Yfx8Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4851F00A3F;
	Thu, 16 Jul 2026 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209623;
	bh=jeCXQn1z5SLkbSg7fkqEFkNod680NlhZnPuvcS320WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3Yfx8QcX1EOToeRgDfU5YgWNKd8uQD5oFm7Zik/IpP73ZU/WrSfOc3LR1V/eiHDE
	 9LDxBMlDkSpQ6K2Dg26UpLPCnXqxS6frFjBPjWwgZwTeEk35K3s/wKQ/UraZT/b7qI
	 ZOJzDDns/CcdPGiKGjKKrYHPuJCBFyRz2aveHgCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.1 254/518] cpufreq: pcc: fix use-after-free and double free in _OSC evaluation
Date: Thu, 16 Jul 2026 15:28:42 +0200
Message-ID: <20260716133053.375344571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -352,6 +352,8 @@ static int __init pcc_cpufreq_do_osc(acp
 	}
 
 	kfree(output.pointer);
+	output.pointer = NULL;
+	output.length = ACPI_ALLOCATE_BUFFER;
 	capabilities[0] = 0x0;
 	capabilities[1] = 0x1;
 


