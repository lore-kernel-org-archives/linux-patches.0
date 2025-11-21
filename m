Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B134345750;
	Fri, 21 Nov 2025 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731749; cv=none; b=qWCwt9BknrNPdt5yfMjDFgi+syQhvYKDKrtir3iHpbmzstaCT7lwGmXijrNGb6Dcj4E5TChpjFZODH0uSvAEo1+BZw7dMfMXKTXMM9WdIpp5ohE8+gGANfoplkvgXiW6oUQh4FLMOvhJU48n0d2Ef8tz+b/zg0hglI5p3/q7hig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731749; c=relaxed/simple;
	bh=DGv+/3nQAjcvMrrUIkx5SMaVd3FnwSRwAnEUJPWN9b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9E1P+AnUbupnnZu5XA9ZFRUO0g8wOHpQLHMqhZAbcTkFb0ThYuN0UW6hDENFEv5IoMxyeVj3QaM9grFzUog5/Cfi7aL1MUI5f5j7kR7Hjdshf1HqwfaT2uzH/zIJr1NzsAQMUUx2O6RbJ9uJ5qIVylM47sRkKbFgT1eYvBtcZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUwLjE7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUwLjE7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AEBC4CEF1;
	Fri, 21 Nov 2025 13:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731749;
	bh=DGv+/3nQAjcvMrrUIkx5SMaVd3FnwSRwAnEUJPWN9b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUwLjE7IcEXw9fBRQTPNXnYlgocg4p5OdEf3tSghwONYNpcDNdZaUuwjJyzl1dA+j
	 0XgNv7icHF8LlvC24to+HuVpb/Q00LN51/uUprFdhBnuLBftFNDqmDvHAv9LnKgDcF
	 WZLXT3mTUesBbhEjh+U50dNSrQyMjg39WQs4Ut/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Zongyong <wuzongyong@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/185] acpi,srat: Fix incorrect device handle check for Generic Initiator
Date: Fri, 21 Nov 2025 14:11:34 +0100
Message-ID: <20251121130146.293983493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bec0dcd1f9c38..dccdc062d8aa3 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -143,7 +143,7 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 		struct acpi_srat_generic_affinity *p =
 			(struct acpi_srat_generic_affinity *)header;
 
-		if (p->device_handle_type == 0) {
+		if (p->device_handle_type == 1) {
 			/*
 			 * For pci devices this may be the only place they
 			 * are assigned a proximity domain
-- 
2.51.0



