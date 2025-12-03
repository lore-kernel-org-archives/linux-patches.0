Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2C83596FA;
	Wed,  3 Dec 2025 16:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779852; cv=none; b=hPrOmDifkVQOTY7+HwqRjxhpKbUvfhnklEBLayVfmpNhyA/aEX/c+g9zmdY16niDzXoZblAzwkn1QZzFvDUtByr0nsy0npf+BWkRWNWxwbaW0VdKX/HV9QABFc24KYIyWQxlI/gC7Nt2WBD61dgJmxXsln1pXoah14rZcVD7pqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779852; c=relaxed/simple;
	bh=Kdgqn2spV+yEMPGnku/amilGEdfeeXGeG0CFYpxqp6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBT7uxjjuQgFhVsW0VA7hd8sirc5OFxYJ7q2aP4nzhiP+VtY/wVhjA99Bzny4C/5u7A8YovL6ZIm3rWkkTcIRB0jPj+XSpEw/pHnodm6qy30wLy72ZaASaYEgCKmUqGX9mfWZSNj4IUSOEQuj5TwJvs9ock0l2/COG6IzqSJoa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4Z6Foqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4Z6Foqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459C5C4CEF5;
	Wed,  3 Dec 2025 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779852;
	bh=Kdgqn2spV+yEMPGnku/amilGEdfeeXGeG0CFYpxqp6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4Z6FoqhjsXGnNtA2fPYEzcauslj3/MkD4MoNKMjHIj6uO6XKLNoEv6jxgg9jy8TK
	 YMl56sXHxIeCp9yvRjWW2TSGGq/WSctsoP8a/cZ2SmQb2vr8ajUKhRZ8LrW9eodCVz
	 g7IFOZNt+prIjUvZxOcmkMtZ1RHfM+74Zy6sdoC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Zongyong <wuzongyong@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 380/568] acpi,srat: Fix incorrect device handle check for Generic Initiator
Date: Wed,  3 Dec 2025 16:26:22 +0100
Message-ID: <20251203152454.614745214@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 7c3643f204edf1c5edb12b36b34838683ee5f8dc ]

The Generic Initiator Affinity Structure in SRAT table uses device
handle type field to indicate the device type. According to ACPI
specification, the device handle type value of 1 represents PCI device,
not 0.

Fixes: 894c26a1c274 ("ACPI: Support Generic Initiator only domains")
Reported-by: Wu Zongyong <wuzongyong@linux.alibaba.com>
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20250913023224.39281-1-xueshuai@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/srat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index a44c0761fd1c0..848942bf883cb 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -140,7 +140,7 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 		struct acpi_srat_generic_affinity *p =
 			(struct acpi_srat_generic_affinity *)header;
 
-		if (p->device_handle_type == 0) {
+		if (p->device_handle_type == 1) {
 			/*
 			 * For pci devices this may be the only place they
 			 * are assigned a proximity domain
-- 
2.51.0



