Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6363E269892;
	Tue,  8 Apr 2025 12:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116005; cv=none; b=M34ZeYQbvlaocJGnCmZwEg398y/exVJ+nI0q9YcvXSv3tVl7SRi4y3nAWrgyh+jmzlJJmvXtbm+I/Bf05o4UTS1M7VqgiK5x6AMchk8tV2zjPRB+7ozhkcyX3Eq7dADpoe281qRLpywb1I6o3Z1p2+vg1waMRuBsbgGIup+8EU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116005; c=relaxed/simple;
	bh=+C9ke1oh3OnV8th4ULVVpIxtbmFlmdHT7qqIpy0muA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbvhjnNSdRtu34mQIVsxKU16legMa/koFXJ8BSmfkhAWR53eEK9gN5xJq3sjCbmMaIsBTDdPzx7/CR0Ykswc2OWFmluGCK591EN/U3KYMhqILRyn0Tve9ZQ/hMCbYfLEce0OiQXWWJFZfA2T/9X+c1FWY0aLcF7DMC7mxNVjSaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPlB1F2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPlB1F2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9655C4CEE5;
	Tue,  8 Apr 2025 12:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116005;
	bh=+C9ke1oh3OnV8th4ULVVpIxtbmFlmdHT7qqIpy0muA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPlB1F2jJzrASQUw113Urwcm8KSE7T13clHoKyK/Rxk5fLDrElw7s37QRpYV9Qd2u
	 XLew27opGjV5Qu3OagUb0ya6gyIYOE8AyfVT8SyQ6FXAaRPp4T0gKtXC7Cr5mfRkEw
	 7+nbL4SHBWPTfzmEg1C+OuWlZajAU1D7mBRvPKWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c80d8dc0d9fa81a3cd8c@syzkaller.appspotmail.com,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH 6.1 185/204] acpi: nfit: fix narrowing conversion in acpi_nfit_ctl
Date: Tue,  8 Apr 2025 12:51:55 +0200
Message-ID: <20250408104825.746145969@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

From: Murad Masimov <m.masimov@mt-integration.ru>

commit 2ff0e408db36c21ed3fa5e3c1e0e687c82cf132f upstream.

Syzkaller has reported a warning in to_nfit_bus_uuid(): "only secondary
bus families can be translated". This warning is emited if the argument
is equal to NVDIMM_BUS_FAMILY_NFIT == 0. Function acpi_nfit_ctl() first
verifies that a user-provided value call_pkg->nd_family of type u64 is
not equal to 0. Then the value is converted to int, and only after that
is compared to NVDIMM_BUS_FAMILY_MAX. This can lead to passing an invalid
argument to acpi_nfit_ctl(), if call_pkg->nd_family is non-zero, while
the lower 32 bits are zero.

Furthermore, it is best to return EINVAL immediately upon seeing the
invalid user input.  The WARNING is insufficient to prevent further
undefined behavior based on other invalid user input.

All checks of the input value should be applied to the original variable
call_pkg->nd_family.

[iweiny: update commit message]

Fixes: 6450ddbd5d8e ("ACPI: NFIT: Define runtime firmware activation commands")
Cc: stable@vger.kernel.org
Reported-by: syzbot+c80d8dc0d9fa81a3cd8c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c80d8dc0d9fa81a3cd8c
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Link: https://patch.msgid.link/20250123163945.251-1-m.masimov@mt-integration.ru
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/nfit/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -485,7 +485,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_desc
 		cmd_mask = nd_desc->cmd_mask;
 		if (cmd == ND_CMD_CALL && call_pkg->nd_family) {
 			family = call_pkg->nd_family;
-			if (family > NVDIMM_BUS_FAMILY_MAX ||
+			if (call_pkg->nd_family > NVDIMM_BUS_FAMILY_MAX ||
 			    !test_bit(family, &nd_desc->bus_family_mask))
 				return -EINVAL;
 			family = array_index_nospec(family,


