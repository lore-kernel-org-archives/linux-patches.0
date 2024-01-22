Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401ADDDB5;
	Tue, 23 Jan 2024 00:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968191; cv=none; b=Qh8UaHI5afsKIC9DsnUonSDK1I+f0Ynl2EaYGAc7Aq2+A20idA29nINKVMS1wfmorlY/R6ty9b6h93Q7g/g+0Br2Lj4BdcdtqXssJN0mdoqlBW7VxtvOoOtRfwkk/WoA3/6X/2qJE5HeZ5jqsFC5MHq+3WfH+FfYF5jUjVsScNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968191; c=relaxed/simple;
	bh=ZKMJGGsdUu7FpyQxsyLgl5t3/7hO0kwGR5On6mTJhVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfHjlS3kjuFS3oaSS9D0wCXRJA/zGqgT27hkib0dSZNBk4zmFeyp8A2ICC22jgiw4kOQOYfrrwBxxe7Hocl8F6jq4rtz1GO/E35essRSIH02H12AlDOGQDDFwVjOOoP2D/5aZVvp6YjTTljY1Wwl7W/I7Wch5glUfkqAX2OkFXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjW4QSdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjW4QSdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1869C433F1;
	Tue, 23 Jan 2024 00:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968191;
	bh=ZKMJGGsdUu7FpyQxsyLgl5t3/7hO0kwGR5On6mTJhVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjW4QSdUwFopZ/P4s+AnMSoWqmf9E0TE9eyQEgpmwQjT6qUkOkpdHZWVBuQ5NC7Vy
	 3rEAeYqcgxblcwpoEIJBV5DvCsMHoT11OuWrs+DpWIra/300wqeCcBTh8Jeer5jp4h
	 95zmud3NyOZ6NHntSCGDJyzepzKJ7CU1Xa2gFL1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/148] ACPI: LPIT: Avoid u32 multiplication overflow
Date: Mon, 22 Jan 2024 15:56:35 -0800
Message-ID: <20240122235713.992727729@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e43cb71b6972..c39c56904c52 100644
--- a/drivers/acpi/acpi_lpit.c
+++ b/drivers/acpi/acpi_lpit.c
@@ -106,7 +106,7 @@ static void lpit_update_residency(struct lpit_residency_info *info,
 				 struct acpi_lpit_native *lpit_native)
 {
 	info->frequency = lpit_native->counter_frequency ?
-				lpit_native->counter_frequency : tsc_khz * 1000;
+				lpit_native->counter_frequency : mul_u32_u32(tsc_khz, 1000U);
 	if (!info->frequency)
 		info->frequency = 1;
 
-- 
2.43.0



