Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0FA1946C8;
	Fri,  9 Jan 2026 12:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960169; cv=none; b=Uvu7QlAc+hj4Ujsp6uaEwxLlnPrx3Np+jTi4uLGfm77kMCCHgGYZXbRl20fbV8BkIEc06/4NOzXqkPIADPIbhFke3Qe2B1lY1xp7LExCVCzObTc4vB2RxlX5wBGO8iWoZUWiYhSj+m0V2qEP3PJUzLqd7dOgAFiwt4qEyPrC/+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960169; c=relaxed/simple;
	bh=NGfJWgMPHWHIVPh6ve6hX+pHrB0e52oSksfKk1sHTw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwRXl2GPnChl1nPL/eAGPTYYG7J0Ii3g/i5oxVGWi5/lRsKCLPOgaotqnYEzjQaVCvAwl70u90de4kExboOu9ovRuE/xHaNrvSicydKUlZHAR+cxyEDYyQUIvjgyNAp9OUDWOO4EWnH5KTpWf4ulZM6iFiNTw+1MJDgIYF10isA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmqEViYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmqEViYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC15C4CEF1;
	Fri,  9 Jan 2026 12:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960169;
	bh=NGfJWgMPHWHIVPh6ve6hX+pHrB0e52oSksfKk1sHTw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmqEViYkzAGxsO5yD0to6Ap/pE3KccIoqQUE1qtdPAh8YAQSZN/TJLdd7nAHIMv9e
	 l1lPXA1EiFj5HSSF5DERG0IW+msU8KNf64/vdMvL+en+BZfR8GFaGXkNcyebzpj6pn
	 VrgDcL2GMH754nsxeLSvKtmbNDN+UGSXrJ7YVl5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	WangYuli <wangyl5933@chinaunicom.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 309/737] ACPICA: Avoid walking the Namespace if start_node is NULL
Date: Fri,  9 Jan 2026 12:37:28 +0100
Message-ID: <20260109112145.628662539@linuxfoundation.org>
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

From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>

[ Upstream commit 9d6c58dae8f6590c746ac5d0012ffe14a77539f0 ]

Although commit 0c9992315e73 ("ACPICA: Avoid walking the ACPI Namespace
if it is not there") fixed the situation when both start_node and
acpi_gbl_root_node are NULL, the Linux kernel mainline now still crashed
on Honor Magicbook 14 Pro [1].

That happens due to the access to the member of parent_node in
acpi_ns_get_next_node().  The NULL pointer dereference will always
happen, no matter whether or not the start_node is equal to
ACPI_ROOT_OBJECT, so move the check of start_node being NULL
out of the if block.

Unfortunately, all the attempts to contact Honor have failed, they
refused to provide any technical support for Linux.

The bad DSDT table's dump could be found on GitHub [2].

DMI: HONOR FMB-P/FMB-P-PCB, BIOS 1.13 05/08/2025

Link: https://github.com/acpica/acpica/commit/1c1b57b9eba4554cb132ee658dd942c0210ed20d
Link: https://gist.github.com/Cryolitia/a860ffc97437dcd2cd988371d5b73ed7 [1]
Link: https://github.com/denis-bb/honor-fmb-p-dsdt [2]
Signed-off-by: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Reviewed-by: WangYuli <wangyl5933@chinaunicom.cn>
[ rjw: Subject adjustment, changelog edits ]
Link: https://patch.msgid.link/20251125-acpica-v1-1-99e63b1b25f8@linux.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nswalk.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/nswalk.c b/drivers/acpi/acpica/nswalk.c
index eee396a77baec..1b000ccbf8e1f 100644
--- a/drivers/acpi/acpica/nswalk.c
+++ b/drivers/acpi/acpica/nswalk.c
@@ -169,9 +169,12 @@ acpi_ns_walk_namespace(acpi_object_type type,
 
 	if (start_node == ACPI_ROOT_OBJECT) {
 		start_node = acpi_gbl_root_node;
-		if (!start_node) {
-			return_ACPI_STATUS(AE_NO_NAMESPACE);
-		}
+	}
+
+	/* Avoid walking the namespace if the StartNode is NULL */
+
+	if (!start_node) {
+		return_ACPI_STATUS(AE_NO_NAMESPACE);
 	}
 
 	/* Null child means "get first node" */
-- 
2.51.0



