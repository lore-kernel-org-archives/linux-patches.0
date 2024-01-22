Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5649D12AAF1;
	Tue, 23 Jan 2024 00:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968797; cv=none; b=F48tbTgIxOaPDSOsTlqAZIE7qNb1SX1gYBfQB+z5pdRZpHVmH4XqqbXuEo+L9oF6Z6MHTqZwXJxcbkwjR0hh1DeFAK99T0/imqN7gKxZobCor99Rmf2AzNcPvB/rH3WOkI029a8wAVZUDzTuv2+h7X3fhrea47QuJRUh/G+pINk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968797; c=relaxed/simple;
	bh=j3iLJEQ2pSSqLqkr8ntM5eyhZ2TPpva4bYaxSp0g3Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rcm4o1VnzpVUGHlTIS1fYUcERCUzxSU+UswuoK7L2qC+luGQ43zxsKo/exLZ+qVEl1PR7YW8yYfNDnpSKKvwcu99m4J4a2r5qMvu8U1J/lGR588Dq+ecQX2P2LY/O8baKcuu42k89GwxqXRBRUulKQIcu2H9Aoh1IPVTmfAdqSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVuluGDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVuluGDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC56C433C7;
	Tue, 23 Jan 2024 00:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968796;
	bh=j3iLJEQ2pSSqLqkr8ntM5eyhZ2TPpva4bYaxSp0g3Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVuluGDCPM8SXn6rzxN7VeM1hgU8TJG/30KrOlgBI3nRz9uxotvCblfyHbmqHdRYm
	 DH/MS578qH0peSqkyzUQEPWHK/ZDjbaZGNNTRtGP+PvtVonjqJ6K5IecVsH1kpLaPs
	 PsSEpwioMyvmyO40j0emvlzj9HQfy7qU4Uu8Hfe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/194] ACPI: LPIT: Avoid u32 multiplication overflow
Date: Mon, 22 Jan 2024 15:56:23 -0800
Message-ID: <20240122235721.475127060@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nikita Kiryushin <kiryushin@ancud.ru>

[ Upstream commit 56d2eeda87995245300836ee4dbd13b002311782 ]

In lpit_update_residency() there is a possibility of overflow
in multiplication, if tsc_khz is large enough (> UINT_MAX/1000).

Change multiplication to mul_u32_u32().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: eeb2d80d502a ("ACPI / LPIT: Add Low Power Idle Table (LPIT) support")
Signed-off-by: Nikita Kiryushin <kiryushin@ancud.ru>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_lpit.c b/drivers/acpi/acpi_lpit.c
index 433376e819bb..c79266b8029a 100644
--- a/drivers/acpi/acpi_lpit.c
+++ b/drivers/acpi/acpi_lpit.c
@@ -98,7 +98,7 @@ static void lpit_update_residency(struct lpit_residency_info *info,
 				 struct acpi_lpit_native *lpit_native)
 {
 	info->frequency = lpit_native->counter_frequency ?
-				lpit_native->counter_frequency : tsc_khz * 1000;
+				lpit_native->counter_frequency : mul_u32_u32(tsc_khz, 1000U);
 	if (!info->frequency)
 		info->frequency = 1;
 
-- 
2.43.0



