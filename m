Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB241946C8;
	Fri,  9 Jan 2026 12:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960363; cv=none; b=A7q9e3YG28QA9+fkniSVHzeAfq5lUith0iT95PfZD34Hsj3y6VLPJ6ff1GkurYH9H8xHcizCx+cjzGTJ6bVNjfqnKHX+yLhGyROmg2mCDvy8ZDDcuVh2ItvAUpc614kfBdYpKs7Z5ivv6KDwimxwRl5FVVt19lv9hGI0CDfp+WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960363; c=relaxed/simple;
	bh=/BDkqTGPuFOG//mEKeH6hPcYAJX3bjbEQzkNvs790PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV5lJIG3HG2Kyl8BCJdT/NbBPh/URu+rXve33q7jY6ovlf5pJbbNoLY+90Suwuiq9B8m4nJuxnF0ybUKlIrgXDjs8xiEe/9/p8+YxwtBPDvO/3gjvzVbJ8gRsv6PjtTzGUdtWuxN4aJd6zBZK44CwIm+AH9xtw9nVlrULyC9jQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUm/DC9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUm/DC9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47ACC4CEF1;
	Fri,  9 Jan 2026 12:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960363;
	bh=/BDkqTGPuFOG//mEKeH6hPcYAJX3bjbEQzkNvs790PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUm/DC9B0DHw1AYlaK4Xk6NhrVEId9pDG97/Bq6qPJMrr7PNH85hW7EUSUflyc6KP
	 n1VcfeN8Y2kr5Kg8fWUwnzktPBEon9J5Pq8Br11OaSj0hqRnjW0x0YriJHT419Gxo0
	 v9NL9v95++OJ1o5c4aMgt2SvFZZUZmq3kDriymrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 377/737] ACPI: CPPC: Fix missing PCC check for guaranteed_perf
Date: Fri,  9 Jan 2026 12:38:36 +0100
Message-ID: <20260109112148.177037130@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1299,7 +1299,8 @@ int cppc_get_perf_caps(int cpunum, struc
 	/* Are any of the regs PCC ?*/
 	if (CPC_IN_PCC(highest_reg) || CPC_IN_PCC(lowest_reg) ||
 		CPC_IN_PCC(lowest_non_linear_reg) || CPC_IN_PCC(nominal_reg) ||
-		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg)) {
+		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg) ||
+		CPC_IN_PCC(guaranteed_reg)) {
 		if (pcc_ss_id < 0) {
 			pr_debug("Invalid pcc_ss_id\n");
 			return -ENODEV;


