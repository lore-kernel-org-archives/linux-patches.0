Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8C631ED6D;
	Fri,  9 Jan 2026 12:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962219; cv=none; b=it2R86LxC/2jRXj7Y0GdwBI5h0FGfjJ4dew7y8dqiOH2/wAiv3BaQAdXndT/KaaoexkWrojEk7EoVudk5dPXaXseQ//fmibHzVDAXBiXH/pR6au5XtIt5mpUWBWoSKVypf+NQ36+i1+5/WeA854C9oB8rajgzyEOzTnQUToR2Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962219; c=relaxed/simple;
	bh=QhwJBMHTpWQYi8+MrwLepyAEohxAfSbeUVQhmJfg2Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=My//3mx8gvTZOaZlPbs+ERL0/WjsQKwfyP9kgOPogl0i43qDWe563mqh6YTARvchGrQcEAh6ZMMqO6y4J7a7iaxzotrkXauf0ibsRUpY3iHGtjQRuAzH0+FWI4OpbGmsyyk3PQEf6Lgz7gJO7jdb4HY9MAxC8VycvfecxBT/CFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5dq3AQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5dq3AQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AAAC4CEF1;
	Fri,  9 Jan 2026 12:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962219;
	bh=QhwJBMHTpWQYi8+MrwLepyAEohxAfSbeUVQhmJfg2Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5dq3AQ2KPV1KvePp+A74W+tGL1q+YZBeTv8mt0PiN3ASx//5+AWQGUGO7sGAKXJa
	 y9UBZMxVydT7Z7Y1Kh0UPMjhdL2xwCEP1qkmoU0aeP+lOaMtlX0D6/G8SnycTRgLCC
	 Kolwkvha1IgyuOLdDieIWE+RLZLN+LqDujpFVlik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 289/634] ACPI: CPPC: Fix missing PCC check for guaranteed_perf
Date: Fri,  9 Jan 2026 12:39:27 +0100
Message-ID: <20260109112128.405250200@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Pengjie Zhang <zhangpengjie2@huawei.com>

commit 6ea3a44cef28add2d93b1ef119d84886cb1e3c9b upstream.

The current implementation overlooks the 'guaranteed_perf'
register in this check.

If the Guaranteed Performance register is located in the PCC
subspace, the function currently attempts to read it without
acquiring the lock and without sending the CMD_READ doorbell
to the firmware. This can result in reading stale data.

Fixes: 29523f095397 ("ACPI / CPPC: Add support for guaranteed performance")
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20251210132227.1988380-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1267,7 +1267,8 @@ int cppc_get_perf_caps(int cpunum, struc
 	/* Are any of the regs PCC ?*/
 	if (CPC_IN_PCC(highest_reg) || CPC_IN_PCC(lowest_reg) ||
 		CPC_IN_PCC(lowest_non_linear_reg) || CPC_IN_PCC(nominal_reg) ||
-		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg)) {
+		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg) ||
+		CPC_IN_PCC(guaranteed_reg)) {
 		if (pcc_ss_id < 0) {
 			pr_debug("Invalid pcc_ss_id\n");
 			return -ENODEV;


